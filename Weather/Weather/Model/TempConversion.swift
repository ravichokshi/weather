//
//  TempConversion.swift
//  Weather
//
//  Created by Ravi Chokshi on 15/02/19.
//  Copyright © 2019 Ravi Chokshi. All rights reserved.
//

import Foundation

class TempConversion {
    public static let sharedInstance = TempConversion()
    
    func kelvintocelcius(K : Double ) -> Double{
        return (K - 273)
    }
    
    func kelvintoForenhite(K : Double) -> Double{
        return  9.0/5.0 * (K - 273) + 32
    }
}
