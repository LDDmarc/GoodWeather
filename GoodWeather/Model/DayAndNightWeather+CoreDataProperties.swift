//
//  DayAndNightWeather+CoreDataProperties.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 30.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//
//

import Foundation
import CoreData


extension DayAndNightWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayAndNightWeather> {
        return NSFetchRequest<DayAndNightWeather>(entityName: "DayAndNightWeather")
    }

    @NSManaged public var date: Date?
    @NSManaged public var city: City?
    @NSManaged public var dayWeather: Weather?
    @NSManaged public var nightWeather: Weather?

}
