//
//  UICollectionViewCell+Colors.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 04.12.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation
import UIKit
import DynamicColor

extension UICollectionViewCell {
    
    func getColors(for temperature: Double) -> [CGColor] {
        (temperature < 0) ? [UIColor.darkBlue.cgColor,
                             UIColor.lightBlue.cgColor,
                             UIColor.lightPurple.cgColor] : [UIColor.lightOrange.cgColor,
                                                             UIColor.darkOrange.cgColor,
                                                             UIColor.darkViolet.cgColor]
    }
    
    func getColor(for temperature: Double) -> UIColor {
        
        let maxT = 40.0
        
        if temperature < 0 {
            var index: Int = Int(temperature + maxT)
            
            let gradient = DynamicGradient(colors: [UIColor.lightPurple,
                                                    UIColor.lightBlue,
                                                    UIColor.darkBlue])
            let rgbPalette = gradient.colorPalette(amount: UInt(maxT))
            if index < 0 { index = 0 }
            return rgbPalette[index]
        } else {
            var index: Int = Int(temperature)
            let gradient = DynamicGradient(colors: [UIColor.lightOrange,
                                                    UIColor.darkOrange,
                                                    UIColor.darkViolet])
            let rgbPalette = gradient.colorPalette(amount: UInt(maxT))
            if index >= Int(maxT) { index = Int(maxT - 1) }
            return rgbPalette[index]
        }
    }
}
