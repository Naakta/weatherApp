//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Doug Wagner on 5/27/18.
//  Copyright © 2018 Doug Wagner. All rights reserved.
//

import UIKit

class CityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddCityDelegate {
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var newLocationButton: UIButton!
    
    var citiesArr = [City]()
    
    // Delegate protocol
    func userAddedNewCity(newCity: City) {
        citiesArr.append(newCity)
        dismiss(animated: true, completion: nil)
        homeTableView.reloadData()
//        navigationController?.popViewController(animated: true)
    }
    
    // tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        let city = citiesArr[indexPath.row]
        
        let label = cell.viewWithTag(110) as! UILabel
        label.text = city.name
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let testCity = City(name: "Orlando", latitude: 9.0, longitude: 6.8)
        citiesArr.append(testCity)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewCity" {
            let controller = segue.destination as! AddCityViewController
            controller.delegate = self
        }
    }
}

