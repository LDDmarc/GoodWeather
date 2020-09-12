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
        
        var firstColor: UIColor
        var secondColor: UIColor
        var index: Int
        
        switch temperature {
        case -40..<(-20):
            index = Int((temperature + 40)/4)
            firstColor = UIColor(hexString: "#5A94FE")
            secondColor = UIColor(hexString: "#C6AFFF")
        case -20..<0:
            index = Int((temperature + 20)/4)
            firstColor = UIColor(hexString: "#386DFD")
            secondColor = UIColor(hexString: "#84C8FE")
        case 0..<20:
            index = Int((temperature)/4)
            firstColor = UIColor(hexString: "#05A82A")
            secondColor = UIColor(hexString: "#93C603")
        case 20..<40:
            index = Int((temperature - 20)/4)
            firstColor = UIColor(hexString: "#EA4245")
            secondColor = UIColor(hexString: "#FBB05F")
        default:
            index = Int(round(temperature/8))
            firstColor = UIColor(hexString: "#386DFD")
            secondColor = UIColor(hexString: "#84C8FE")
        }
       
        let gradient = DynamicGradient(colors: [firstColor, secondColor])
        let rgbPalette = gradient.colorPalette(amount: 8)
        
        
        return rgbPalette[index]
    }
}
