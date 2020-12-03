//
//  DataManager.swift
//  WeatherForecast
//
//  Created by Дарья Леонова on 02.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

enum DataManagerError {
    case noData
    case noConnection
    case wrongURL
    case dataBaseError
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
    
    let dataBase: DataBaseProtocol
    let forecastHour: Int = 15
    
    var context: NSManagedObjectContext {
        return dataBase.context
    }
    
    init(dataBase: DataBaseProtocol) {
        self.dataBase = dataBase
    }
    
    //MARK: - Weather -
    
    func updateAllWeather(completion: @escaping DataManagerCompletionHandler) {
        let cities = dataBase.getCurrentCities()
        cities.forEach { updateWeather(forCity: $0, completion: completion) }
    }
    
    private func updateWeather(forCity city: City, completion: @escaping DataManagerCompletionHandler) {
        guard let lat = city.lat,
              let lon = city.lon else {
            completion(.wrongCoordinates)
            return
        }
        let coordinates = Coordinates(lat: lat, lon: lon)
        NetworkManager.getData(forCityWith: coordinates) { (data, dataManagerError) in
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
                if self.dataBase.updateWeatherForCityWith(cordinates: coordinates, with: json) {
                    completion(nil)
                } else {
                    completion(.dataBaseError)
                }
            } catch {
                completion(.jsonError)
                return
            }
        }
    }
    
    func addNewCity(with cityInfo: CityInfo, completion: @escaping DataManagerCompletionHandler) {
      
        dataBase.createNewCity(by: cityInfo, completion: { (success) in
            guard success else {
                completion(.dataBaseError)
                return
            }
            NetworkManager.getData(forCityWith: cityInfo.coordinates) { (data, dataManagerError) in
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
                    if self.dataBase.updateWeatherForCityWith(cordinates: cityInfo.coordinates, with: json) {
                        completion(nil)
                    } else {
                        completion(.dataBaseError)
                    }
                } catch {
                    completion(.jsonError)
                    return
                }
            }
        })
       
    }
    
    //MARK: - APOD
    func getAPOD(completion: @escaping DataManagerCompletionHandler) {
        NetworkManagerNASA.getData { (data, error) in
            if error != nil {
                completion(error)
            }
            guard let data = data else {
                completion(.noData)
                return
            }
            do {
                let json = try JSON(data: data)
                if self.dataBase.updateAPOD(with: json) {
                    completion(nil)
                } else {
                    completion(.dataBaseError)
                }
            } catch {
                completion(.jsonError)
            }
        }
    }
    
}
