//
//  CurrentWeatherTableViewController.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 19.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit
import CoreData

class CurrentWeatherTableViewController: UITableViewController {

    let dataManager = DataManager(persistentContainer: CoreDataManager.shared.persistentContainer, dataBase: CoreDataBase())
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCity))
        
        timer = Timer.scheduledTimer(timeInterval: 1800,
                                     target: self,
                                     selector: #selector(updateWeatherByTimer),
                                     userInfo: nil,
                                     repeats: true)
       
        updateWeatherByTimer()
    }
    
    // MARK: - DataManager
    
    @objc func updateWeatherByTimer() {
        dataManager.getCurrentWeather { (_) in }
    }
    
    @objc func updateWeather() {
        dataManager.getCurrentWeather { (dataManagerError) in
            self.showErrorAlert(withError: dataManagerError)
        }
    }

    @objc func addCity() {
        let alertController = UIAlertController(title: "Новый город", message: "Введите имя города", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Москва"
        }
        let confirmAction = UIAlertAction(title: "Добавить", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            self.dataManager.addNewCity(withName: textField.text) { (dataManagerError) in
                self.showErrorAlert(withError: dataManagerError)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func showErrorAlert(withError dataManagerError: DataManagerError?) {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            guard let error = dataManagerError,
                let title = error.errorTitleMessage().0,
                let messge = error.errorTitleMessage().1 else { return }
            let alertController = UIAlertController(title: title, message: messge, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alertController, animated: true)
        }
    }

    // MARK: - Table view data source

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
}

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
