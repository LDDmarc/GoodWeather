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
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var weather: Weather!
    
    private lazy var cellSize: CellSize = {
        let landscapeCellHeight = (contentView.bounds.width/3 > 165.0) ? contentView.bounds.width/3 : 165.0
        let offSet: CGFloat = UIScreen.main.bounds.width < 350.0 ? 8.0 : 20.0
        let cell_size = CellSize(portraitCellHeight: 165.0, landscapeCellHeight: landscapeCellHeight, offSet: offSet)
        return cell_size
    }()
    
    private struct CellSize {
        let portraitCellHeight: CGFloat
        let landscapeCellHeight: CGFloat
        let offSet: CGFloat
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none

        detailWeatherCollectionView.delegate = self
        detailWeatherCollectionView.dataSource = self
        detailWeatherCollectionView.register(UINib(nibName: String(describing: DetailCurrentWeatherCollectionViewCell.self), bundle: nil),
                                             forCellWithReuseIdentifier: String(describing: DetailCurrentWeatherCollectionViewCell.self))
        
        detailWeatherCollectionView.contentInset = UIEdgeInsets(top: cellSize.offSet,
                                                                left: cellSize.offSet,
                                                                bottom: cellSize.offSet,
                                                                right: cellSize.offSet)
//        detailWeatherCollectionView
        
        heightConstraint?.constant = cellSize.portraitCellHeight + 2 * cellSize.offSet
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
        
        let width = floor(collectionView.bounds.width - 2 * cellSize.offSet)
        
        var cellHeight: CGFloat = 0
        if !(UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? true) {
            cellHeight = cellSize.portraitCellHeight
        } else {
            cellHeight = cellSize.landscapeCellHeight
        }
        
        return CGSize(width: CGFloat(width), height: CGFloat(cellHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSize.offSet
    }
}

extension DetailWeatherTableViewCell: CellWithCollectionView {
    
    func invalidateLayout() {
        let cell = detailWeatherCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? DetailCurrentWeatherCollectionViewCell
        cell?.setBackground()
        detailWeatherCollectionView.collectionViewLayout.invalidateLayout()
        
        if (UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? true) {
            heightConstraint?.constant = cellSize.landscapeCellHeight + 2 * cellSize.offSet
        } else {
            heightConstraint?.constant = cellSize.portraitCellHeight + 2 * cellSize.offSet
                //contentView.bounds.width / 2
        }
        contentView.layoutIfNeeded()
    }

}
