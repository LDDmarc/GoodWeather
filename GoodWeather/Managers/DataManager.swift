//
//  DataManager.swift
//  WeatherForecast
//
//  Created by Дарья Леонова on 02.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//
// swiftlint:disable trailing_whitespace
import Foundation
import CoreData
import SwiftyJSON

enum DataManagerError {
    case noData
    case noConnection
    case wrongURL
    case coreDataError
    case jsonError
    case wrongName
    case wrongCoordinates
    
    func errorTitleMessage() -> (String?, String?) {
        switch self {
        case .noData:
            return ("Нет соединения", "Попробуйте повторить запрос позже")
        case .noConnection:
            return ("Нет соединения", "Попробуйте повторить запрос позже")
        case .wrongName:
            return ("Неверное имя", "К сожалению, мы не знаем такого места :(")
        case .wrongURL:
            return ("Неверное имя", "К сожалению, мы не знаем такого места :(")
        default:
            return(nil, nil)
        }
    }
}

typealias DataManagerCompletionHandler = (DataManagerError?) -> Void

class DataManager {
    
    let forecastHour: Int = 15
   
    private let persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func getCurrentWeather(completion: @escaping DataManagerCompletionHandler) {
        let request = NSFetchRequest<City>(entityName: "City")
        do {
            let cities = try context.fetch(request)
            for city in cities {
                getCurrentWeather(forCity: city) { (error) in
                    completion(error)
                }
            }
        } catch {
            completion(.coreDataError)
            return
        }
    }
    
    private func getCurrentWeather(forCity city: City, completion: @escaping DataManagerCompletionHandler) {
        guard let name = city.name else {
            completion(.wrongName)
            return
        }
        let request = Request(cityName: name, lat: nil, lon: nil, requestType: .weather)
        NetworkManager.getData(forRequest: request) { (data, dataManagerError) in
            if dataManagerError != nil {
                completion(dataManagerError)
                return
            }
            guard let data = data else {
                completion(.noData)
                return
            }
            do {
                let json = try JSON(data: data)
                self.updateCityWeather(cityName: name, with: json) { (error) in
                    completion(error)
                }
            } catch {
                completion(.jsonError)
                return
            }
        }
    }
    
    func getForecast(forCity city: City, completion: @escaping DataManagerCompletionHandler) {
        guard let name = city.name else {
            completion(.wrongName)
            return
        }
        let request = Request(cityName: name, lat: nil, lon: nil, requestType: .forecast)
        NetworkManager.getData(forRequest: request) { (data, dataManagerError) in
            if dataManagerError != nil {
                completion(dataManagerError)
                return
            }
            guard let data = data else {
                completion(.noData)
                return
            }
            do {
                let json = try JSON(data: data)
                self.updateCityForecast(cityName: name, with: json) { (error) in
                    completion(error)
                }
            } catch {
                completion(.jsonError)
                return
            }
        }
    }
    
    private func updateCityWeather(cityName: String?, with json: JSON, completion: @escaping DataManagerCompletionHandler) {
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
                completion(nil)
            } catch {
                completion(.coreDataError)
                return
            }
        }
    }
    
    private func updateCityForecast(cityName: String?, with json: JSON, completion: @escaping DataManagerCompletionHandler) {
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
                completion(nil)
            } catch {
                completion(.coreDataError)
                return
            }
        }
    }
    
    private func createCity(with data: Data?, error dataManagerError: DataManagerError?, completion: @escaping DataManagerCompletionHandler) {
        if dataManagerError != nil {
            completion(dataManagerError)
            return
        }
        guard let data = data else {
            completion(.noData)
            return
        }
        do {
            let json = try JSON(data: data)
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
                    completion(nil)
                } catch {
                    completion(.coreDataError)
                }
                backgroundContext.reset()
            }
        } catch {
            completion(.jsonError)
        }
    }
    
    func addNewCity(withName name: String?, completion: @escaping DataManagerCompletionHandler) {
        guard let name = name else { return }
        let request = Request(cityName: name, lat: nil, lon: nil, requestType: .weather)
        NetworkManager.getData(forRequest: request) { (data, dataManagerError) in
            if dataManagerError != nil {
                completion(dataManagerError)
                return
            }
            self.createCity(with: data, error: dataManagerError) { (error) in
                completion(error)
            }
        }
    }
    
    func getCurrentWeather(forLat lat: String, forLon lon: String, completion: @escaping DataManagerCompletionHandler) {
        let request = Request(cityName: nil, lat: lat, lon: lon, requestType: .weather)
        NetworkManager.getData(forRequest: request) { (data, dataManagerError) in
            self.createCity(with: data, error: dataManagerError) { (error) in
                completion(error)
            }
        }
    }
}

extension DateFormatter {
    
    static func timeDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
    
    static func dateDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .none
        dateFormatter.dateFormat = "dd/MM"
        return dateFormatter
    }
}
