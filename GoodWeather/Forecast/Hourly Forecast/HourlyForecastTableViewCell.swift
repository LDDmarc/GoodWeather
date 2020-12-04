//
//  HourlyForecastTableViewCell.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 04.12.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit
import CoreData

class HourlyForecastTableViewCell: UITableViewCell {
    
    static let cellHeight: CGFloat = HourlyForecastCollectionViewCell.cellSize.height + 20 + 20
    
    @IBOutlet private weak var hourlyForecastCollectionView: UICollectionView!
    
    var dataManager: DataManager!
    var city: City!

    lazy var fetchedResultsController: NSFetchedResultsController<Weather> = {
        let request: NSFetchRequest = Weather.fetchRequest()
        if let lat = city.lat,
           let lon = city.lon {
            request.predicate = NSPredicate(format: "cityHourlyForecast.lat == %@ AND cityHourlyForecast.lon == %@", lat, lon)
        }
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 23
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        hourlyForecastCollectionView.delegate = self
        hourlyForecastCollectionView.dataSource = self
        hourlyForecastCollectionView.register(UINib(nibName: String(describing: HourlyForecastCollectionViewCell.self), bundle: nil),
                                        forCellWithReuseIdentifier: String(describing: HourlyForecastCollectionViewCell.self))
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 6
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal

        hourlyForecastCollectionView.collectionViewLayout = layout
        hourlyForecastCollectionView.showsHorizontalScrollIndicator = false
    }
}

extension HourlyForecastTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HourlyForecastCollectionViewCell.self),
                                                            for: indexPath) as? HourlyForecastCollectionViewCell else {
            return UICollectionViewCell()
        }
        let weather = fetchedResultsController.object(at: indexPath)
        let presenter = HourlyForecastPresenter(view: cell, weather: weather)
        presenter.setupUI()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return HourlyForecastCollectionViewCell.cellSize
    }
    
}

extension HourlyForecastTableViewCell: NSFetchedResultsControllerDelegate {
    
}
