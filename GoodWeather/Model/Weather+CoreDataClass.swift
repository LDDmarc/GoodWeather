//
//  Weather+CoreDataClass.swift
//  WeatherForecast
//
//  Created by Дарья Леонова on 02.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//
//
// swiftlint:disable trailing_whitespace
import Foundation
import CoreData
import SwiftyJSON

@objc(Weather)
public class Weather: NSManagedObject {
    
    enum CodingKeys: String {
        case weather
        case main
        case description
        case icon
    
        case temperature = "temp"
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
        
        case wind
        case speed
        case degree
        
        case rain
        case snow
        
        case clouds
        case all
        
        case dateUTC = "dt"
    }

    func update(with json: JSON) {
        main = json[CodingKeys.weather.rawValue][0][CodingKeys.main.rawValue].stringValue
        descrip = json[CodingKeys.weather.rawValue][0][CodingKeys.description.rawValue].stringValue
        icon = json[CodingKeys.weather.rawValue][0][CodingKeys.icon.rawValue].stringValue
        
        temperature = json[CodingKeys.main.rawValue][CodingKeys.temperature.rawValue].doubleValue
        temperatureMin = json[CodingKeys.main.rawValue][CodingKeys.temperatureMin.rawValue].doubleValue
        temperatureMax = json[CodingKeys.main.rawValue][CodingKeys.temperatureMax.rawValue].doubleValue
        feelsLike = json[CodingKeys.main.rawValue][CodingKeys.feelsLike.rawValue].doubleValue
        pressure = json[CodingKeys.main.rawValue][CodingKeys.pressure.rawValue].doubleValue
        humidity = json[CodingKeys.main.rawValue][CodingKeys.humidity.rawValue].doubleValue
        
        windSpeed = json[CodingKeys.wind.rawValue][CodingKeys.speed.rawValue].doubleValue
        windDegree = json[CodingKeys.wind.rawValue][CodingKeys.degree.rawValue].doubleValue
        
        rain = json[CodingKeys.rain.rawValue]["1h"].doubleValue
        snow = json[CodingKeys.snow.rawValue]["1h"].doubleValue
        
        clouds = json[CodingKeys.clouds.rawValue][CodingKeys.all.rawValue].doubleValue
        
        dateUTC = json[CodingKeys.dateUTC.rawValue].int64Value
        
        if let timeZone = city?.timeZone {
            date = Date(timeIntervalSince1970: TimeInterval(dateUTC + timeZone))
        }
        if let timeZone = cityForecast?.timeZone {
            date = Date(timeIntervalSince1970: TimeInterval(dateUTC + timeZone))
        }
        
        if let date = date {
            let calendar = Calendar.current
            hour = Int64(calendar.component(.hour, from: date))
        }
    }
}
