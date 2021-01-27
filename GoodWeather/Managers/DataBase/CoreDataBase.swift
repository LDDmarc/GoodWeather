//
//  CoreDataBase.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 18.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

//MARK: -WeatherDataBaseProtocol

class CoreDataBase: DataBaseProtocol {
    
    private let persistentContainer: NSPersistentContainer = CoreDataManager.shared.persistentContainer
    var context = CoreDataManager.shared.persistentContainer.viewContext
    
    func getCurrentCities() -> [City] {
        let request = NSFetchRequest<City>(entityName: "City")
        do {
            let cities = try persistentContainer.viewContext.fetch(request)
            return cities
        } catch {
            return []
        }
    }
    
    func createNewCity(by info: CityInfo, completion: @escaping WeatherDataBaseCompletionHandler) {
        var isSuccess = false
        defer { completion(isSuccess) }
        
        let request = NSFetchRequest<City>(entityName: "City")
        request.predicate = NSPredicate(format: "id = %i", info.id)
        if let cities = try? persistentContainer.viewContext.fetch(request), !cities.isEmpty {
            isSuccess = true
            return
        }
        
        let backgroundContext = self.persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.undoManager = nil
        
        backgroundContext.performAndWait {
            
            
            guard let city = NSEntityDescription.insertNewObject(forEntityName: "City", into: backgroundContext) as? City else { return }
            city.update(with: info)
            
            guard let weather = NSEntityDescription.insertNewObject(forEntityName: "Weather", into: backgroundContext) as? Weather else { return }
            city.currentWeather = weather
            weather.city = city
            
            for _ in 0..<7 {
                guard let weather = NSEntityDescription.insertNewObject(forEntityName: "Weather", into: backgroundContext) as? Weather else { return }
                weather.cityDailyForecast = city
                city.addToDailyForecast(weather)
            }
            
            for _ in 0..<23 {
                guard let weather = NSEntityDescription.insertNewObject(forEntityName: "Weather", into: backgroundContext) as? Weather else { return }
                weather.cityHourlyForecast = city
                city.addToHourlyForecast(weather)
            }
            
            do {
                try backgroundContext.save()
                isSuccess = true
            } catch {
                isSuccess = false
            }
            backgroundContext.reset()
        }
    }
    
    func updateWeatherForCityWith(cordinates: Coordinates, with json: JSON) -> Bool {
        var isSuccess = false
        
        let backgroundContext = self.persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.undoManager = nil
        
        backgroundContext.performAndWait {
            let req = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
            req.predicate = NSPredicate(format: "lat == %@ AND lon == %@", cordinates.lat, cordinates.lon)
            
            do {
                let citiesForUpdate = try backgroundContext.fetch(req) as? [City]
                if let cities = citiesForUpdate,
                   let cityForUpdate = cities.first {
                    cityForUpdate.updateWeather(with: json)
                }
                if backgroundContext.hasChanges {
                    try backgroundContext.save()
                    backgroundContext.reset()
                }
                isSuccess = true
            } catch {
                isSuccess = false
            }
        }
        
        return isSuccess
    }
    
    //MARK: -APODDataBaseProtocol
    func updateAPOD(with json: JSON) -> Bool {
        var isSuccess = false
        let backgroundContext = self.persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.undoManager = nil
        
        backgroundContext.performAndWait {
            let req = NSFetchRequest<NSFetchRequestResult>(entityName: "APOD")
            do {
                let fetchedAPOD = try backgroundContext.fetch(req) as? [APOD]
                if let apod = fetchedAPOD?.first {
                    apod.update(with: json)
                } else {
                    guard let apod = NSEntityDescription.insertNewObject(forEntityName: "APOD", into: backgroundContext) as? APOD else { return }
                    apod.update(with: json)
                }
                if backgroundContext.hasChanges {
                    try backgroundContext.save()
                    backgroundContext.reset()
                }
                isSuccess = true
            } catch {
                isSuccess = false
            }
        }
        return isSuccess
    }
    
}
