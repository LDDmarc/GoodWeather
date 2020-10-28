//
//  City+CoreDataProperties.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 28.10.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var id: Int64
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var name: String?
    @NSManaged public var timeZone: Int64
    @NSManaged public var currentWeather: Weather?
    @NSManaged public var dayAndNightWeather: NSOrderedSet?
    @NSManaged public var forecast: NSOrderedSet?
    @NSManaged public var hourly: NSOrderedSet?

}

// MARK: Generated accessors for dayAndNightWeather
extension City {

    @objc(insertObject:inDayAndNightWeatherAtIndex:)
    @NSManaged public func insertIntoDayAndNightWeather(_ value: DayAndNightWeather, at idx: Int)

    @objc(removeObjectFromDayAndNightWeatherAtIndex:)
    @NSManaged public func removeFromDayAndNightWeather(at idx: Int)

    @objc(insertDayAndNightWeather:atIndexes:)
    @NSManaged public func insertIntoDayAndNightWeather(_ values: [DayAndNightWeather], at indexes: NSIndexSet)

    @objc(removeDayAndNightWeatherAtIndexes:)
    @NSManaged public func removeFromDayAndNightWeather(at indexes: NSIndexSet)

    @objc(replaceObjectInDayAndNightWeatherAtIndex:withObject:)
    @NSManaged public func replaceDayAndNightWeather(at idx: Int, with value: DayAndNightWeather)

    @objc(replaceDayAndNightWeatherAtIndexes:withDayAndNightWeather:)
    @NSManaged public func replaceDayAndNightWeather(at indexes: NSIndexSet, with values: [DayAndNightWeather])

    @objc(addDayAndNightWeatherObject:)
    @NSManaged public func addToDayAndNightWeather(_ value: DayAndNightWeather)

    @objc(removeDayAndNightWeatherObject:)
    @NSManaged public func removeFromDayAndNightWeather(_ value: DayAndNightWeather)

    @objc(addDayAndNightWeather:)
    @NSManaged public func addToDayAndNightWeather(_ values: NSOrderedSet)

    @objc(removeDayAndNightWeather:)
    @NSManaged public func removeFromDayAndNightWeather(_ values: NSOrderedSet)

}

// MARK: Generated accessors for forecast
extension City {

    @objc(insertObject:inForecastAtIndex:)
    @NSManaged public func insertIntoForecast(_ value: Weather, at idx: Int)

    @objc(removeObjectFromForecastAtIndex:)
    @NSManaged public func removeFromForecast(at idx: Int)

    @objc(insertForecast:atIndexes:)
    @NSManaged public func insertIntoForecast(_ values: [Weather], at indexes: NSIndexSet)

    @objc(removeForecastAtIndexes:)
    @NSManaged public func removeFromForecast(at indexes: NSIndexSet)

    @objc(replaceObjectInForecastAtIndex:withObject:)
    @NSManaged public func replaceForecast(at idx: Int, with value: Weather)

    @objc(replaceForecastAtIndexes:withForecast:)
    @NSManaged public func replaceForecast(at indexes: NSIndexSet, with values: [Weather])

    @objc(addForecastObject:)
    @NSManaged public func addToForecast(_ value: Weather)

    @objc(removeForecastObject:)
    @NSManaged public func removeFromForecast(_ value: Weather)

    @objc(addForecast:)
    @NSManaged public func addToForecast(_ values: NSOrderedSet)

    @objc(removeForecast:)
    @NSManaged public func removeFromForecast(_ values: NSOrderedSet)

}

// MARK: Generated accessors for hourly
extension City {

    @objc(insertObject:inHourlyAtIndex:)
    @NSManaged public func insertIntoHourly(_ value: Weather, at idx: Int)

    @objc(removeObjectFromHourlyAtIndex:)
    @NSManaged public func removeFromHourly(at idx: Int)

    @objc(insertHourly:atIndexes:)
    @NSManaged public func insertIntoHourly(_ values: [Weather], at indexes: NSIndexSet)

    @objc(removeHourlyAtIndexes:)
    @NSManaged public func removeFromHourly(at indexes: NSIndexSet)

    @objc(replaceObjectInHourlyAtIndex:withObject:)
    @NSManaged public func replaceHourly(at idx: Int, with value: Weather)

    @objc(replaceHourlyAtIndexes:withHourly:)
    @NSManaged public func replaceHourly(at indexes: NSIndexSet, with values: [Weather])

    @objc(addHourlyObject:)
    @NSManaged public func addToHourly(_ value: Weather)

    @objc(removeHourlyObject:)
    @NSManaged public func removeFromHourly(_ value: Weather)

    @objc(addHourly:)
    @NSManaged public func addToHourly(_ values: NSOrderedSet)

    @objc(removeHourly:)
    @NSManaged public func removeFromHourly(_ values: NSOrderedSet)

}

extension City : Identifiable {

}
