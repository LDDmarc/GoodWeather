//
//  DetaiCurrentWeatherCollectionViewCell.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 19.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit

class DetaiCurrentWeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var temperatureLabel: UILabel!
    @IBOutlet weak private var precipitationLabel: UILabel!
    @IBOutlet weak private var windLabel: UILabel!
    @IBOutlet weak private var sunriseLabel: UILabel!
    @IBOutlet weak private var sunsetLabel: UILabel!
    
    var descrip: String? {
        didSet {
            descriptionLabel.text = descrip
        }
    }
    var temperature: Double? {
        didSet {
            guard let temperature = temperature else { return }
            temperatureLabel.text = "\(Int(round(temperature)))°"
            //TODO: bckgroundcolor
        }
    }
    var precipitation: Double? {
        didSet {
            guard let precipitation = precipitation else { return }
            precipitationLabel.text = "\(Int(round(precipitation)))%"
        }
    }
    var windInfo: String? {
        didSet {
            windLabel.text = windInfo
        }
    }
    var sunriseTime: Date? {
        didSet {
            guard let time = sunriseTime else { return }
            sunriseLabel.text = "\(DateFormatter.timeDateFormatter().string(from: time))"
        }
    }
    var sunsetTime: Date? {
        didSet {
            guard let time = sunsetTime else { return }
            sunsetLabel.text = "\(DateFormatter.timeDateFormatter().string(from: time))"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 20.0
        self.layer.cornerCurve = .continuous
        self.backgroundColor = .blue
    }
}
