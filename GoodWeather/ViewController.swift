//
//  ViewController.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 16.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak private var mainView: UIView!
    @IBOutlet weak private var textLabel1: UILabel!
    @IBOutlet weak private var textLabel2: UILabel!
    
    var scaleX: CGFloat = -1
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.layer.cornerRadius = 20
        mainView.layer.cornerCurve = .continuous
        mainView.addSubview(textLabel1)
        mainView.addGestureRecognizer(tapGestureRecognizer)
    
        tapGestureRecognizer.addTarget(self, action: #selector(rotateView))
    }

    @objc func rotateView() {
        UIView.transition(with: mainView, duration: 0.7, options: .transitionFlipFromRight, animations: {
            self.textLabel1.text = (self.scaleX != -1) ? "Туда" : "Сюда"
            self.mainView.backgroundColor = (self.scaleX == -1) ? .purple : .systemIndigo

        }, completion: nil)
        scaleX = (scaleX == -1) ? 1 : -1
    }
}

extension UIViewController {
    
    func showErrorAlert(withError dataManagerError: DataManagerError?) {
        DispatchQueue.main.async {
            guard let error = dataManagerError,
                let title = error.errorTitleMessage().0,
                let messge = error.errorTitleMessage().1 else { return }
            let alertController = UIAlertController(title: title, message: messge, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alertController, animated: true)
        }
    }
}
