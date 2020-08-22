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
    
    @IBOutlet private weak var textField: SearchTextField!
   
    let tableView = UITableView(frame: CGRect(x: 20, y: 94, width: UIScreen.main.bounds.width - 40, height: 0))
    
    var results = [String]()
    var cities = [CityName]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomSearchTextFieldCell")
        view.addSubview(tableView)
    }
}

//MARK: - SearchTextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        updateSearchTableView()
        return true
    }
}

// MARK: - TableView updating
extension SearchViewController {
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
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSearchTextFieldCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.attributedText = NSAttributedString(string: "Test")
        return cell
    }
}
