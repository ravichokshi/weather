//
//  APIManager.swift
//  Weather
//
//  Created by Ravi Chokshi on 15/02/19.
//  Copyright © 2019 Ravi Chokshi. All rights reserved.
//

import Foundation


protocol APIManagerDelegate {
    func didWeatherAvailable(weatherItems : [WeatherItem])
}

class APIManager{
    public static let  sharedInstance = APIManager()
    var delegate : APIManagerDelegate?
    
    func loadWeatherData(url : String,completionHandler: (([WeatherItem]) -> Void)? = nil){
        URLSession.shared.dataTask(with: URL(string : url)!) { (data, response, error) in
            print("LOAD")
            if (error != nil){
                print(error?.localizedDescription ?? "NA")
            }else{
                do{
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? JSONDictionary{
                        

                            var weatherItems = [WeatherItem]()

                           let a = WeatherItem(data: json)
                            weatherItems = [a]
                        
                        
                        
                            DispatchQueue.main.async {
                               // self.delegate?.didWeatherAvailable(weatherItems: weatherItems)
                                
                                if completionHandler != nil {
                                    
                                    completionHandler!(weatherItems)
                                    return
                                }
                               
                            }
                        }
                
                    
                    
                    
                }catch{
                    print(error.localizedDescription)
                }
            }
            }.resume()
        
    }
    
}
