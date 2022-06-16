//
//  DetailCurrentWeatherPresenter.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 20.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation

class DetailCurrentWeatherPresenter: DetailCurrentWeatherPresenterProtocol {
    
    let view: DetailCurrentWeatherCollectionViewCell
    let weather: Weather
    
    required init(view: DetailCurrentWeatherCollectionViewCell, weather: Weather) {
        self.view = view
        self.weather = weather
    }
    
    func setupUI() {
        view.descrip = weather.descrip
        view.temperature = weather.temperature
        view.clouds = weather.clouds
        if let windDirection = weather.windDirection {
            view.windInfo = Wind(windSpeed: weather.windSpeed, windDirection: windDirection)
        }
        view.sunriseTime = weather.sunrise
        view.sunsetTime = weather.sunset
    }
}