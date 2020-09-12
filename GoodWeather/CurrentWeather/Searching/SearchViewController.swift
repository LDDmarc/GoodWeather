//
//  SearchViewController.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 13.08.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    
    let dataManager = DataManager(persistentContainer: CoreDataManager.shared.persistentContainer, dataBase: CoreDataBase())
    
    @IBOutlet private weak var textField: SearchTextField!
   
    let tableView = UITableView(frame: CGRect(x: 20, y: 94, width: UIScreen.main.bounds.width - 40, height: 0))
    
    var results = [SearchItem]()
    var cities = [CityName]()
    
    var currentText: String = ""
    var currentResults = [SearchItem]()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(changedTextFieldValue), for: .editingChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomSearchTextFieldCell")
        view.addSubview(tableView)
    }
    
    @objc func changedTextFieldValue() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateResults), userInfo: nil, repeats: false)
    }
    
    @objc func updateResults() {
//        tableView.reloadData()
//        updateSearchTableView()
    }
    

}

//MARK: - SearchTextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = ""
        if let oldText = textField.text,
            let textRange = Range(range, in: oldText) {
            newText = oldText.replacingCharacters(in: textRange, with: string)
        }
        filter(with: newText)
        return true
    }
}

// MARK: - Private
private extension SearchViewController {
    
    func updateSearchTableView() {
        var tableHeight: CGFloat = 0
        tableHeight = tableView.contentSize.height
     
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.tableView.frame = CGRect(x: 20, y: 94, width: UIScreen.main.bounds.width - 40, height: tableHeight)
        })
        
        tableView.layer.masksToBounds = true
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layer.cornerRadius = 5.0
        tableView.separatorColor = UIColor.lightGray
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        tableView.reloadData()
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
}
