//
//  AddCityViewController.swift
//  MyWeatherApp
//
//  Created by Doug Wagner on 5/27/18.
//  Copyright © 2018 Doug Wagner. All rights reserved.
//

import UIKit

protocol AddCityDelegate {
    func userAddedNewCity(newCity: City)
}

class AddCityViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var latitudeTF: UITextField!
    @IBOutlet weak var cityNameTF: UITextField!
    @IBOutlet weak var longitudeTF: UITextField!
    
    var delegate: CityViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func collectAndSend() {
        let latStr = Double(latitudeTF.text!)
        let lonStr = Double(longitudeTF.text!)
        let myCity = City(name: cityNameTF.text!, latitude: latStr!, longitude: lonStr!)
        delegate?.userAddedNewCity(newCity: myCity)
        
//        if let latStr = latStr {
//            if let lonStr = lonStr {
//                let myCity = City(name: cityNameTF.text!, latitude: latStr, longitude: lonStr)
//                delegate?.userAddedNewCity(newCity: myCity)
//            }
//        }
        
    }
}
