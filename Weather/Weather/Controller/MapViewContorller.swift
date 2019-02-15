//
//  MapViewContorller.swift
//  Weather
//
//  Created by Ravi Chokshi on 15/02/19.
//  Copyright © 2019 Ravi Chokshi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewContorller : UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var lable: UILabel!
    var myLocation:CLLocationCoordinate2D?
    
    var selectedLatitude : Double!
    var selectedLongitude : Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for Authorisation from the User.
     
        self.title = "Weather"
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        map.delegate = self
        map.mapType = .standard
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        
        if let coor = map.userLocation.location?.coordinate{
            map.setCenter(coor, animated: true)
        }
        addLongPressGesture()
        addDoubleTapGesture()
        
       // print("GestureRecognizers before \(self.map.subviews[0].gestureRecognizers?.count)")
        if (self.map.subviews[0].gestureRecognizers != nil){
            for gesture in self.map.subviews[0].gestureRecognizers!{
                if (gesture.isKind(of: UITapGestureRecognizer.self)){
                    self.map.subviews[0].removeGestureRecognizer(gesture)
                }
            }
        }
       // print("GestureRecognizers after \(self.map.subviews[0].gestureRecognizers?.count)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        map.showsUserLocation = true;
        
        self.getMyLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        map.showsUserLocation = false
    }
    
    func addLongPressGesture(){
        let longPressRecogniser:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target:self , action:#selector(MapViewContorller.handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 1.0 //user needs to press for 2 seconds
        self.map.addGestureRecognizer(longPressRecogniser)
    }
    
    @objc func handleLongPress(_ gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state != .began{
            return
        }
        
        // Delete any existing annotations.
        if self.map.annotations.count != 0 {
            self.map.removeAnnotations(self.map.annotations)
        }
        
        let touchPoint:CGPoint = gestureRecognizer.location(in: self.map)
        let touchMapCoordinate:CLLocationCoordinate2D =
            self.map.convert(touchPoint, toCoordinateFrom: self.map)
        
        let annot:MKPointAnnotation = MKPointAnnotation()
        annot.coordinate = touchMapCoordinate
        
        self.resetTracking()
        self.map.addAnnotation(annot)
        self.centerMap(touchMapCoordinate)
    }
    
    
    func addDoubleTapGesture(){
        let doubletapRecogniser:UITapGestureRecognizer = UITapGestureRecognizer(target:self , action:#selector(MapViewContorller.handledoubleTap(_:)))
        doubletapRecogniser.numberOfTapsRequired = 2
        self.map.addGestureRecognizer(doubletapRecogniser)
    }
    
    @objc func handledoubleTap(_ gestureRecognizer:UIGestureRecognizer){
       
        // Delete any existing annotations.
        if self.map.annotations.count != 0 {
            self.map.removeAnnotations(self.map.annotations)
        }
        
        
        let touchPoint:CGPoint = gestureRecognizer.location(in: self.map)
        let touchMapCoordinate:CLLocationCoordinate2D =
            self.map.convert(touchPoint, toCoordinateFrom: self.map)
        
        let annot:MKPointAnnotation = MKPointAnnotation()
        annot.coordinate = touchMapCoordinate
        
        self.resetTracking()
        self.map.addAnnotation(annot)
        self.centerMap(touchMapCoordinate)
        callweaher(location: touchMapCoordinate)
        
        
    }
    func callweaher (location : CLLocationCoordinate2D){
        let lat  : String = String(location.latitude)
        let long : String = String(location.longitude)
        
        selectedLatitude = Double(lat)!
        selectedLongitude =  Double(long)!
        
        
        APIManager.sharedInstance.loadWeatherData(url: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=6b2dd165a5eec1605cacbfaa45d4b218",completionHandler: self.APICompletionHandler(response:) )
    }
    
    func APICompletionHandler(response: [WeatherItem]) {
        
        
        let obj = DetailViewController(nibName : "DetailViewController" , bundle : nil)

        obj.weatherItems = response
        obj.vlog = selectedLatitude
        obj.vlat = selectedLongitude
        
        self.navigationController?.pushViewController(obj, animated:true)
        
        
        
    }
    
    func resetTracking(){
        if (map.showsUserLocation){
            map.showsUserLocation = false
            self.map.removeAnnotations(map.annotations)
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func centerMap(_ center:CLLocationCoordinate2D){
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpan(latitudeDelta: spanX, longitudeDelta: spanY))
        map.setRegion(newRegion, animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        centerMap(locValue)
    }
    
    @IBAction func getMyLocation() {
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.startUpdatingLocation()
            
            // Delete any existing annotations.
            if self.map.annotations.count != 0 {
                self.map.removeAnnotations(self.map.annotations)
            }
            
             self.map.showsUserLocation = true
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        let identifier = "pin"
        var view : MKPinAnnotationView
        
        if annotation .isKind(of: MKUserLocation.self)
        {
            mapView.showsUserLocation = true
            return nil
        }
        
        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
            dequeueView.annotation = annotation
            
            view = dequeueView
        }else{
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = false
            view.isEnabled = true
            view.animatesDrop = true
            //view.calloutOffset = CGPoint(x: -5, y: 5)
           // view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        //view.pinColor =  .red
        return view
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        print("mapView didSelect")
        
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
       
        print("calloutAccessoryControlTapped")
        
    }

}
