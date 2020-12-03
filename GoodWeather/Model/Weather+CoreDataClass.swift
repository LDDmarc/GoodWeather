//
//  Weather+CoreDataClass.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 19.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON

struct Wind {
    var windSpeed: Double
    var windDirection: String
}

@objc(Weather)
public class Weather: NSManagedObject {
    
    enum CodingKeys: String {
        
        case weather
        case main
        case description
        case icon
        
        case sunrise
        case sunset
        
        case temperature = "temp"
        case feelsLike = "feels_like"
        case pressure
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
        
        case probabilityOfPrecipitation = "pop"
        
        case wind_speed
        case wind_degree = "wind_deg"
        case clouds
        
        case day
        case night
        
        case dateUTC = "dt"
    }
    
    func updateAsCurrentWeather(with json: JSON) {
        dateUTC = json[CodingKeys.dateUTC.rawValue].int64Value
        
        if let timeZone = city?.timeZone {
            date = Date(timeIntervalSince1970: TimeInterval(dateUTC + timeZone))
            sunrise = Date(timeIntervalSince1970: json[CodingKeys.sunrise.rawValue].doubleValue + Double(timeZone))
            sunset = Date(timeIntervalSince1970: json[CodingKeys.sunset.rawValue].doubleValue + Double(timeZone))
        }
        
        temperature = json[CodingKeys.temperature.rawValue].doubleValue
        feelsLike = json[CodingKeys.feelsLike.rawValue].doubleValue
        
        windSpeed = json[CodingKeys.wind_speed.rawValue].doubleValue
        windDegree = json[CodingKeys.wind_degree.rawValue].doubleValue
        windDirection = getWindDirection(by: windDegree)
        
        descrip = json[CodingKeys.weather.rawValue][0][CodingKeys.description.rawValue].stringValue
        icon = json[CodingKeys.weather.rawValue][0][CodingKeys.icon.rawValue].stringValue
        
        clouds = json[CodingKeys.clouds.rawValue].doubleValue
    }
    
    func updateAsDailyForecast(with json: JSON) {
        dateUTC = json[CodingKeys.dateUTC.rawValue].int64Value
        if let timeZone = cityDailyForecast?.timeZone {
            date = Date(timeIntervalSince1970: TimeInterval(dateUTC + timeZone))
        }
        dayTemperature = json[CodingKeys.temperature.rawValue][CodingKeys.day.rawValue].doubleValue
        nightTemperature = json[CodingKeys.temperature.rawValue][CodingKeys.night.rawValue].doubleValue
        
        probabilityOfPrecipitation = json[CodingKeys.probabilityOfPrecipitation.rawValue].doubleValue
        
        windSpeed = json[CodingKeys.wind_speed.rawValue].doubleValue
        windDegree = json[CodingKeys.wind_degree.rawValue].doubleValue
        windDirection = getWindDirection(by: windDegree)
        
        icon = json[CodingKeys.weather.rawValue][0][CodingKeys.icon.rawValue].stringValue
    }
    
    func updateAsHourlyForecast(with json: JSON) {
        
        dateUTC = json[CodingKeys.dateUTC.rawValue].int64Value
        if let timeZone = cityHourlyForecast?.timeZone {
            date = Date(timeIntervalSince1970: TimeInterval(dateUTC + timeZone))
        }
        temperature = json[CodingKeys.temperature.rawValue].doubleValue
       
        probabilityOfPrecipitation = json[CodingKeys.probabilityOfPrecipitation.rawValue].doubleValue
       
        icon = json[CodingKeys.weather.rawValue][0][CodingKeys.icon.rawValue].stringValue
        
    }

    private let twentyFourHoursInSeconds: Double = 86400
    
    private func getWindDirection(by windDegree: Double) -> String {
        switch windDegree {
        case 0...11.25:
            return "с"
        case 11.26...33.75:
            return "ссв"
        case 33.76...56.25:
            return "св"
        case 56.26...78.75:
            return "всв"
        case 78.76...101.25:
            return "в"
        case 101.26...123.75:
            return "вюв"
        case 123.76...146.25:
            return "юв"
        case 146.26...168.75:
            return "ююв"
        case 168.26...191.25:
            return "ю"
        case 191.26...213.75:
            return "ююз"
        case 213.76...236.25:
            return "юз"
        case 236.26...258.75:
            return "зюз"
        case 258.76...281.75:
            return "з"
        case 281.76...303.75:
            return "зсз"
        case 303.76...326.25:
            return "сз"
        case 326.25...348.75:
            return "ююз"
        case 348.76...360:
            return "с"
        default:
            return ""
        }
    }
}
