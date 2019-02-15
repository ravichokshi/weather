//
//  DetailViewController.swift
//  Weather
//
//  Created by Ravi Chokshi on 15/02/19.
//  Copyright © 2019 Ravi Chokshi. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController,APIManagerDelegate {
    
    let manager = APIManager.sharedInstance
    
    var weatherItems = [WeatherItem]()
    var vlat : Double = 0.0
    var vlog : Double = 0.0
    
    
    @IBOutlet var cordinarteView: UIView!
    @IBOutlet var up: UIView!
    
    @IBOutlet var lat: UILabel!
    @IBOutlet var lon: UILabel!
    @IBOutlet var country: UILabel!
    
    override var prefersStatusBarHidden: Bool{return false}
    
    
    @IBOutlet var red: UIView!
    @IBOutlet var green: UIView!
    @IBOutlet var yello: UIView!
    @IBOutlet var blue: UIView!
    @IBOutlet var chocklet: UIView!
  
    @IBOutlet var humidity: UILabel!
    @IBOutlet var pressure: UILabel!
    @IBOutlet var id: UILabel!
    @IBOutlet var temp_type: UILabel!
    @IBOutlet var temp_minMAx: UILabel!
    @IBOutlet var temp_current: UILabel!
    @IBOutlet var temp_min: UILabel!
    @IBOutlet var temp_max: UILabel!
  
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
     
      
      
        callData = weatherItems[0]
      print(callData)
        self.country.text = weatherItems[0].city_name
        var doubleStr = String(format: "%.5f", vlat)
        self.lat.text = "Lat : \(doubleStr)"
        doubleStr = String(format: "%.5f", vlog)
        self.lon.text = "Lon : \(doubleStr)"
        
    }
    
    
    func didWeatherAvailable(weatherItems: [WeatherItem]) {
        self.weatherItems = weatherItems
        DispatchQueue.main.async {
           
           
        }
        
    }
    
    @IBOutlet var settings: UIButton!
    
  
    
    
    
    
    var callData: WeatherItem? {
        didSet {
            setWeatherlData()
        }
    }
    
    
    
    func setWeatherlData(){
        if let vhumidity = callData?.humadity{
            self.humidity.text = "\(vhumidity)%"
        }else{
            self.humidity.text = "NA"
        }
        if let vpressure = callData?.pressure{
            self.pressure.text = "\(vpressure) hPa"
        }else{
            self.pressure.text = "NA"
        }
        if let vid = callData?.id{
            self.id.text = "\(vid)"
        }else{
            self.id.text = "NA"
        }
        
        // SET TEMP
        setTemp()
       
      
        
    }
    
   
    
 
    func setTemp(){
        
        guard let temp = callData?.temp  else {
            self.temp_current.text = "NA"; return
        }
        guard let max_temp = callData?.temp_max  else {
            self.temp_max.text = "NA";return
        }
        guard let min_temp = callData?.temp_min else {
            self.temp_min.text = "NA";return
        }
        let defaults = UserDefaults.standard
        
        guard let userdefault = defaults.string(forKey: "type") else {
            
            self.temp_current.text = "Current Temp : " + String(Int(round(temp)))
            self.temp_max.text = "Max Temp : " + String(Int(round(max_temp)))
            self.temp_min.text = "Min Temp : " + String(Int(round(min_temp)))
            self.temp_type.text = "\u{00B0}C"
            return
        }
        
        if userdefault == CELCIUS{
            let ctemp = TempConversion.sharedInstance.kelvintocelcius(K: temp)
          
            
            self.temp_current.text = "Current Temp : " + String(Int(round(ctemp)))
            self.temp_max.text = "Max Temp : " + String(Int(round(ctemp)))
            self.temp_min.text = "Min Temp : " + String(Int(round(ctemp)))
            self.temp_type.text = "\u{00B0}C"
        }
        if userdefault == FORENHITE{
            let ctemp = TempConversion.sharedInstance.kelvintoForenhite(K: temp)
            self.temp_current.text = "Current Temp : " + String(Int(round(ctemp)))
            self.temp_max.text = "Max Temp : " + String(Int(round(ctemp)))
            self.temp_min.text = "Min Temp : " + String(Int(round(ctemp)))
            
            self.temp_type.text = "\u{00B0}F"
        }
        
        if userdefault == KELVIN{
            self.temp_current.text = "Current Temp : " + String(Int(round(temp)))
            self.temp_max.text = "Max Temp : " + String(Int(round(temp)))
            self.temp_min.text = "Min Temp : " + String(Int(round(temp)))
            self.temp_type.text = "\u{00B0}K"
        }
    }
}


