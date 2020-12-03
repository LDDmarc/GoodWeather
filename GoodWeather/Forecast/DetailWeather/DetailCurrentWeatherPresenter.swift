//
//  DetailCurrentWeatherPresenter.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 20.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation

class DetailCurrentWeatherPresenter: DetailCurrentWeatherPresenterProtocol {
    
    let view: DetaiCurrentWeatherCollectionViewCell
    let weather: Weather
    
    required init(view: DetaiCurrentWeatherCollectionViewCell, weather: Weather) {
        self.view = view
        self.weather = weather
    }
    
    func setUI() {
        view.descrip = weather.descrip
        view.temperature = weather.temperature
//        view.precipitation = weather.humidity
        if let windDirection = weather.windDirection {
            view.windInfo = Wind(windSpeed: weather.windSpeed, windDirection: windDirection)
        }
        view.sunriseTime = weather.sunrise
        view.sunsetTime = weather.sunset
    }
}
