//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Dima on 25/02/16.
//  Copyright © 2016 Dima. All rights reserved.
//

import UIKit
import Alamofire

protocol SearchViewControllerDelegate {
    func search(search: SearchViewController, didSetCity city: String)
}

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: SearchViewControllerDelegate?
    
    var citiesArray = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.hidden = true
        searchBar.becomeFirstResponder()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: nil) { (notification) -> Void in
            let object = notification.userInfo!["UIKeyboardFrameEndUserInfoKey"]
            var keyboardFrame = CGRectNull
            if object?.respondsToSelector("getValue:") != nil {
                object?.getValue(&keyboardFrame)
            }
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.size.height, 0.0)
                }, completion: nil)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            
            let newString = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())
            
            let url = "http://autocomplete.wunderground.com/aq?query=\(newString!)&lang=ru"
            
            request(.GET, url).responseJSON { (response) -> Void in
                if let JSON = response.result.value {
                    if let results = JSON["RESULTS"] as? NSArray {
                        var cities = [City]()
                        for item in results {
                            let city = City(response: item as! NSDictionary)
                            cities.append(city)
                        }
                        self.citiesArray = cities
                        self.tableView.reloadData()
                    }
                }
            }
            tableView.hidden = false
        } else {
            citiesArray = [City]()
            tableView.reloadData()
        }
    }
        
    // MARK: - TableView Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesArray.count
    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CityIdentifier", forIndexPath: indexPath)
        
        let city = citiesArray[indexPath.row]
        cell.textLabel?.text = city.name
        cell.textLabel?.textColor = UIColor.whiteColor()
        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let city = citiesArray[indexPath.row]
        delegate?.search(self, didSetCity: city.link)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
