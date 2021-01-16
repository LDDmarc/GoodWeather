//
//  Constants.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 06.12.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    
    struct CollectionViewCell {
        static let cornerRadius: CGFloat = 20.0
        
        static let shadowOffSet = CGSize(width: 0, height: 0)
        static let shadowRadius: CGFloat = 6.0
        static let shadowOpacity: Float = 0.25
        static let shadowColor: CGColor = UIColor.black.cgColor
    }
    
    struct CollectionViewLayout {
        static let minimumLineSpacing: CGFloat = 16.0
        static let verticalOffSet: CGFloat = UIScreen.main.bounds.width < 350.0 ? 10.0 : 16.0
        static let horizontalOffSet: CGFloat = UIScreen.main.bounds.width < 350.0 ? 10.0 : 20.0
    }
    
    
}
