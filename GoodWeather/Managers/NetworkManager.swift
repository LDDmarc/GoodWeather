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

class NetworkManager {
    
    static let urlSession = URLSession(configuration: .default)
    
    private struct Components {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5/onecall"
    
        static let excludeItem = URLQueryItem(name: "exclude", value: "minutely,alerts")
        static let unitsItem = URLQueryItem(name: "units", value: "metric")
        static let languageItem = URLQueryItem(name: "lang", value: "ru")
        static let appiKeyItem = URLQueryItem(name: "appid", value: "3a7138e1e6cde45e6370f55d233c10ec")
    }
    
    static func getData(forCityWith coordinates: Coordinates, completion: @escaping NetworkCompletionHandler) {
        guard let url = getURL(forCityWith: coordinates) else {
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
            completion(data, nil)
        }.resume()
    }
    
    static func getURL(forCityWith coordinates: Coordinates) -> URL? {
        var components = URLComponents()
        components.scheme = Components.scheme
        components.host = Components.host
        components.path = Components.path
        
        var queryItems = [Components.unitsItem,
                          Components.languageItem,
                          Components.appiKeyItem,
                          Components.excludeItem]
        
        queryItems.insert(URLQueryItem(name: "lon", value: coordinates.lon), at: 0)
        queryItems.insert(URLQueryItem(name: "lat", value: coordinates.lat), at: 0)
        
        components.queryItems = queryItems
    
        return components.url
    }
}
