//
//  APODDataBaseProtocol.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 13.09.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

protocol APODDataBaseProtocol {
    func updateAPOD(with json: JSON) -> Bool
}

protocol DataBaseProtocol: APODDataBaseProtocol, WeatherDataBaseProtocol {
    var context: NSManagedObjectContext { get }
}
