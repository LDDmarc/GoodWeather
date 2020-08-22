//
//  SearchItem.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 22.08.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation

class SearchItem {
    
    var allAttributedName : NSMutableAttributedString?
    var attributedName: NSMutableAttributedString?
    var name: String
    
    public init(name: String) {
        self.name = name
    }
    
    public func getFormatedText() -> NSMutableAttributedString{
        allAttributedName = NSMutableAttributedString()
        allAttributedName!.append(attributedName!)

        return allAttributedName!
    }
}

