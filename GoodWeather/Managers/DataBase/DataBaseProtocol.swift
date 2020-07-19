//
//  DataBaseProtocol.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 18.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol DataBaseProtocol {
    func updateWeatherFor(cityName: String?, with json: JSON) -> Bool
    func updateForecastFor(cityName: String?, with json: JSON) -> Bool
    func createNewCity(with json: JSON) -> Bool
}
