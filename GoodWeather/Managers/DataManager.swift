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
    
    func getCurrentWeather(completion: @escaping DataManagerCompletionHandler) {
        let cities = dataBase.getCurrentCities()
        for city in cities {
            getCurrentWeather(forCity: city) { (error) in
                completion(error)
            }
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
                if self.dataBase.updateWeatherFor(cityName: name, with: json) {
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
                if self.dataBase.updateForecastFor(cityName: name, with: json) {
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
            if self.dataBase.createNewCity(with: json) {
                completion(nil)
            } else {
                completion(.dataBaseError)
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
    
    func addNewCity(withCoordinates coordinates: CLLocationCoordinate2D?, completion: @escaping DataManagerCompletionHandler) {
        guard let coordinates = coordinates else { return }
        let request = Request(cityName: nil, lat: String(coordinates.latitude), lon: String(coordinates.longitude), requestType: .weather)
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

//MARK: - DateFormatter
extension DateFormatter {
    
    static func timeDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
    
    static func dateDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateStyle = .none
        dateFormatter.dateFormat = "dd/MM"
        return dateFormatter
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        
        return ceil(boundingBox.width)
    }
    
}
