//
//  City+CoreDataClass.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 19.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(City)
public class City: NSManagedObject {
    
    enum CodingKeys: String {
        case coord
        case lat
        case lon
        case name
        case timeZone = "timezone"
        case timeZoneOffset = "timezone_offset"
        
        case current
        case hourly
        case daily
    }
   
    func update(with cityInfo: CityInfo) {
        name = cityInfo.name
        lat = cityInfo.coordinates.lat
        lon = cityInfo.coordinates.lon
    }
    
    func updateWeather(with json: JSON) {
        timeZone = json[CodingKeys.timeZoneOffset.rawValue].int64Value
        
        currentWeather?.updateAsCurrentWeather(with: json[CodingKeys.current.rawValue])
        
        let dailyJson = json[CodingKeys.daily.rawValue]
        if let dailyForecast = dailyForecast {
            for num in 0..<7 {
                if let dayWearher = dailyForecast[num] as? Weather {
                    dayWearher.updateAsDailyForecast(with: dailyJson[num])
                }
            }
        }
        
        let hourlyJson = json[CodingKeys.hourly.rawValue]
        if let hourlyForecast = hourlyForecast {
            for num in 0..<23 {
                if let hourWearher = hourlyForecast[num] as? Weather {
                    hourWearher.updateAsHourlyForecast(with: hourlyJson[num])
                }
            }
        }
        
    }
}
