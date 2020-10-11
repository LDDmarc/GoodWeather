//
//  CurrentWeatherTableViewController.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 19.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import GooglePlaces

class CurrentWeatherTableViewController: UITableViewController {

    let dataManager = DataManager(dataBase: CoreDataBase())
    var timer: Timer?

    lazy var fetchedResultsController: NSFetchedResultsController<City> = {
        let request: NSFetchRequest = City.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 20
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

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(updateWeather), for: .valueChanged)
        tableView.rowHeight = 60.0
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Погода"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(searchForNewCity))
        
        detectFirstLaunch()
        
        timer = Timer.scheduledTimer(timeInterval: 1800,
                                     target: self,
                                     selector: #selector(updateWeatherByTimer),
                                     userInfo: nil,
                                     repeats: true)
        updateWeatherByTimer()
        dataManager.getAPOD { [weak self] (dataManagerError) in
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
                self?.showErrorAlert(withError: dataManagerError)
            }
        }
    }
    
    // MARK: - DataManager
    @objc func updateWeatherByTimer() {
        dataManager.getCurrentWeather { (_) in }
    }
    
    @objc func updateWeather() {
        dataManager.getCurrentWeather { [weak self] (dataManagerError) in
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
                self?.showErrorAlert(withError: dataManagerError)
            }
        }
    }
    @objc func searchForNewCity() {
        let autocompleteViewController = GMSAutocompleteViewController()
        autocompleteViewController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .region
        autocompleteViewController.autocompleteFilter = filter
        present(autocompleteViewController, animated: true, completion: nil)
    }
    
// MARK: - Table view data source, Table view delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CurrentWeatherTableViewCell else {
            return UITableViewCell()
        }
        let city = fetchedResultsController.object(at: indexPath)
        let viewModel = CurrentWeatherViewModel(city: city)
        cell.viewModel = viewModel
        cell.viewModel.setViewModel()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = fetchedResultsController.object(at: indexPath)
        let vc = ForecastTableViewController(dataManager: dataManager, city: city)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let city = fetchedResultsController.object(at: indexPath)
            dataManager.context.delete(city)
            try? dataManager.context.save()
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension CurrentWeatherTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            tableView.reloadData()
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            tableView.reloadData()
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

//MARK: - SearchingViewControllerDelegate
extension CurrentWeatherTableViewController: SearchingViewControllerDelegate {
    
    func searchingViewController(close searchingViewController: SearchingViewController) {
        searchingViewController.dismiss(animated: true, completion: nil)
    }
    
    func searchingViewController(searchingViewController: SearchingViewController, didSelectItemWith coordinates: CLLocationCoordinate2D) {
        dataManager.addNewCity(withCoordinates: coordinates) { (error) in
            if error == nil {
                DispatchQueue.main.async {
                    searchingViewController.dismiss(animated: true, completion: nil)
                }
            } else {
                searchingViewController.showErrorAlert(withError: error)
            }
        }
    }
}

//MARK: - Private -
private extension CurrentWeatherTableViewController {
    
     func detectFirstLaunch() {
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "First launch") {
            fillCities()
            print("FILL")
            defaults.set(true, forKey: "First launch")
        }
    }
    
     func fillCities() {
        guard let url = Bundle.main.url(forResource: "cities", withExtension: "json") else {
            print("no file")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let jsonObject = try JSON(data: data)
            for object in jsonObject["city"].arrayValue {
                guard let city = NSEntityDescription.insertNewObject(forEntityName: "CityName", into: dataManager.context) as? CityName else { return }
                city.update(with: object)
                do {
                    try dataManager.context.save()
                } catch  {
                    print("coredata.error")
                }
            }
    
        } catch {
            print("data.error")
        }
    }

}

