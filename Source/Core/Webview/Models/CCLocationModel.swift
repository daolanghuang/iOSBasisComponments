//
//  CCLocationModel.swift
//  CCAppManager
//
//  Created by 廖望 on 2017/9/21.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit
import CoreLocation

class CCLocationModel: NSObject {
    static let sharedLocationModel = CCLocationModel.init()
    var locationManager = CLLocationManager()
    var latitude: Double?
    var longitude: Double?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 300
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    func getCurrentLocation() -> (latitude: Double?,longitude: Double?)? {
        if self.latitude == nil || self.longitude == nil {
            return nil
        }
        return (self.latitude,self.longitude)
    }
    
}

extension CCLocationModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currLocation : CLLocation = locations.last!
        // 纬度
        self.latitude = currLocation.coordinate.latitude
        // 经度
        self.longitude = currLocation.coordinate.longitude
    }
}

