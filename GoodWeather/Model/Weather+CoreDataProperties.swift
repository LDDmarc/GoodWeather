//
//  Weather+CoreDataProperties.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 03.12.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather")
    }

    @NSManaged public var date: Date?
    @NSManaged public var dateUTC: Int64
    @NSManaged public var descrip: String?
    @NSManaged public var feelsLike: Double
    @NSManaged public var hour: Int64
    @NSManaged public var icon: String?
    @NSManaged public var probabilityOfPrecipitation: Double
    @NSManaged public var sunrise: Date?
    @NSManaged public var sunset: Date?
    @NSManaged public var temperature: Double
    @NSManaged public var temperatureMax: Double
    @NSManaged public var temperatureMin: Double
    @NSManaged public var windDegree: Double
    @NSManaged public var windDirection: String?
    @NSManaged public var windSpeed: Double
    @NSManaged public var dayTemperature: Double
    @NSManaged public var nightTemperature: Double
    @NSManaged public var clouds: Double
    @NSManaged public var dayIcon: String?
    @NSManaged public var nightIcon: String?
    @NSManaged public var city: City?
    @NSManaged public var cityDailyForecast: City?
    @NSManaged public var cityHourlyForecast: City?

}

extension Weather : Identifiable {

}
