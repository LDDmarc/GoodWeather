//
//  DataBaseProtocol.swift
//  GoodWeather
//
//  Created by Дарья Леонова on 18.07.2020.
//  Copyright © 2020 Дарья Леонова. All rights reserved.
//

import Foundation

protocol DataBaseProtocol: class {
    func save()
    func delete()
    func update()
}
