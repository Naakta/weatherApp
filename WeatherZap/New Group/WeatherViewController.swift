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
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var rainChanceLabel: UILabel!
    
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
        
        cityLabel.text = "\(city.name ?? "Unknown"), \(city.state ?? "")"
        currentlyLabel.text = "\(city.weather?.currently?.temperature ?? 0.0)℉"
        feelsLikeLabel.text = "\(city.weather?.currently?.apparentTemperature ?? 0.0)℉"
        minutelyDescriptionLabel.text = (city.weather?.currently?.summary ?? "")
        currentImage.image = UIImage(named: city.weather?.currently?.icon ?? "default")
        
        todayDateFormatter.dateStyle = .full
        let dayFinder = todayDateFormatter.string(from: Date()).components(separatedBy: ",")
        todayDateFormatter.dateStyle = .short
        todayDateLabel.text = dayFinder[0] + ", " + todayDateFormatter.string(from: Date())
        hourlyDescriptionLabel.text = (city.weather?.hourly?.summary ?? "")
        
        if let num = city.weather?.daily?.data[0].temperatureLowTime {
            lowTempLabel.text = "\(city.weather?.daily?.data[0].temperatureLow ?? 0.0)℉ at " + editTime(from: Double(num))
        }
        
        if let num = city.weather?.daily?.data[0].temperatureHighTime {
            highTempLabel.text = "\(city.weather?.daily?.data[0].temperatureHigh ?? 0.0)℉ at " + editTime(from: Double(num))
        }
        
        if let num = city.weather?.daily?.data[0].sunriseTime {
            sunriseLabel.text = editTime(from: Double(num))
        }
        
        if let num = city.weather?.daily?.data[0].sunsetTime {
            sunsetLabel.text = editTime(from: Double(num))
        }
        
        if let num = city.weather?.daily?.data[0].humidity {
            humidityLabel.text = "\(num * 100)%"
        }
        
        if let num = city.weather?.daily?.data[0].precipProbability {
            rainChanceLabel.text = "\(num * 100)%"
        }
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
