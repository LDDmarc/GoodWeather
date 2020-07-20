//
//  ForecastTableViewController.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 19.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit
import CoreData

class ForecastTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 235.0
        tableView.register(UINib(nibName: String(describing: DetailWeatherTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DetailWeatherTableViewCell.self))
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailWeatherTableViewCell.self), for: indexPath) as? DetailWeatherTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
}
