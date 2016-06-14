//
//  ViewController.swift
//  WeatherApp
//
//  Created by Dima on 12/02/16.
//  Copyright © 2016 Dima. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UISearchControllerDelegate, CLLocationManagerDelegate, WeatherListDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var currentCity: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var extend: UILabel!
    let locationManager = CLLocationManager()
    
    var weatherList = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.loadWeatherForCity("Moscow")
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupWeather(weather: Weather) {
        wind.text = "wind\n\(weather.windMps!) m/s"
        humidity.text = "humidity\n\(weather.humidity!)"
        
        temperature.text = "\(weather.tempC!)"
        
        currentCity.text = "\(weather.city!)"
        extend.text = "pressure\n\(weather.pressure!) mm Hg"
        weatherIcon.image = weather.icon
        
        let date = NSDate(timeIntervalSince1970: Double(weather.unixTime!)!)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "eeee MMM, dd"
        currentDate.text = dateFormatter.stringFromDate(date)
        UIView.transitionWithView(backgroundImage, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            self.backgroundImage.image = UIImage(named: "b_\(weather.iconString!)")
            }, completion: nil)
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueCityList" {
            let vc = segue.destinationViewController as! WeatherListTableViewController
            vc.delegate = self
            vc.weatherList = weatherList
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        Weather.loadWeatherForLocation(locValue.latitude, lon: locValue.longitude) { (weather) -> () in
            self.weatherList.insert(weather, atIndex: 0)
            self.setupWeather(weather)
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Weather List Delegate
    func weatherList(weatherList: WeatherListTableViewController, didSelectCity city: Weather) {
        self.setupWeather(city)
    }
}

