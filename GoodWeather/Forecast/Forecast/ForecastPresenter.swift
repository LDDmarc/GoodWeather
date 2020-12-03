//
//  ForecastPresenter.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 20.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation

class ForecastPresenter: ForecastPresenterProtocol {
 
    let view: ForecastCollectionViewCell
    let weather: Weather
    
    required init(view: ForecastCollectionViewCell, weather: Weather) {
        self.view = view
        self.weather = weather
    }
    
    func setupUI(forDay: Bool) {
        view.date = weather.date
        view.iconName = forDay ? weather.dayIcon : weather.nightIcon
        view.precipitation = weather.probabilityOfPrecipitation
        view.temperature = forDay ? weather.dayTemperature : weather.nightTemperature
        if let windDirection = weather.windDirection {
            view.windInfo = Wind(windSpeed: weather.windSpeed, windDirection: windDirection)
        }
    }
}
