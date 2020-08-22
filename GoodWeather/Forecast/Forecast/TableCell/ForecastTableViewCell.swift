//
//  ForecastTableViewCell.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 20.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit
import CoreData

class ForecastTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    var dataManager: DataManager!
    var city: City!

    lazy var fetchedResultsController: NSFetchedResultsController<DayAndNightWeather> = {
        let request: NSFetchRequest = DayAndNightWeather.fetchRequest()
        if let name = city.name {
            request.predicate = NSPredicate(format: "city.name == %@", name)
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

    var nightWeatherSet = Set<IndexPath>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        forecastCollectionView.delegate = self
        forecastCollectionView.dataSource = self
        forecastCollectionView.register(UINib(nibName: String(describing: ForecastCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ForecastCollectionViewCell.self))
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 6
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
    
        forecastCollectionView.collectionViewLayout = layout
        forecastCollectionView.showsHorizontalScrollIndicator = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ForecastCollectionViewCell.self), for: indexPath)
            as? ForecastCollectionViewCell else { return UICollectionViewCell() }
        let weather = fetchedResultsController.object(at: indexPath)
        if let day = weather.dayWeather {
            let presenter = ForecastPresenter(view: cell, weather: day)
            presenter.setUI()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 142.0
        let height = 197.0
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dayAndNightWeather = fetchedResultsController.object(at: indexPath)
        guard let cell = collectionView.cellForItem(at: indexPath) as? ForecastCollectionViewCell else { return }
        let weather: Weather?
        if nightWeatherSet.contains(indexPath) {
            nightWeatherSet.remove(indexPath)
            weather = dayAndNightWeather.dayWeather
        } else {
            nightWeatherSet.insert(indexPath)
            weather = dayAndNightWeather.nightWeather
        }
        guard let cellWeather = weather else { return }
        let presenter = ForecastPresenter(view: cell, weather: cellWeather)
       
        UIView.transition(with: cell, duration: 0.6, options: .transitionFlipFromRight, animations: {
            
            presenter.setUI()
        })
    }
    
}

extension ForecastTableViewCell: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        forecastCollectionView.reloadData()
    }
}