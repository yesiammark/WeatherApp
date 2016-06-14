//
//  City.swift
//  WeatherApp
//
//  Created by Dima on 26/02/16.
//  Copyright © 2016 Dima. All rights reserved.
//

import Foundation

class City {
    var name: String!
    var link: String!
    
    init(response: NSDictionary) {
        if let cityName = response["name"] as? String {
            name = cityName
        }
        if let cityLink = response["l"] as? String {
            link = cityLink
        }
    }
}