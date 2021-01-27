//
//  CurrentWeatherTableViewController+GooglePlaces.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 10.10.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation
import GooglePlaces
import MapKit

extension CurrentWeatherTableViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let placeCoordinates = place.coordinate
        let placeLat = "\(placeCoordinates.latitude)"
        let placeLon = "\(placeCoordinates.longitude)"
        let coordinates = Coordinates(lat: placeLat, lon: placeLon)
        
        dataManager.addNewCity(with: coordinates) { (error) in
            if error == nil {
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                    self?.showInfoAlert(title: NSLocalizedString("unknown_place_title", comment: ""),
                                        message: NSLocalizedString("unknown_place_message", comment: ""))
                }
            }
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        dismiss(animated: true, completion: nil)
        showInfoAlert(title: NSLocalizedString("common_error_title", comment: ""),
                      message: error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension CurrentWeatherTableViewController: SearchPlaceViewControllerAutocompleteDelegate {
    
    func viewController(_ viewController: SearchPlaceViewController, didAutocompleteWith place: MKLocalSearch.Response?) {
        guard let place = place,
              let placeCoordinates = place.mapItems.first?.placemark.coordinate
        else { return }
        let placeLat = "\(placeCoordinates.latitude)"
        let placeLon = "\(placeCoordinates.longitude)"
        
        let coordinates = Coordinates(lat: placeLat, lon: placeLon)
        addNewCity(with: coordinates)
    }
    
    func getCurrentLocation(_ viewController: SearchPlaceViewController) {
        dismiss(animated: true)
        
        guard CLLocationManager.locationServicesEnabled() else {
            showInfoAlert(title: NSLocalizedString("location_serivicies_not_enabled", comment: ""), message: "")
            return
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
            accessPermissionForGettingLocation()
        default:
            break
        }
        
        guard let placeCoordinates = currentCoordinates else { return }
        let placeLat = "\(placeCoordinates.latitude)"
        let placeLon = "\(placeCoordinates.longitude)"
        
        let coordinates = Coordinates(lat: placeLat, lon: placeLon)
        addNewCity(with: coordinates)
    }
    
    func addNewCity(with coordinates: Coordinates) {
        dataManager.addNewCity(with: coordinates) { (error) in
            if error == nil {
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                    self?.showInfoAlert(title: NSLocalizedString("unknown_place_title", comment: ""),
                                        message: NSLocalizedString("unknown_place_message", comment: ""))
                }
            }
        }
    }
    
    func viewController(_ viewController: SearchPlaceViewController, didFailAutocompleteWithError error: Error) {
        dismiss(animated: true, completion: nil)
        showInfoAlert(title: NSLocalizedString("common_error_title", comment: ""),
                      message: error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: SearchPlaceViewController) {
        dismiss(animated: true, completion: nil)
    }
}


extension UIViewController {
    
    func showInfoAlert(title: String?, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: NSLocalizedString("ok_message", comment: ""), style: .cancel))
        present(ac, animated: true)
    }
}
