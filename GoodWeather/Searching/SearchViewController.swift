//
//  SearchViewController.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 13.08.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit
import CoreData

protocol SearchViewControllerDelegate: class {
    func searchViewController(close searchViewController: SearchViewController)
    func searchViewController(searchViewController: SearchViewController, didSelectItemWith name: String)
}

class SearchViewController: UIViewController {
    
    let dataManager = DataManager(dataBase: CoreDataBase())
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableHeightConstraint: NSLayoutConstraint!
    
    var results = [SearchItem]()
    var cities = [CityName]()
    
    var currentText: String = ""
    var currentResults = [SearchItem]()
    
    weak var delegate: SearchViewControllerDelegate?
 
    @IBAction func closeButtonTap(_ sender: UIButton) {
        delegate?.searchViewController(close: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomSearchTextFieldCell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        view.addSubview(tableView)
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        delegate?.searchViewController(searchViewController: self, didSelectItemWith: text)
    }
}

// MARK: - Private
private extension SearchViewController {
    
    func updateSearchTableView() {
        var tableHeight: CGFloat = 0
        tableHeight = tableView.contentSize.height
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.tableHeightConstraint.constant = tableHeight
            self?.view.layoutIfNeeded()
        })
     
    }
    
    func filter(with newText: String) {
        results = []
        if !newText.contains(currentText) {
            let predicate = NSPredicate(format: "name BEGINSWITH[cd] %@", newText)
            let request : NSFetchRequest<CityName> = CityName.fetchRequest()
            request.predicate = predicate
            let taskContext = CoreDataManager.shared.persistentContainer.newBackgroundContext()
            taskContext.undoManager = nil
            taskContext.performAndWait {
                do {
                    cities = try taskContext.fetch(request)
                } catch {
                    print("Error while fetching data: \(error)")
                }
            }
            for city in cities {
                let item = SearchItem(name: city.name ?? "")
                let filterRange = (item.name as NSString).range(of: newText, options: .caseInsensitive)
                
                if filterRange.location != NSNotFound {
                    item.attributedName = NSMutableAttributedString(string: item.name)
                    item.attributedName?.setAttributes([.font: UIFont.boldSystemFont(ofSize: 19)], range: filterRange)
                    results.append(item)
                }
            }
        } else {
            for item in currentResults {
                let filterRange = (item.name as NSString).range(of: newText, options: .caseInsensitive)
                
                if filterRange.location != NSNotFound {
                    item.attributedName = NSMutableAttributedString(string: item.name)
                    item.attributedName?.setAttributes([.font: UIFont.boldSystemFont(ofSize: 19)], range: filterRange)
                    results.append(item)
                }
            }
        }
        
        currentText = newText
        currentResults = results
        tableView.reloadData()
        updateSearchTableView()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSearchTextFieldCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.attributedText = results[indexPath.row].getFormatedText()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.searchViewController(searchViewController: self, didSelectItemWith: results[indexPath.row].name)
    }
}
