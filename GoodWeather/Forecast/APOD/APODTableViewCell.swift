//
//  APODTableViewCell.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 19.09.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit
import SDWebImage

protocol APODTableViewCellDelegate: class {
    func apodTableViewCell(updateHeight apodTableViewCell: APODTableViewCell)
}

class APODTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var apodTittleLabel: UILabel!
    
    
    @IBOutlet private weak var apodImageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private var horizontalOffSetConstraints: [NSLayoutConstraint]?
    
    weak var delegate: APODTableViewCellDelegate?
    
    private var isFirstImageLoading: Bool = true
    
    private var apod: APOD? {
        didSet {
            titleLabel.text = apod?.title
            descriptionLabel.text = apod?.descriptionText
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
        
        apodTittleLabel.text = NSLocalizedString("apod_title", comment: "")
        
        horizontalOffSetConstraints?.forEach { $0.constant = Constants.CollectionViewLayout.horizontalOffSet }
        layoutIfNeeded()
    }
    
    func configure(with apod: APOD) {
        self.apod = apod
    }
    
}

private extension APODTableViewCell {
    
    func setImageViewSize(with image: UIImage) {
        guard isFirstImageLoading else {
            return
        }
        let aspectRatio =  image.size.height / image.size.width
        apodImageView.heightAnchor.constraint(equalTo: apodImageView.widthAnchor, multiplier: aspectRatio).isActive = true
        layoutIfNeeded()
        isFirstImageLoading = false 
        delegate?.apodTableViewCell(updateHeight: self)
    }
    
}
