//
//  AddCityViewController.swift
//  MyWeatherApp
//
//  Created by Doug Wagner on 5/27/18.
//  Copyright © 2018 Doug Wagner. All rights reserved.
//

import UIKit
import CoreLocation

protocol AddCityDelegate {
    func userAddedNewCity(newCity: City)
    func userDidCancel()
}

class AddCityViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    var delegate: CityViewController?
    lazy var geocoder = CLGeocoder()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentController.selectedSegmentIndex = 0
        textField1.returnKeyType = UIReturnKeyType.next
        textField1.becomeFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == UIReturnKeyType.done && textField.text != "" {
            collectAndSend()
            return true
        }
        if textField.returnKeyType == UIReturnKeyType.next && textField.text != "" {
            textField.resignFirstResponder()
            textField2.becomeFirstResponder()
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func segmentIndexChanged(_ sender: AnyObject) {
        switch segmentController.selectedSegmentIndex {
        case 0:
            textField1.returnKeyType = UIReturnKeyType.next
            textField1.resignFirstResponder()
            textField1.becomeFirstResponder()
            textField1.text = ""
            textField2.text = ""
            textField2.isHidden = false
            textField1.placeholder = "City"
            textField2.placeholder = "State"
        case 1:
            textField1.returnKeyType = UIReturnKeyType.done
            textField1.resignFirstResponder()
            textField1.becomeFirstResponder()
            textField1.text = ""
            textField2.text = ""
            textField2.isHidden = true
            textField1.placeholder = "Zip Code"
        case 2:
            
            textField1.returnKeyType = UIReturnKeyType.next
            textField1.resignFirstResponder()
            textField1.becomeFirstResponder()
            textField1.text = ""
            textField2.text = ""
            textField2.isHidden = false;
            textField1.placeholder = "Latitude"
            textField2.placeholder = "Longitude"
        default:
            textField1.text = ""
            textField2.text = ""
            textField1.isHidden = true
            textField2.isHidden = true
        }
        
    }
    
    @IBAction func collectAndSend() {
        if segmentController.selectedSegmentIndex == 0 {
            let cityStr = textField1.text!
            let stateStr = textField2.text!
            geocoder.geocodeAddressString("\(cityStr),\(stateStr)") {
                (placemarks, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    var location: CLLocation?
                    
                    if let placemarks = placemarks, placemarks.count > 0 {
                        location = placemarks.first?.location
                    }
                    
                    if let location = location {
                        let coordinate = location.coordinate
                        let newCity = City(latitude: coordinate.latitude, longitude: coordinate.longitude)
                        newCity.name = placemarks?.first?.locality
                        newCity.state = placemarks?.first?.administrativeArea
                        self.delegate?.userAddedNewCity(newCity: newCity)
                    }
                }
            }
            
        } else if segmentController.selectedSegmentIndex == 1 {
            let zipStr = textField1.text!
            geocoder.geocodeAddressString(zipStr) {
                (placemarks, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    var location: CLLocation?
                    
                    if let placemarks = placemarks, placemarks.count > 0 {
                        location = placemarks.first?.location
                    }
                    
                    if let location = location {
                        let coordinate = location.coordinate
                        let newCity = City(latitude: coordinate.latitude, longitude: coordinate.longitude)
                        newCity.name = placemarks?.first?.locality
                        newCity.state = placemarks?.first?.administrativeArea
                        self.delegate?.userAddedNewCity(newCity: newCity)
                    }
                }
            }
            
        } else if segmentController.selectedSegmentIndex == 2 {
            let latStr = Double(textField1.text!)
            let lonStr = Double(textField2.text!)
            let coords = CLLocation(latitude: latStr!, longitude: lonStr!)
            let myCity = City(latitude: latStr!, longitude: lonStr!)
            
            geocoder.reverseGeocodeLocation(coords) {
                (placemarks, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let placemarks = placemarks {
                        myCity.name = placemarks.first?.locality
                        myCity.state = placemarks.first?.administrativeArea
                        self.delegate?.userAddedNewCity(newCity: myCity)
                    }
                }
            }
        }
    }
    
    @IBAction func userDidCancel() {
        delegate?.userDidCancel()
    }

}
