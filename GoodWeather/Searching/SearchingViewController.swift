//
//  SearchingViewController.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 20.09.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit
import MapKit

protocol SearchingViewControllerDelegate: class {
    func searchingViewController(close searchingViewController: SearchingViewController)
    func searchingViewController(searchingViewController: SearchingViewController, didSelectItemWith coordinates: CLLocationCoordinate2D)
}

class SearchingViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    let searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    weak var delegate: SearchingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
    }
}

//MARK: - Private
private extension SearchingViewController {
    func start(_ search:  MKLocalSearch) {
        search.start { [weak self] (response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let response = response else {
                print("no response")
                return
            }
            if let item = response.mapItems.first {
                let coordinates = item.placemark.coordinate
                self?.delegate?.searchingViewController(searchingViewController: self ?? SearchingViewController(), didSelectItemWith: coordinates)
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension SearchingViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        searchCompleter.queryFragment = text
        if (searchResults.first?.title.contains(text) ?? false) { print("Так и есть") }
        guard !searchResults.isEmpty || (searchResults.first?.title.contains(text) ?? false) else {
            showErrorAlert(withError: .wrongName)
            return
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        let search = MKLocalSearch(request: request)
        start(search)
    }
}

//MARK: - MKLocalSearchCompleterDelegate
extension SearchingViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

//MARK: - UITableViewDataSource
extension SearchingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let searchResult = searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SearchingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult = searchResults[indexPath.row]
        let request = MKLocalSearch.Request(completion: searchResult)
        let search = MKLocalSearch(request: request)
        start(search)
    }
}
