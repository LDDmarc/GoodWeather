//
//  ForecastTableViewController.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 19.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

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
        
        tableView.register(UINib(nibName: String(describing: DetailWeatherTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: DetailWeatherTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: HourlyForecastTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: HourlyForecastTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: ForecastTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: ForecastTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: APODTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: APODTableViewCell.self))
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        
        tableView.separatorInset = UIEdgeInsets(top: 0,
                                                left: Constants.CollectionViewLayout.horizontalOffSet,
                                                bottom: 0,
                                                right: Constants.CollectionViewLayout.horizontalOffSet)
        
        title = city.name
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.visibleCells.forEach { ($0 as? CellWithCollectionView)?.invalidateLayout() }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return weatherFetchedResultsController.sections?[0].numberOfObjects ?? 0
        case 1, 2:
            return 1
        case 3:
            return apodFetchedResultsController.sections?[0].numberOfObjects ?? 0
        default:
            return 0
        }
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HourlyForecastTableViewCell.self), for: indexPath) as? HourlyForecastTableViewCell else {
                return UITableViewCell()
            }
            cell.city = city
            cell.dataManager = dataManager
            return cell
        } else if indexPath.section == 2 {
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
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.delegate = self
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return HourlyForecastTableViewCell.cellHeight
        case 2:
            return ForecastTableViewCell.cellHeight
        case 3:
            return UITableView.automaticDimension
        default:
            return 0
        }
        
    }
    
}

//MARK: - NSFetchedResultsControllerDelegate -
extension ForecastTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

protocol CellWithCollectionView: class {
    func invalidateLayout()
}

//MARK: - APODTableViewCellDelegate -
extension ForecastTableViewController: APODTableViewCellDelegate {
    
    func showNASAwebsite() {
        if let url = URL(string: "https://api.nasa.gov/index.html") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    func apodTableViewCell(updateHeight apodTableViewCell: APODTableViewCell) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
