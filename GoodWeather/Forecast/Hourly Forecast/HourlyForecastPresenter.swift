//
//  HourlyForecastPresenter.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 04.12.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation

class HourlyForecastPresenter: HourlyForecastPresenterProtocol {
    
    let view: HourlyForecastCollectionViewCell
    let weather: Weather
    
    required init(view: HourlyForecastCollectionViewCell, weather: Weather) {
        self.view = view
        self.weather = weather
    }
    
    func setupUI() {
        view.date = weather.date
        view.iconName = weather.icon
        view.precipitation = weather.probabilityOfPrecipitation
        view.temperature = weather.temperature
    }
    
    
}
