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
    
    func updateWeatherFor(cityName: String?, with json: JSON) -> Bool {
        var isSuccess = false
        let backgroundContext = self.persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.undoManager = nil
        
        backgroundContext.performAndWait {
            let req = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
            if let name = cityName {
                req.predicate = NSPredicate(format: "name == %@", name)
            }
            do {
                let citiesForUpdate = try backgroundContext.fetch(req) as? [City]
                if let cities = citiesForUpdate,
                    let cityForUpdate = cities.first {
                    cityForUpdate.update(with: json)
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
    
    func updateForecastFor(cityName: String?, with json: JSON) -> Bool {
        var isSuccess = false
        let backgroundContext = self.persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.undoManager = nil
        
        backgroundContext.performAndWait {
            let req = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
            if let name = cityName {
                req.predicate = NSPredicate(format: "name == %@", name)
            }
            do {
                let citiesForUpdate = try backgroundContext.fetch(req) as? [City]
                if let cities = citiesForUpdate,
                    let cityForUpdate = cities.first,
                    let forecast = cityForUpdate.forecast {
                    for counter in 0..<40 {
                        let jsonWeather = json["list"][counter]
                        if let weather = forecast.object(at: counter) as? Weather {
                            weather.update(with: jsonWeather)
                        }
                    }
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
    
    func createNewCity(with json: JSON) -> Bool {
        var isSuccess = false
        let backgroundContext = self.persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.undoManager = nil
        
        backgroundContext.performAndWait {
            guard let city = NSEntityDescription.insertNewObject(forEntityName: "City", into: backgroundContext) as? City else { return }
            guard let weather = NSEntityDescription.insertNewObject(forEntityName: "Weather", into: backgroundContext) as? Weather else { return }
            city.currentWeather = weather
            weather.city = city
            
            for _ in 0..<5 {
                guard let dayAndNightWeather = NSEntityDescription.insertNewObject(forEntityName: "DayAndNightWeather", into: backgroundContext) as? DayAndNightWeather else { return }
                dayAndNightWeather.city = city
                city.addToDayAndNightWeather(dayAndNightWeather)
            }
            
            for _ in 0..<40 {
                guard let weather = NSEntityDescription.insertNewObject(forEntityName: "Weather", into: backgroundContext) as? Weather else { return }
                weather.cityForecast = city
                city.addToForecast(weather)
            }
            
            city.update(with: json)
            do {
                try backgroundContext.save()
                isSuccess = true
            } catch {
                isSuccess = false
            }
            backgroundContext.reset()
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
