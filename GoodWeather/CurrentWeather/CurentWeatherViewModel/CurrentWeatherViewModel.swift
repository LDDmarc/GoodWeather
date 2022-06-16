//
//  CurrentWeatherViewModel.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 19.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation

class CurrentWeatherViewModel: CurrentWeatherViewModelProtocol {
    
    var city: City
    
    required init(city: City) {
        self.city = city
    }
    
    var cityName: String? {
        didSet {
            self.dataDidChange?(self)
        }
    }
    
    var iconName: String? {
        didSet {
            self.dataDidChange?(self)
        }
    }
    
    var temperature: Double? {
        didSet {
            self.dataDidChange?(self)
        }
    }
    
    func setViewModel() {
        cityName = city.name
        guard let weather = city.currentWeather else { return }
        iconName = weather.icon
        temperature = weather.temperature
    }
    
    var dataDidChange: ((CurrentWeatherViewModelProtocol) -> ())?
}
