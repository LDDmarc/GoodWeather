//
//  SearchPlaceViewController.swift
//  GoodWeather
//
//  Created by d.leonova on 09.01.2021.
//  Copyright © 2021 Дарья Леонова. All rights reserved.
//

import UIKit
import MapKit

protocol SearchPlaceViewControllerAutocompleteDelegate: class {
    func viewController(_ viewController: SearchPlaceViewController, didAutocompleteWith place: MKLocalSearch.Response?)
    func viewController(_ viewController: SearchPlaceViewController, didFailAutocompleteWithError error: Error)
    func getCurrentLocation(_ viewController: SearchPlaceViewController)
    func wasCancelled(_ viewController: SearchPlaceViewController)
}

class SearchPlaceViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var resultsTableView: UITableView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    weak var delegate: SearchPlaceViewControllerAutocompleteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        
        searchBar.delegate = self
        
        activityIndicator.isHidden = true
        
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.tableFooterView = UIView()
        
        titleLabel.text = NSLocalizedString("SearchPlaceViewController_title", comment: "")
        cancelButton.setTitle(NSLocalizedString("cancel_title", comment: ""), for: .normal)
        searchBar.placeholder = NSLocalizedString("placeholder_city", comment: "")
    }
    
    @IBAction private func cancelButtonTap(_ sender: UIButton) {
        delegate?.wasCancelled(self)
    }
    
    @IBAction private func getLocation(_ sender: UIButton) {
        delegate?.getCurrentLocation(self)
    }
}

extension SearchPlaceViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            searchCompleter.queryFragment = searchText
        }
    }
}

extension SearchPlaceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let completion = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        search.start { [weak self] (response, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.viewController(self, didFailAutocompleteWithError: error)
            } else {
                self.delegate?.viewController(self, didAutocompleteWith: response)
            }
        }
    }
}

extension SearchPlaceViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        resultsTableView.reloadData()
    }
    
    private func completer(completer: MKLocalSearchCompleter, didFailWithError error: NSError) {
        delegate?.viewController(self, didFailAutocompleteWithError: error)
    }
}
