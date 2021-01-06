//
//  DetailWeatherTableViewCell.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 20.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit

class DetailWeatherTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    @IBOutlet private weak var detailWeatherCollectionView: UICollectionView!
    @IBOutlet private weak var aspectRatioConstraint2: NSLayoutConstraint!
    
    
    var weather: Weather!
    
    private var cellHeight: CGFloat = 10.0
    
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

        if !(UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? true) {
            cellHeight = width / 2
           print("PORTRAIT, height = \(cellHeight)")
        } else {
            cellHeight = width / 4
        }
        cellHeight = width / 2
        return CGSize(width: CGFloat(width), height: CGFloat(cellHeight))
//        return CGSize(width: 150, height: 150)
    }
}

extension DetailWeatherTableViewCell: CellWithCollectionView {
    
    func invalidateLayout() {
        let cell = detailWeatherCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? DetailCurrentWeatherCollectionViewCell
        cell?.setBackground()
        detailWeatherCollectionView.collectionViewLayout.invalidateLayout()
        
    }
}
