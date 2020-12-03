//
//  DetailWeatherTableViewCell.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 20.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit

class DetailWeatherTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var detailWeatherCollectionView: UICollectionView!
    
    var weather: Weather!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        detailWeatherCollectionView.delegate = self
        detailWeatherCollectionView.dataSource = self
        detailWeatherCollectionView.register(UINib(nibName: String(describing: DetailCurrentWeatherCollectionViewCell.self), bundle: nil),
                                             forCellWithReuseIdentifier: String(describing: DetailCurrentWeatherCollectionViewCell.self))
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DetailCurrentWeatherCollectionViewCell.self), for: indexPath)
            as? DetailCurrentWeatherCollectionViewCell else { return UICollectionViewCell() }
        let presenter = DetailCurrentWeatherPresenter(view: cell, weather: weather)
        presenter.setupUI()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(contentView.bounds.width - contentView.layoutMargins.left - contentView.layoutMargins.right)
        let height = 165.0
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
}
