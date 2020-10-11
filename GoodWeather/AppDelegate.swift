//
//  AppDelegate.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 16.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import UIKit
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSPlacesClient.provideAPIKey("AIzaSyD0gtQGco6O-eoZqg1ym4UYWCrpPtq7aWc")
        
        return true
    }
}

