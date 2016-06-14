//
//  WeatherListTableViewController.swift
//  WeatherApp
//
//  Created by Dima on 04/03/16.
//  Copyright © 2016 Dima. All rights reserved.
//

import UIKit

class WeatherListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SearchViewControllerDelegate {
    
    var weatherList = [Weather]()
    var delegate: WeatherListDelegate?
    var isCelcius = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chengeTemp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("weatherCell", forIndexPath: indexPath) as! WeatherTableViewCell
        
        let weather = weatherList[indexPath.row]
        cell.fillWithWeather(weather)
        
        if isCelcius {
            cell.temperature.text = "\(weather.tempC!)"
        } else {
            cell.temperature.text = "\(weather.tempF!)"
        }
        
        return cell
    }

    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row > 0 {
            return true
        } else {
            return false
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let weather = weatherList[indexPath.row]
        delegate?.weatherList(self, didSelectCity: weather)
        let viewController = UIApplication.sharedApplication().delegate?.window!!.rootViewController as! ViewController
        viewController.weatherList = weatherList
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    // Override to support editing the table view.
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            weatherList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }


    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueSearch" {
            let vc = segue.destinationViewController as! SearchViewController
            vc.delegate = self
        }
    }
    
    // MARK: - SearchViewControllerDelegate
    
    func search(search: SearchViewController, didSetCity city: String) {
        
        if city.containsString("/q/zmw:") {
            Weather.loadWeatherForCity(city) { (weather) -> () in
                self.weatherList.append(weather)
                let indexPath = NSIndexPath(forRow: self.weatherList.count - 1, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        } else {
            print("Something wrong with city link!")
        }
    }
    
    @IBAction func actionChangeTemperatyretype(sender: AnyObject) {
        isCelcius = !isCelcius
        tableView.reloadData()
    }

}

protocol WeatherListDelegate {
    func weatherList(weatherList: WeatherListTableViewController, didSelectCity city: Weather)
}
