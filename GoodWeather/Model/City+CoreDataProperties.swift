//
//  City+CoreDataProperties.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 03.12.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var lat: String?
    @NSManaged public var lon: String?
    @NSManaged public var name: String?
    @NSManaged public var timeZone: Int64
    @NSManaged public var currentWeather: Weather?
    @NSManaged public var dailyForecast: NSOrderedSet?
    @NSManaged public var hourlyForecast: NSOrderedSet?

}

// MARK: Generated accessors for dailyForecast
extension City {

    @objc(insertObject:inDailyForecastAtIndex:)
    @NSManaged public func insertIntoDailyForecast(_ value: Weather, at idx: Int)

    @objc(removeObjectFromDailyForecastAtIndex:)
    @NSManaged public func removeFromDailyForecast(at idx: Int)

    @objc(insertDailyForecast:atIndexes:)
    @NSManaged public func insertIntoDailyForecast(_ values: [Weather], at indexes: NSIndexSet)

    @objc(removeDailyForecastAtIndexes:)
    @NSManaged public func removeFromDailyForecast(at indexes: NSIndexSet)

    @objc(replaceObjectInDailyForecastAtIndex:withObject:)
    @NSManaged public func replaceDailyForecast(at idx: Int, with value: Weather)

    @objc(replaceDailyForecastAtIndexes:withDailyForecast:)
    @NSManaged public func replaceDailyForecast(at indexes: NSIndexSet, with values: [Weather])

    @objc(addDailyForecastObject:)
    @NSManaged public func addToDailyForecast(_ value: Weather)

    @objc(removeDailyForecastObject:)
    @NSManaged public func removeFromDailyForecast(_ value: Weather)

    @objc(addDailyForecast:)
    @NSManaged public func addToDailyForecast(_ values: NSOrderedSet)

    @objc(removeDailyForecast:)
    @NSManaged public func removeFromDailyForecast(_ values: NSOrderedSet)

}

// MARK: Generated accessors for hourlyForecast
extension City {

    @objc(insertObject:inHourlyForecastAtIndex:)
    @NSManaged public func insertIntoHourlyForecast(_ value: Weather, at idx: Int)

    @objc(removeObjectFromHourlyForecastAtIndex:)
    @NSManaged public func removeFromHourlyForecast(at idx: Int)

    @objc(insertHourlyForecast:atIndexes:)
    @NSManaged public func insertIntoHourlyForecast(_ values: [Weather], at indexes: NSIndexSet)

    @objc(removeHourlyForecastAtIndexes:)
    @NSManaged public func removeFromHourlyForecast(at indexes: NSIndexSet)

    @objc(replaceObjectInHourlyForecastAtIndex:withObject:)
    @NSManaged public func replaceHourlyForecast(at idx: Int, with value: Weather)

    @objc(replaceHourlyForecastAtIndexes:withHourlyForecast:)
    @NSManaged public func replaceHourlyForecast(at indexes: NSIndexSet, with values: [Weather])

    @objc(addHourlyForecastObject:)
    @NSManaged public func addToHourlyForecast(_ value: Weather)

    @objc(removeHourlyForecastObject:)
    @NSManaged public func removeFromHourlyForecast(_ value: Weather)

    @objc(addHourlyForecast:)
    @NSManaged public func addToHourlyForecast(_ values: NSOrderedSet)

    @objc(removeHourlyForecast:)
    @NSManaged public func removeFromHourlyForecast(_ values: NSOrderedSet)

}

extension City : Identifiable {

}
