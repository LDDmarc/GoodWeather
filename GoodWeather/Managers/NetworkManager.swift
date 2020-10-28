//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by Дарья Леонова on 02.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//
import Foundation
import SwiftyJSON

typealias NetworkCompletionHandler = (Data?, DataManagerError?) -> Void

enum RequestType {
    case weather
    case forecast
    case onecall
    
    func path() -> String {
        switch self {
        case .forecast:
            return "/data/2.5/forecast"
        case .weather:
            return "/data/2.5/weather"
        case .onecall:
            return "/data/2.5/onecall"
        }
    }
}

struct Request {
    let cityName: String?
    let lat: String?
    let lon: String?
    let requestType: RequestType
}

class NetworkManager {
    
    static let urlSession = URLSession(configuration: .default)
    
    private struct Components {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
    
        static let excludeItem = URLQueryItem(name: "exclude", value: "minutely")
        static let unitsItem = URLQueryItem(name: "units", value: "metric")
        static let languageItem = URLQueryItem(name: "lang", value: "ru")
        static let appiKeyItem = URLQueryItem(name: "appid", value: "3a7138e1e6cde45e6370f55d233c10ec")
    }
    
    static func getData(forRequest request: Request, completion: @escaping NetworkCompletionHandler) {
        guard let url = getURL(forRequest: request) else {
            print("ERROR")
            completion(nil, .wrongURL)
            return
        }
        urlSession.dataTask(with: url) { (data, _, error) in
            if error != nil {
                completion(nil, .noConnection)
                return
            }
            guard let data = data else {
                completion(nil, .noData)
                return
            }
            do {
                let json = try JSON(data: data)
                let cod = json["cod"].intValue
                if cod == 200 {
                    completion(data, nil)
                } else if cod == 404 {
                    completion(nil, .wrongName)
                    return
                } else {
                    completion(nil, .wrongURL)
                    return
                }
            } catch {
                completion(nil, .noData)
                return
            }
        }.resume()
    }
    
    static func getURL(forRequest request: Request) -> URL? {
        var components = URLComponents()
        components.scheme = Components.scheme
        components.host = Components.host
        components.path = request.requestType.path()
        
        var queryItems = [Components.unitsItem,
                          Components.languageItem,
                          Components.appiKeyItem]
        
        if request.requestType == .onecall {
            queryItems.append(Components.excludeItem)
        }
     
        if let name = request.cityName {
            queryItems.insert(URLQueryItem(name: "q", value: name), at: 0)
        } else if let lat = request.lat,
            let lon = request.lon {
            queryItems.insert(URLQueryItem(name: "lon", value: lon), at: 0)
            queryItems.insert(URLQueryItem(name: "lat", value: lat), at: 0)
        }
        components.queryItems = queryItems
        
        return components.url
    }
}
