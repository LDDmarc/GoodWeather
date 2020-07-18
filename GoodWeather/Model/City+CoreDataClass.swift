//
//  City+CoreDataClass.swift
//  WeatherForecast
//
//  Created by Дарья Леонова on 02.07.2020.
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
    }
    func update(with json: JSON) {
        lat = json[CodingKeys.coord.rawValue][CodingKeys.lat.rawValue].doubleValue
        lon = json[CodingKeys.coord.rawValue][CodingKeys.lon.rawValue].doubleValue
        name = json[CodingKeys.name.rawValue].stringValue
        timeZone = json[CodingKeys.timeZone.rawValue].int64Value
        currentWeather?.update(with: json)
    }
}
