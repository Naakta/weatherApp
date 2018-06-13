//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Doug Wagner on 5/27/18.
//  Copyright © 2018 Doug Wagner. All rights reserved.
//

import UIKit
import CoreLocation

class CityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddCityDelegate {
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var newLocationButton: UIButton!
    
    var citiesArray = [City]()
    
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
        var city = citiesArray[indexPath.row]
        
        var label = cell.viewWithTag(110) as! UILabel
        label.text = city.name
        
        if let cellCity = city.weather {
            label = cell.viewWithTag(111) as! UILabel
            label.text = "\(cellCity.currently?.temperature ?? 990.0)℉"
        } else {
            Weather.getWeatherData(for: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)) {
                weather in
                if let conditionsData = weather {
                    city.weather = conditionsData
                    DispatchQueue.main.async {
                        label = cell.viewWithTag(111) as! UILabel
                        label.text = "\(city.weather?.currently?.temperature ?? 990.0)℉"
                        label = cell.viewWithTag(112) as! UILabel
                        label.text = city.weather?.currently?.icon
                    }
                }
            }
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

