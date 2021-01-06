//
//  CurrentWeatherTableViewController+GooglePlaces.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 10.10.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation
import GooglePlaces

extension CurrentWeatherTableViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        guard let placeName = place.name else { return }
        let placeCoordinates = place.coordinate
        let placeLat = "\(placeCoordinates.latitude)"
        let placeLon = "\(placeCoordinates.longitude)"
        let coordinates = Coordinates(lat: placeLat, lon: placeLon)
        let cityInfo = CityInfo(name: placeName, coordinates: coordinates)
        
        dataManager.addNewCity(with: cityInfo) { (error) in
            if error == nil {
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                    self?.showInfoAlert(title: "Неизвестное место", message: "К сожалению, нам не ведомы эти места")
                }
            }
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        dismiss(animated: true, completion: nil)
        showInfoAlert(title: "Что-то пошло не так", message: error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
   
}

extension UIViewController {
    func showInfoAlert(title: String?, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ОК", style: .cancel))
        present(ac, animated: true)
    }
}
