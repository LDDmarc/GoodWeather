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

class CoreDataBase: DataBaseProtocol {
    
    private let persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
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
}
