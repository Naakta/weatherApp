//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Doug Wagner on 5/27/18.
//  Copyright © 2018 Doug Wagner. All rights reserved.
//

import UIKit

class CityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var HomeTableView: UITableView!
    @IBOutlet weak var NewLocationButton: UIButton!
    
    var citiesArr = [City]()
    
    
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
        // Do any additional setup after loading the view, typically from a nib.
    }
}

