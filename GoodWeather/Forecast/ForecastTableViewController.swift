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
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: dataManager.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        do {
            try frc.performFetch()
        } catch {
            let nserror = error as NSError
            print(nserror.localizedDescription)
        }
        frc.delegate = self
        return frc
    }()
    
    lazy var apodFetchedResultsController: NSFetchedResultsController<APOD> = {
        let request: NSFetchRequest = APOD.fetchRequest()
        request.fetchBatchSize = 1
        let sort = NSSortDescriptor(key: "date", ascending: true)
               request.sortDescriptors = [sort]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: dataManager.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        do {
            try frc.performFetch()
        } catch {
            let nserror = error as NSError
            print(nserror.localizedDescription)
        }
        frc.delegate = self
        return frc
    }()
    
    private var APODTableViewCellHeight: CGFloat = 0.0
    
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
    
        tableView.register(UINib(nibName: String(describing: DetailWeatherTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DetailWeatherTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: ForecastTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ForecastTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: APODTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: APODTableViewCell.self))
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        title = city.name
        dataManager.getForecast(forCity: city) { (_) in }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return weatherFetchedResultsController.sections?[0].numberOfObjects ?? 0
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return apodFetchedResultsController.sections?[0].numberOfObjects ?? 0
        }
        return 0
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: APODTableViewCell.self), for: indexPath) as? APODTableViewCell else {
                return UITableViewCell()
            }
            let apod = apodFetchedResultsController.object(at: IndexPath(row: indexPath.row, section: 0))
            cell.configure(with: apod)
            cell.delegate = self
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 2 ? APODTableViewCellHeight : 230.0
    }
    
}

extension ForecastTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

extension ForecastTableViewController: APODTableViewCellDelegate {
    
    func apodTableViewCell(_ apodTableViewCell: APODTableViewCell, setHeight height: CGFloat) {
        APODTableViewCellHeight = height
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
