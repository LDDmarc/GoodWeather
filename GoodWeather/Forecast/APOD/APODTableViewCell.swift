//
//  APODTableViewCell.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 19.09.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit
import SDWebImage

class APODTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var apodImageView: UIImageView!
    @IBOutlet private weak var imageViewHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var descriptionLabelHeight: NSLayoutConstraint!
    
    @IBOutlet private var horizontalOffSetConstraints: [NSLayoutConstraint]?
    
    private var apod: APOD? {
        didSet {
            titleLabel.text = apod?.title
            descriptionLabel.text = apod?.descriptionText
            setDescriotionLabelSize(with: apod?.descriptionText)
            if let stringURL = apod?.imageURL,
                let imageURL = URL(string: stringURL) {
                apodImageView.sd_setImage(with: imageURL) { [weak self] (image, error, _, _) in
                    guard error == nil,
                        let image = image else { return }
                    self?.setImageViewSize(with: image)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        apodImageView.layer.cornerRadius = 20.0
        apodImageView.layer.cornerCurve = .continuous
        
        horizontalOffSetConstraints?.forEach { $0.constant = Constants.CollectionViewLayout.horizontalOffSet }
        layoutIfNeeded()
    }
    
    func configure(with apod: APOD) {
        self.apod = apod
    }
    
}

private extension APODTableViewCell {
    
    func setImageViewSize(with image: UIImage) {
        let imageHeight = image.size.height
        let imageWidth = image.size.width
        let newImageWidth = contentView.bounds.width - 2 * Constants.CollectionViewLayout.horizontalOffSet
        let coeff = imageWidth / newImageWidth
        let newImageHeight = imageHeight / coeff
        imageViewHeight.constant = newImageHeight
    }
    
    func setDescriotionLabelSize(with text: String?) {
        guard let height = text?.height(withConstrainedWidth: contentView.bounds.width - contentView.layoutMargins.left - contentView.layoutMargins.right,
                                        font: UIFont.systemFont(ofSize: 17.0)) else { return }
        
        descriptionLabelHeight.constant = height
    }
    
}
