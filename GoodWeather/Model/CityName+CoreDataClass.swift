//
//  CityName+CoreDataClass.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 22.08.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(CityName)
public class CityName: NSManagedObject {
    enum CodingKeys: String {
        case name
    }
    
    func update(with json: JSON) {
        name = json[CodingKeys.name.rawValue].stringValue
    }
}
