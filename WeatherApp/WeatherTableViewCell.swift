//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Dima on 04/03/16.
//  Copyright © 2016 Dima. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillWithWeather(weather: Weather) {
        cityName.text = weather.city
        backgroundImage.image = UIImage(named: "b_\(weather.iconString!)")
    }
    
}
