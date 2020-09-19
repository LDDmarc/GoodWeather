//
//  APOD+CoreDataProperties.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 13.09.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//
//

import Foundation
import CoreData


extension APOD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<APOD> {
        return NSFetchRequest<APOD>(entityName: "APOD")
    }

    @NSManaged public var date: Date?
    @NSManaged public var imageURL: String?
    @NSManaged public var title: String?

}
