//
//  CurrentWeatherTableViewController+Location.swift
//  GoodWeather
//
//  Created by d.leonova on 16.01.2021.
//  Copyright © 2021 Дарья Леонова. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

//MARK: - CLLocationManagerDelegate -
extension CurrentWeatherTableViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentCoordinates = locValue
    }
}

extension CurrentWeatherTableViewController {
    
    func accessPermissionForGettingLocation() {
    
        let ac = UIAlertController(title: NSLocalizedString("access_location_denied", comment: ""),
                                   message: NSLocalizedString("get_access_location", comment: ""),
                                   preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: NSLocalizedString("go_to_settings", comment: ""),
                                   style: .default) { (_) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        
        ac.addAction(UIAlertAction(title: NSLocalizedString("cancel_title", comment: ""),
                                   style: .cancel))
        present(ac, animated: true)
    }
}
