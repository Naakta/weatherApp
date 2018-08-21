//
//  Weather.swift
//  MyWeatherApp
//
//  Created by Doug Wagner on 6/4/18.
//  Copyright © 2018 Doug Wagner. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct Weather: Codable {
    
    var currently: Currently?
    var hourly: Hourly?
    var daily: Daily?
    
    
    static let myAPIString = "https://api.darksky.net/forecast/\(myKey)/"
    
    static func getWeatherData(for coordinates: CLLocationCoordinate2D, callback: @escaping (Weather?) -> Void) {
        let fullString = "\(myAPIString)\(coordinates.latitude),\(coordinates.longitude)"
        print("***I am sending this call to DarkSky: \(fullString)***")
        let thisURL = URL(string: fullString)
        let dataTask = URLSession.shared.dataTask(with: thisURL!, completionHandler: {
            (data, response, error) -> Void in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        let weather = try decoder.decode(Weather.self, from: data)
                        callback(weather)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        })
        dataTask.resume()
    }
}

struct Currently: Codable {
    var temperature: Double?
    var apparentTemperature: Double?
    var summary: String?
    var icon: String?
}

struct Hourly: Codable {
    var summary: String?
    var icon: String?
    var data = [TempHourData?]()

}

struct Minutely: Codable {
    var summary: String?
}

struct TempHourData: Codable {
    var precipIntensity: Double?
    var precipProbability: Double?
}

struct Daily: Codable {
    var data = [TempDayData]()
}

struct TempDayData: Codable {
    var sunriseTime: Int?
    var sunsetTime: Int?
    var temperatureHigh: Double?
    var temperatureHighTime: Int?
    var temperatureLow: Double?
    var temperatureLowTime: Int?
    var humidity: Double?
    var precipProbability: Double?
}


