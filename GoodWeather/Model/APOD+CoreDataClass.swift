//
//  APOD+CoreDataClass.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 13.09.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(APOD)
public class APOD: NSManagedObject {
    
    enum CodingKeys: String {
        case date
        case title
        case imageURL = "url"
        case explanation
    }
    
    func update(with json: JSON) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date = dateFormatter.date(from: json[CodingKeys.date.rawValue].stringValue)
        
        title = json[CodingKeys.title.rawValue].stringValue
        imageURL = json[CodingKeys.imageURL.rawValue].stringValue
        descriptionText = json[CodingKeys.explanation.rawValue].stringValue
       
    }
    
}
