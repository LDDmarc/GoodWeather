//
//  HourlyForecastCollectionViewCell.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 04.12.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit

class HourlyForecastCollectionViewCell: UICollectionViewCell {
    
    static let cellSize = CGSize(width: 56.0, height: 93.0)
    
    @IBOutlet private weak var hourLabel: UILabel!
    
    @IBOutlet private weak var precipitationView: UIView!
    @IBOutlet private weak var precipitationLabel: UILabel!
    @IBOutlet private weak var precipitationIconImageView: UIImageView!
    
    @IBOutlet private weak var weatherIconImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    
    var temperature: Double? {
        didSet {
            guard let temperature = temperature else { return }
            temperatureLabel.text = "\(Int(round(temperature)))°"
            backgroundColor = getColor(for: temperature)
        }
    }
    
    var precipitation: Double? {
        didSet {
            guard let precipitation = precipitation else { return }
            if precipitation >= 0.1 {
                precipitationView.isHidden = false
                weatherIconImageView.isHidden = true
                precipitationLabel.text = "\(Int(round(precipitation * 100)))%"
            } else {
                precipitationView.isHidden = true
                weatherIconImageView.isHidden = false
            }
        }
    }
    
    var iconName: String? {
        didSet {
            guard let iconName = iconName,
                let image = UIImage(named: iconName) else {
                    return
            }
            weatherIconImageView.image = image
            precipitationIconImageView.image = image
        }
    }
    var date: Date? {
        didSet {
            guard let date = date else { return }
            hourLabel.text = "\(DateFormatter.hourDateFormatter().string(from: date))"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 13.0
        self.layer.cornerCurve = .continuous
    }

}

protocol HourlyForecastPresenterProtocol: class {
    init(view: HourlyForecastCollectionViewCell, weather: Weather)
    func setupUI()
}
