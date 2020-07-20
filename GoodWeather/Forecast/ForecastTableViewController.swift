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
    
    let dataManager: DataManager
    let city: City
    
    lazy var weatherFetchedResultsController: NSFetchedResultsController<Weather> = {
        let request: NSFetchRequest = Weather.fetchRequest()
        if let name = city.name {
            request.predicate = NSPredicate(format: "city.name == %@", name)
        }
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 1
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: dataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try frc.performFetch()
        } catch {
            let nserror = error as NSError
            print(nserror.localizedDescription)
        }
        frc.delegate = self
        return frc
    }()
    
    lazy var forecastFetchedResultsController: NSFetchedResultsController<Weather> = {
        let request: NSFetchRequest = Weather.fetchRequest()
        let hours = [13, 14, 15]
        let predicate = NSPredicate(format: "hour in %@", hours)
        if let name = city.name {
            request.predicate = NSPredicate(format: "cityForecast.name == %@", name)
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "cityForecast.name == %@", name), predicate])
        } else {
            request.predicate = predicate
        }
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 5
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: dataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try frc.performFetch()
        } catch {
            let nserror = error as NSError
            print(nserror.localizedDescription)
        }
        frc.delegate = self
        return frc
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    init(dataManager: DataManager, city: City) {
        self.dataManager = dataManager
        self.city = city
        super.init(style: .plain)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.rowHeight = 230.0
        tableView.register(UINib(nibName: String(describing: DetailWeatherTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DetailWeatherTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: ForecastTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ForecastTableViewCell.self))
        tableView.tableFooterView = UIView()
        
        dataManager.getForecast(forCity: city) { (_) in
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailWeatherTableViewCell.self), for: indexPath) as? DetailWeatherTableViewCell else {
                return UITableViewCell()
            }
            let weather = weatherFetchedResultsController.object(at: indexPath)
            cell.weather = weather
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ForecastTableViewCell.self), for: indexPath) as? ForecastTableViewCell else {
                return UITableViewCell()
            }
            cell.city = city
            cell.dataManager = dataManager
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}


extension ForecastTableViewController: NSFetchedResultsControllerDelegate {
    
}
