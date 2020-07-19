//
//  CurrentWeatherTableViewCell.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 19.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit

class CurrentWeatherTableViewCell: UITableViewCell {
    
    var viewModel: CurrentWeatherViewModelProtocol! {
        didSet {
            self.viewModel.dataDidChange = { [unowned self] viewModel in
                self.cityNameLabel.text = viewModel.cityName
                if let temperature = viewModel.temperature {
                    self.temperatureLabel.text = "\(temperature)"
                }
            }
        }
    }
    
    private let cityNameLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let iconImageView = UIImageView()
    
//    init(with viewModel: CurrentWeatherViewModelProtocol) {
//        self.viewModel = viewModel
//        super.init(style: .default, reuseIdentifier: "d")
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError()
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let views = [cityNameLabel, iconImageView, temperatureLabel]
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }
        
        cityNameLabel.font = UIFont.systemFont(ofSize: 17.0)
        cityNameLabel.textColor = .label
        cityNameLabel.textAlignment = .left
        
        temperatureLabel.font = UIFont.systemFont(ofSize: 32.0)
        temperatureLabel.textColor = .label
        temperatureLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            cityNameLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            cityNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.0),
            
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 50.0),
            iconImageView.heightAnchor.constraint(equalToConstant: 50.0),
            
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor),
            temperatureLabel.widthAnchor.constraint(equalToConstant: 75.0),
            
            cityNameLabel.trailingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor, constant: 16.0)
        ])
        temperatureLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
}
