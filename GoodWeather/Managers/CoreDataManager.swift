//
//  CoreDataManager.swift
//  WeatherForecast
//
//  Created by Дарья Леонова on 02.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() { }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GoodWeather")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                print(error.localizedDescription)
            }
        }
    }
}

extension CoreDataManager: DataBaseProtocol {
    
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
