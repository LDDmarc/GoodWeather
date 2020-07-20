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
    var precipitation: Double? {
        didSet {
            guard let precipitation = precipitation else { return }
            precipitationLabel.text = "\(Int(round(precipitation))) %"
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
        
        self.layer.cornerRadius = 20.0
        self.layer.cornerCurve = .continuous
        self.backgroundColor = .blue
    }
    
    private func setBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.contentView.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.colors = getColors()
        self.contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func getColors() -> [CGColor] {
        guard let temperature = temperature else {
            return [UIColor.systemFill.cgColor, UIColor.systemFill.cgColor]
        }
        switch temperature {
        case (-80)...(-20):
            return [WeatherColor.iceLight.cgColor, WeatherColor.iceDark.cgColor]
        case (-20)...0:
            return [WeatherColor.coldLight.cgColor, WeatherColor.coldDark.cgColor]
        case 0...20:
            return [WeatherColor.warmLight.cgColor, WeatherColor.warmDark.cgColor]
        case 20...80:
            return [WeatherColor.hotLight.cgColor, WeatherColor.hotDark.cgColor]
        default:
            return [UIColor.systemFill.cgColor, UIColor.systemFill.cgColor]
        }
    }
}

protocol DetailCurrentWeatherPresenterProtocol: class {
    init(view: DetaiCurrentWeatherCollectionViewCell, weather: Weather)
    func setUI()
}
