//
//  ForecastCollectionViewCell.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 20.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit
import DynamicColor

class ForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var temperatureLabel: UILabel!
    @IBOutlet weak private var precipitationLabel: UILabel!
    @IBOutlet weak private var windLabel: UILabel!
    @IBOutlet weak private var iconImageView: UIImageView!
    
    var temperature: Double? {
        didSet {
            guard let temperature = temperature else { return }
            temperatureLabel.text = "\(Int(round(temperature)))°"
            self.backgroundColor = getColor(for: temperature)
        }
    }
    var precipitation: Double? {
        didSet {
            guard let precipitation = precipitation else { return }
            precipitationLabel.text = "\(Int(round(precipitation)))%"
        }
    }
    var windInfo: Wind? {
        didSet {
            guard let windInfo = windInfo else { return }
            windLabel.text = windInfo.windDirection + " \(Int(round(windInfo.windSpeed))) м/с"
        }
    }
    var iconName: String? {
        didSet {
            guard let iconName = iconName,
                let image = UIImage(named: iconName) else {
                    return
            }
            iconImageView.image = image
        }
    }
    var date: Date? {
        didSet {
            guard let date = date else { return }
            dateLabel.text = "\(DateFormatter.dateDateFormatter().string(from: date))"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 13.0
        self.layer.cornerCurve = .continuous
        self.backgroundColor = .systemGray4
    }

}

protocol ForecastPresenterProtocol: class {
    init(view: ForecastCollectionViewCell, weather: Weather)
    func setUI()
}

extension ForecastCollectionViewCell {
    func getColor(for temperature: Double) -> UIColor {
        
        let blue   = UIColor(hexString: "#3498db")
        let red    = UIColor(hexString: "#e74c3c")
        let yellow = UIColor(hexString: "#f1c40f")

        let gradient = DynamicGradient(colors: [blue, red, yellow])
        let rgbPalette = gradient.colorPalette(amount: 8)
        
        
        return rgbPalette[3]
    }
}
