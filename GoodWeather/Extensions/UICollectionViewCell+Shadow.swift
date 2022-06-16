//
//  UICollectionViewCell+Shadow.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 05.12.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
    func addShadow() {
        contentView.layer.masksToBounds = true
//        layer.shadowColor = Constants.CollectionViewCell.shadowColor
//        layer.shadowOpacity = Constants.CollectionViewCell.shadowOpacity
//        layer.shadowOffset = Constants.CollectionViewCell.shadowOffSet
//        layer.shadowRadius = Constants.CollectionViewCell.shadowRadius
//        layer.masksToBounds = false
    }
}
