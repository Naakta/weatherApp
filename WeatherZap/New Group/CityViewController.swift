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
    
    // Delegate protocol
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
    
    
    @IBAction func refreshTable() {
        for city in citiesArray {
            if city.weather != nil {
                Weather.getWeatherData(for: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)) {
                    weather in
                    if let conditionsData = weather {
                        city.weather = conditionsData
                        print("refresh 1")
                        DispatchQueue.main.async {
                            self.homeTableView.reloadData()
                            city.timestamp = Date()
//                            self.testLabel.text = "\(city.timestamp)"
                            print("refresh 2")
                        }
                    }
                }
            }
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
    
        
//        do {
//            let data = try decoder.decode(City.self, from: firstCheck as! Data)
//            citiesArray = [data]
//            print("City Array found in UD")
//        } catch {
//            print("Error pulling data from User Defaults")
//        }
        
//        if let data = try? Data(contentsOf: path) {
//            let decoder = PropertyListDecoder()
//            do {
//                lists = try decoder.decode([Checklist].self, from: data)
//                sortChecklist()
//            } catch {
//                print("Error decoding item array!")
//                print("File Path is: \(dataFilePath())")
//            }
        
        super.viewDidLoad()
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

