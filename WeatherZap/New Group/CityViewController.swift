//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Doug Wagner on 5/27/18.
//  Copyright © 2018 Doug Wagner. All rights reserved.
//

import UIKit
import CoreLocation

class CityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddCityDelegate, WeatherDataDelegate {
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var newLocationButton: UIButton!

    
    var citiesArray = [City]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Delegate protocols
    func userAddedNewCity(newCity: City) {
        citiesArray.append(newCity)
        dismiss(animated: true, completion: nil)
        homeTableView.reloadData()
    }
    
    func userDidCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesArray.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        let city = citiesArray[indexPath.row]
        
        var label = cell.viewWithTag(110) as! UILabel
        label.text = "\(city.name ?? ""), \(city.state ?? "")"
        
        if let cellCity = city.weather {
            label = cell.viewWithTag(111) as! UILabel
            label.text = "Currently \(cellCity.currently?.temperature ?? 990.0)℉"
            label = cell.viewWithTag(112) as! UILabel
            label.text = "High of \(city.weather?.daily?.data[0].temperatureHigh ?? 9090.0)℉"
            let cellImage = cell.viewWithTag(113) as! UIImageView
            cellImage.image = UIImage(named: city.weather?.currently?.icon ?? "default")
            label = cell.viewWithTag(150) as! UILabel
            label.text = "\(city.timestamp)"
        } else {
            Weather.getWeatherData(for: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)) {
                weather in
                if let conditionsData = weather {
                    city.weather = conditionsData
                    DispatchQueue.main.async {
                        label = cell.viewWithTag(111) as! UILabel
                        label.text = "Currently \(city.weather?.currently?.temperature ?? 9090.0)℉"
                        label = cell.viewWithTag(112) as! UILabel
                        label.text = "High of \(city.weather?.daily?.data[0].temperatureHigh ?? 9090.0)℉"
                        let cellImage = cell.viewWithTag(113) as! UIImageView
                        cellImage.image = UIImage(named: city.weather?.currently?.icon ?? "default")
                        city.timestamp = Date()
                        label = cell.viewWithTag(150) as! UILabel
                        label.text = "\(city.timestamp)"
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            citiesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "cityArray") {
            let decoder = JSONDecoder()
            do {
                citiesArray = try decoder.decode([City].self, from: data)
            } catch {
                print("Decoding failed.")
            }
        }
        super.viewDidLoad()
    }
    
    @IBAction func refreshTable() {
        for city in citiesArray {
            if city.weather != nil {
                Weather.getWeatherData(for: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)) {
                    weather in
                    if let conditionsData = weather {
                        city.weather = conditionsData
                        DispatchQueue.main.async {
                            self.homeTableView.reloadData()
                            city.timestamp = Date()
                        }
                    }
                }
            }
        }
    }
    
    func refreshIfNeeded() {
        let currentDate = Date()
        print(currentDate)
        if citiesArray[0].weather != nil {
            let dateComp = compareDates(date1: citiesArray[0].timestamp, date2: currentDate)
            if dateComp > 1800 {
                refreshTable()
            } else if dateComp == -1 {
                print("Error occurred, date comparison was not valid.")
            } else {
                print("WeatherData is still current, no need to refresh.")
            }
        }
    }
    
    func compareDates(date1: Date, date2: Date) -> Int {
        let calendar = Calendar.current
        let date1Components = calendar.dateComponents([.day, .hour, .minute, .second], from: date1)
        let date2Components = calendar.dateComponents([.day, .hour, .minute, .second], from: date2)
        if let date1Day = date1Components.day,
            let date2Day = date2Components.day,
            date1Day < date2Day {
            print("Second date is later")
            return 1801
        }
        
        guard let date1Hour = date1Components.hour,
            let date1Min = date1Components.minute,
            let date1Sec = date1Components.second,
            let date2Hour = date2Components.hour,
            let date2Min = date2Components.minute,
            let date2Sec = date2Components.second else { return -1 }
        
        let date1Seconds = (date1Hour * 3600) + (date1Min * 60) + date1Sec
        let date2Seconds = (date2Hour * 3600) + (date2Min * 60) + date2Sec
        
        print("Seconds between these dates = \(date2Seconds - date1Seconds)")
        return date2Seconds - date1Seconds
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewCity" {
            let controller = segue.destination as! AddCityViewController
            controller.delegate = self
        } else if segue.identifier == "CityData" {
            let controller = segue.destination as! WeatherViewController
            controller.delegate = self
            if let indexPath = homeTableView.indexPath(for: sender as! UITableViewCell) {
                controller.city = citiesArray[indexPath.row]
            }
        }
    }
}

