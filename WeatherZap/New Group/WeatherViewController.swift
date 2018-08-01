//
//  WeatherViewController.swift
//  MyWeatherApp
//
//  Created by Doug Wagner on 5/27/18.
//  Copyright © 2018 Doug Wagner. All rights reserved.
//

import UIKit

protocol WeatherDataDelegate {
    
}

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var currentlyLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var minutelyDescriptionLabel: UILabel!
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var hourlyDescriptionLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    
    var delegate: CityViewController?
    var dateFormatter = DateFormatter()
    var todayDateFormatter = DateFormatter()
    var city: City!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "h:mm a"
        title = "Weather Data"
        
        // Change this to show some error label if weather is nil
        if city.weather != nil {
            print("city info received")
        }
        
        cityLabel.text = "\(city.name ?? "Unknown"), \(city.state ?? "??")"
        currentlyLabel.text = "Currently \(city.weather?.currently?.temperature ?? 0.0)℉"
        feelsLikeLabel.text = "Feels like \(city.weather?.currently?.apparentTemperature ?? 0.0)℉"
        minutelyDescriptionLabel.text = "Immediate forecast: " + (city.weather?.currently?.summary ?? "")
        currentImage.image = UIImage(named: city.weather?.currently?.icon ?? "default")
        
        todayDateFormatter.dateStyle = .full
        todayDateLabel.text = todayDateFormatter.string(from: Date())
        hourlyDescriptionLabel.text = "Today's forecast: " + (city.weather?.hourly?.summary ?? "")
        lowTempLabel.text = "Low of \(city.weather?.daily?.data[0].temperatureLow ?? 0.0)℉ at " + editTime(from: Double((city.weather?.daily?.data[0].temperatureLowTime)!))
        highTempLabel.text = "High of \(city.weather?.daily?.data[0].temperatureHigh ?? 0.0)℉ at " + editTime(from: Double((city.weather?.daily?.data[0].temperatureHighTime)!))
        sunriseLabel.text = "Sunrise at " + editTime(from: Double((city.weather?.daily?.data[0].sunriseTime)!))
        sunsetLabel.text = "Sunset at " + editTime(from: Double((city.weather?.daily?.data[0].sunsetTime)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func editTime(from dataTime: Double) -> String {
        let theTime = Date(timeIntervalSince1970: Double(dataTime))
        return dateFormatter.string(from: theTime)
    }

}
