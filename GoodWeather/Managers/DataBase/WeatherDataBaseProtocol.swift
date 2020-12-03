//
//  WeatherDataBaseProtocol.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 18.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CityInfo {
    var name: String
    var coordinates: Coordinates
}

struct Coordinates {
    var lat: String
    var lon: String
}

typealias WeatherDataBaseCompletionHandler = (Bool) -> Void

protocol WeatherDataBaseProtocol {
    func getCurrentCities() -> [City]
    func createNewCity(by info: CityInfo, completion: @escaping WeatherDataBaseCompletionHandler)
    func updateWeatherForCityWith(cordinates: Coordinates, with json: JSON) -> Bool
}
