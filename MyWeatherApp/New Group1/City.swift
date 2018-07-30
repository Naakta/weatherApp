//
//  City.swift
//  MyWeatherApp
//
//  Created by Doug Wagner on 5/27/18.
//  Copyright © 2018 Doug Wagner. All rights reserved.
//

import Foundation
import CoreLocation

class City {
    var name: String?
    var state: String?
    var country: String?
    var latitude = 0.0
    var longitude = 0.0
    var weather: Weather?
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
