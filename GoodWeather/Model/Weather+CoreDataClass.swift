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
        case sys
        
        case sunrise
        case sunset
    
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
    
    func updateOneCall(with json: JSON) {
        
    }
    
    func updateForecast(with json: JSON) {
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
        windDirection = getWindDirection(by: windDegree)
        
        rain = json[CodingKeys.rain.rawValue]["1h"].doubleValue
        snow = json[CodingKeys.snow.rawValue]["1h"].doubleValue
        
        clouds = json[CodingKeys.clouds.rawValue][CodingKeys.all.rawValue].doubleValue
        
        dateUTC = json[CodingKeys.dateUTC.rawValue].int64Value
        
        if let timeZone = cityForecast?.timeZone {
            date = Date(timeIntervalSince1970: TimeInterval(dateUTC + timeZone))
            if let date = date {
                var calendar = Calendar.current
                calendar.timeZone = TimeZone(secondsFromGMT: 0)!
                hour = Int64(calendar.component(.hour, from: date))
                if hour == 12 || hour == 13 || hour == 14 {
                    if let index = getIndex(forWeatherWith: date),
                        index >= 0 {
                        (self.cityForecast?.dayAndNightWeather?.object(at: index) as? DayAndNightWeather)?.dayWeather = self
                    }
                }
                if hour == 0 || hour == 1 || hour == 2 {
                    if let index = getIndex(forWeatherWith: date),
                        index >= 0 {
                        (self.cityForecast?.dayAndNightWeather?.object(at: index) as? DayAndNightWeather)?.nightWeather = self
                    }
                }
            }
        }
        
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
        windDirection = getWindDirection(by: windDegree)
        
        rain = json[CodingKeys.rain.rawValue]["1h"].doubleValue
        snow = json[CodingKeys.snow.rawValue]["1h"].doubleValue
        
        clouds = json[CodingKeys.clouds.rawValue][CodingKeys.all.rawValue].doubleValue
        
        dateUTC = json[CodingKeys.dateUTC.rawValue].int64Value
        
        if let timeZone = city?.timeZone {
            date = Date(timeIntervalSince1970: TimeInterval(dateUTC + timeZone))
            sunrise = Date(timeIntervalSince1970: json[CodingKeys.sys.rawValue][CodingKeys.sunrise.rawValue].doubleValue + Double(timeZone))
            sunset = Date(timeIntervalSince1970: json[CodingKeys.sys.rawValue][CodingKeys.sunset.rawValue].doubleValue + Double(timeZone))
        }
        
        if let timeZone = cityHourly?.timeZone {
            date = Date(timeIntervalSince1970: TimeInterval(dateUTC + timeZone))
            if let date = date {
                var calendar = Calendar.current
                calendar.timeZone = TimeZone(secondsFromGMT: 0)!
                hour = Int64(calendar.component(.hour, from: date))
            }
            guard let mutableHourlyWeatherSet = cityHourly?.hourly?.mutableCopy() as? NSMutableOrderedSet else { return }
            mutableHourlyWeatherSet.add(self)
            cityHourly?.hourly = mutableHourlyWeatherSet.copy() as? NSOrderedSet
        }
       
        if let timeZone = cityForecast?.timeZone { // just for forecast
            date = Date(timeIntervalSince1970: TimeInterval(dateUTC + timeZone))
            if let date = date {
                var calendar = Calendar.current
                calendar.timeZone = TimeZone(secondsFromGMT: 0)!
                hour = Int64(calendar.component(.hour, from: date))
                if hour == 12 || hour == 13 || hour == 14 {
                    if let index = getIndex(forWeatherWith: date),
                        index >= 0 {
                        (self.cityForecast?.dayAndNightWeather?.object(at: index) as? DayAndNightWeather)?.dayWeather = self
                    }
                }
                if hour == 0 || hour == 1 || hour == 2 {
                    if let index = getIndex(forWeatherWith: date),
                        index >= 0 {
                        (self.cityForecast?.dayAndNightWeather?.object(at: index) as? DayAndNightWeather)?.nightWeather = self
                    }
                }
            }
        }
        
    }
    
    private func getIndex(forWeatherWith date: Date) -> Int? {
        if let city = cityForecast,
            let currentWeatherDate = city.currentWeather?.date {
            let dateDifference = date.timeIntervalSince(currentWeatherDate)
            var index: Int
            switch dateDifference {
            case 0...twentyFourHoursInSeconds - 1:
                index = 0
            case twentyFourHoursInSeconds...2 * twentyFourHoursInSeconds - 1:
                index = 1
            case 2 * twentyFourHoursInSeconds...3 * twentyFourHoursInSeconds - 1:
                index = 2
            case 3 * twentyFourHoursInSeconds...4 * twentyFourHoursInSeconds - 1:
                index = 3
            case 4 * twentyFourHoursInSeconds...5 * twentyFourHoursInSeconds - 1:
                index = 4
            case 5 * twentyFourHoursInSeconds...6 * twentyFourHoursInSeconds - 1:
                index = 5
            default:
                index = -2
            }
            return index
        }
        return nil
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
