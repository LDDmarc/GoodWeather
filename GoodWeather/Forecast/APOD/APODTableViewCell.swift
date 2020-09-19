//
//  APODTableViewCell.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 19.09.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit

class APODTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var apodImageView: UIImageView!
    @IBOutlet private weak var imageViewHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var descriptionLabelHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
