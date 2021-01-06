//
//  DetailCurrentWeatherCollectionViewCell.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 19.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit

class DetailCurrentWeatherCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var temperatureLabel: UILabel!
    @IBOutlet weak private var cloudsLabel: UILabel!
    @IBOutlet weak private var windLabel: UILabel!
    @IBOutlet weak private var sunriseLabel: UILabel!
    @IBOutlet weak private var sunsetLabel: UILabel!
    
    var descrip: String? {
        didSet {
            descriptionLabel.text = descrip?.capitalizingFirstLetter()
        }
    }
    var temperature: Double? {
        didSet {
            guard let temperature = temperature else { return }
            temperatureLabel.text = "\(Int(round(temperature)))°"
            setBackground()
        }
    }
    var clouds: Double? {
        didSet {
            guard let clouds = clouds else { return }
            cloudsLabel.text = "\(Int(round(clouds))) %"
        }
    }
    var windInfo: Wind? {
        didSet {
            guard let windInfo = windInfo else { return }
            windLabel.text = windInfo.windDirection + " \(Int(round(windInfo.windSpeed))) м/с"
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
        
        self.layer.cornerRadius = Constants.CollectionViewCell.cornerRadius
        self.layer.cornerCurve = .continuous
        
        self.contentView.layer.cornerRadius = Constants.CollectionViewCell.cornerRadius
        self.contentView.layer.cornerCurve = .continuous
        
        addShadow()
    }
    
    func setBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.contentView.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.colors = getColors(for: temperature ?? 0)
        let gradientLayers = contentView.layer.sublayers?.compactMap { $0 as? CAGradientLayer }
        gradientLayers?.forEach { $0.removeFromSuperlayer() }
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

protocol DetailCurrentWeatherPresenterProtocol: class {
    init(view: DetailCurrentWeatherCollectionViewCell, weather: Weather)
    func setupUI()
}
