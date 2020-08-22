//
//  CityName+CoreDataProperties.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 22.08.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//
//

import Foundation
import CoreData


extension CityName {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityName> {
        return NSFetchRequest<CityName>(entityName: "CityName")
    }

    @NSManaged public var name: String?

}
