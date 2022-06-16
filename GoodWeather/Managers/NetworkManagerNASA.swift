//
//  NetworkManagerNASA.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 13.09.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation
import SwiftyJSON

class NetworkManagerNASA {
    
    static let urlSession = URLSession(configuration: .default)
    
    private struct Components {
        static let scheme = "https"
        static let host = "api.nasa.gov"
        static let path = "/planetary/apod"
        static let appiKeyItem = URLQueryItem(name: "api_key", value: "QQsVoxdGKh2cZFPlcrrWqZW5RTa6maSmSMYaJIJ7")
    }
    
    static func getURL() -> URL? {
        var components = URLComponents()
        components.scheme = Components.scheme
        components.host = Components.host
        components.path = Components.path
        components.queryItems = [Components.appiKeyItem]
        
        return components.url
    }
    
    static func getData(completion: @escaping NetworkCompletionHandler) {
        guard let url = getURL() else {
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
}
