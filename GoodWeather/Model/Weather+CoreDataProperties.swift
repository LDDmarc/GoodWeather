//
//  Weather+CoreDataProperties.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 19.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather")
    }

    @NSManaged public var clouds: Double
    @NSManaged public var date: Date?
    @NSManaged public var dateUTC: Int64
    @NSManaged public var descrip: String?
    @NSManaged public var feelsLike: Double
    @NSManaged public var hour: Int64
    @NSManaged public var humidity: Double
    @NSManaged public var icon: String?
    @NSManaged public var main: String?
    @NSManaged public var pressure: Double
    @NSManaged public var rain: Double
    @NSManaged public var snow: Double
    @NSManaged public var temperature: Double
    @NSManaged public var temperatureMax: Double
    @NSManaged public var temperatureMin: Double
    @NSManaged public var windDegree: Double
    @NSManaged public var winSpeed: Double
    @NSManaged public var windSpeed: Double
    @NSManaged public var city: City?
    @NSManaged public var cityForecast: City?

}
