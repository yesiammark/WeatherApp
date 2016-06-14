//
//  Weather.swift
//  WeatherApp
//
//  Created by Dima on 12/02/16.
//  Copyright © 2016 Dima. All rights reserved.
//

import Foundation
import Alamofire

class Weather {
    
    //var icon: UIImage?
    var city: String?
    var unixTime: String?
    var weatherString: String?
    var tempF: Int?
    var tempC: Int?
    var humidity: String?
    var windMps: Int?
    var pressure: Int?
    var icon: UIImage?
    var iconString: String?
    
    init(response: NSDictionary) {
        if let currentObservation = response["current_observation"] as? NSDictionary {
            if let displayLocation = currentObservation["display_location"] as? NSDictionary {
                city = displayLocation["city"] as? String
            }
            unixTime = currentObservation["local_epoch"] as? String
            weatherString = currentObservation["weather"] as? String
            tempF = currentObservation["temp_f"] as? Int
            tempC = currentObservation["temp_c"] as? Int
            humidity = currentObservation["relative_humidity"] as? String
            if let windKph = currentObservation["wind_kph"] as? Float {
                windMps = convertSpeedFromKph(windKph)
            }
            if let pressureMB = currentObservation["pressure_mb"] as? String {
                pressure = convertPressure(Double(pressureMB)!)
            }
            if let string = currentObservation["icon"] as? String {
                iconString = string
                icon = UIImage(named: string)
            }
        }

    }
    
    private func convertPressure(mb: Double) -> Int {
        return Int(mb * 0.750061561303)
    }
    
    private func convertSpeedFromKph(kph: Float) -> Int {
        return Int(kph * 0.277778)
    }
    
    static func loadWeatherForLocation(lat: Double, lon: Double,complition: (Weather) -> ()) {
        
        let url = "http://api.wunderground.com/api/925c2db2c9409440/conditions/q/\(lat),\(lon).json"
        
        request(.GET, url).responseJSON { (response) -> Void in
            if let JSON = response.result.value {
                let weather = Weather(response: JSON as! NSDictionary)
                complition(weather)
            }
        }
    }
    
    static func loadWeatherForCity(city: String, complition: (Weather) -> ()) {
        
        let link = "http://api.wunderground.com/api/925c2db2c9409440/conditions\(city).json"
        
        request(.GET, link).responseJSON { response in
            
            if let JSON = response.result.value {
                let weather = Weather(response: JSON as! NSDictionary)
                complition(weather)
            }
            
        }
        
    }
}