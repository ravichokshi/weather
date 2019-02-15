//
//  AppDelegate.swift
//  Weather
//
//  Created by Ravi Chokshi on 15/02/19.
//  Copyright © 2019 Ravi Chokshi. All rights reserved.
//

import UIKit
import Reachability

var SelectedLattitude: Double = 0.0
var SelectedLongitude: Double = 0.0

let appDel = (UIApplication.shared.delegate as? AppDelegate)


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var locManagerObj : LocationManager!
    
    //#Reachability
    private var isInternetOn = false
    var reachability: Reachability?

    var mainNavigationController: UINavigationController?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.mainNavigationController?.navigationBar.barStyle = UIBarStyle.black

        let mapViewContorller = MapViewContorller(nibName: "MapViewContorller", bundle: nil)
        
        
        let defaults = UserDefaults.standard
        defaults.set(CELCIUS, forKey: "type")
        
        mainNavigationController = UINavigationController(rootViewController: mapViewContorller)
        
        window?.rootViewController = mainNavigationController

        self.window?.makeKeyAndVisible()
        
        //#Reachability
        setupReachabilityWith(hostName: nil)
        
     
        return true
    }

    //MARK: Reachability
    //#Reachability
    func setupReachabilityWith(hostName: String?) {
        
        //1. Initialize Reachability
        self.reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        
        //2. Closures for reachability
        
        reachability?.whenReachable = { reachability in
            DispatchQueue.main.async {
                
                self.isInternetOn = true
                print("Closure: Network reachable")
                
            }
        }
        
        reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                
                self.isInternetOn = false
                print("Closure: Network not reachable")
                
            }
        }
        
        //3. Start Notifier
        do {
            try self.reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        //Note: By below code we can additionally check whether network is reachable via cellular, Wifi.
        //4. Reachability Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(note:)), name: Notification.Name("reachabilityChanged"), object: self.reachability)
        
        
    }
    
    //In case, if needed.
    func stopNotifier() {
        
        self.reachability?.stopNotifier()
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reachabilityChanged"), object: self.reachability)
        
    }
    
    /* For receiving, Reachability notifications. */
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
            
        case .wifi:
            //            self.isInternetOn = true
            
            
            print("Notification: Reachable via WiFi")
            
        case .cellular:
            //            self.isInternetOn = true
            print("Notification: Reachable via Cellular")
            
        case .none:
            //            self.isInternetOn = false
            print("Notification: Network not reachable")
            
        }
        
        if reachability.connection == .wifi || reachability.connection == .cellular
        {
          
        }
    }
    
    
    func isNetworkAvailable() -> Bool
    {
        if isInternetOn == true {
            return true
        }
        else {
            return false
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

