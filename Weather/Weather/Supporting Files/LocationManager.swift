//
//  LocationManager.swift
//  Weather
//
//  Created by Ravi Chokshi on 15/02/19.
//  Copyright © 2019 Ravi Chokshi. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject,CLLocationManagerDelegate
{

    //Location manager
    var m_GPSCoordinate = CLLocationCoordinate2D()
    var m_LocationManager: CLLocationManager?
    var m_iGPSStatus: Int = 0
    
    override init() {
      
        super.init()
    }
    
    // MARK: - GPS Methods
    func start_GPS()
    {
        m_GPSCoordinate.longitude = 0.0
        m_GPSCoordinate.latitude = 0.0
        m_iGPSStatus = 0
        m_LocationManager?.stopUpdatingLocation()
        m_LocationManager?.stopMonitoringSignificantLocationChanges()
        
        m_LocationManager?.requestWhenInUseAuthorization()
        
        m_LocationManager?.startUpdatingLocation()
    }
    
    func stop_GPS() {
        m_LocationManager?.stopUpdatingLocation()
        m_LocationManager?.stopMonitoringSignificantLocationChanges()
    }
    
    func init_GPS()
    {
        m_iGPSStatus = 0
        m_LocationManager = CLLocationManager()
        m_LocationManager?.desiredAccuracy = kCLLocationAccuracyBest
        m_LocationManager?.delegate = self
        m_LocationManager?.activityType = .fitness
    }
    
    // MARK: - locationManager delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        // print("UPDATING")
        let newLocation: CLLocation? = locations.last
        m_GPSCoordinate = (newLocation?.coordinate)!
        
        SelectedLattitude = m_GPSCoordinate.latitude
        SelectedLongitude = m_GPSCoordinate.longitude
        
        NSLog("SelectedLattitude = %f SelectedLongitude = %f" , SelectedLattitude,SelectedLongitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("locationManager failed")
        m_iGPSStatus = 1
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        print("Status = \(status.hashValue)")
    }
    

    
}

