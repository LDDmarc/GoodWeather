//
//  GoogleAPISearchViewController.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 10.10.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit
import GooglePlaces

class GoogleAPISearchViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var resultsTableView: UITableView!
    private var tableDataSource: GMSAutocompleteTableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource()
        resultsTableView.delegate = tableDataSource
        resultsTableView.dataSource = tableDataSource
        
        searchBar.delegate = self
    }
    
    private func setupDataSource() {
        tableDataSource = GMSAutocompleteTableDataSource()
        let filter = GMSAutocompleteFilter()
        filter.type = .region
        tableDataSource.autocompleteFilter = filter
        tableDataSource.delegate = self
    }
    
   
}

//MARK: - UISearchBarDelegate -
extension GoogleAPISearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText = \(searchText)")
        tableDataSource.sourceTextHasChanged(searchText)
    }
}

//MARK: - GMSAutocompleteTableDataSourceDelegate -
extension GoogleAPISearchViewController: GMSAutocompleteTableDataSourceDelegate {
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        // Handle the error.
        print("Error: \(error.localizedDescription)")
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        return true
    }
    
    func didUpdateAutocompletePredictionsForTableDataSource(tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator off.
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        // Reload table data.
        resultsTableView.reloadData()
    }
    
    func didRequestAutocompletePredictionsForTableDataSource(tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator on.
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // Reload table data.
        resultsTableView.reloadData()
    }
}


