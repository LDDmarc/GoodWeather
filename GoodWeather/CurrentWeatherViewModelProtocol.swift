//
//  CurrentWeatherViewModelProtocol.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 19.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation
protocol CurrentWeatherViewModelProtocol: class {
    init(city: City)
    var cityName: String? { get }
    var cityTime: Date? { get }
    var temperature: Double? { get }
    func setViewModel()
    var dataDidChange: ((CurrentWeatherViewModelProtocol) -> ())? { get set }
}
