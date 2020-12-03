//
//  DateFormatter+Styles.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 01.12.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static func timeDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
    
    static func dateDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateStyle = .none
        dateFormatter.dateFormat = "dd/MM"
        return dateFormatter
    }
}
