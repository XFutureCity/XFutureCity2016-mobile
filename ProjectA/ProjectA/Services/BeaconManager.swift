//
//  BeaconManager.swift
//  ProjectA
//
//  Created by Simone Civetta on 01/04/16.
//  Copyright © 2016 Xebia IT Architects. All rights reserved.
//

import Foundation
import CoreLocation

let DefaultUUID = "B9407F30-F5F8-477E-AFF9-25556B57FE6D"

protocol BeaconManagerProtocol {
    func manager(manager: BeaconManager, didRangePOIs: [POI])
}

class BeaconManager : NSObject, CLLocationManagerDelegate {
    
    var allRegions = [CLBeaconRegion]()
    let locationManager = CLLocationManager()
    var delegate: BeaconManagerProtocol?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        guard CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .AuthorizedAlways else
        {
            return
        }
        
        self.initialize()
    }
    
    func initialize() {
        self.initBeaconRegions()
    }
    
    func initBeaconRegions() {
        let beacon = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: DefaultUUID)!, identifier: "xfuturecity-region")
        allRegions.append(beacon)
        
        allRegions.forEach {
            NSLog("Start monitoring region")
            locationManager.startMonitoringForRegion($0)
            locationManager.requestStateForRegion($0)
        }
    }
    
    // MARK : Regions
    
    func startBeaconRangingInRegion(region: CLRegion) {
        guard let region = region as? CLBeaconRegion else {
            return
        }
        self.locationManager.startRangingBeaconsInRegion(region)
    }
    
    func stopBeaconRangingInRegion(region: CLRegion) {
        guard let region = region as? CLBeaconRegion else {
            return
        }
        self.locationManager.stopRangingBeaconsInRegion(region)
    }
    
    // MARK : Location Manager
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        if manager != locationManager {
            return
        }
        
        if state == .Inside {
            self.startBeaconRangingInRegion(region)
        } else if state == .Outside {
            self.stopBeaconRangingInRegion(region)
        }
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        NSLog("Started monitoring region")
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if manager != locationManager {
            return
        }

        self.startBeaconRangingInRegion(region)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if manager != locationManager {
            return
        }
        
        self.stopBeaconRangingInRegion(region)
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        
        let POIs = beacons.map { beacon in
            return POI(proximity: beacon.proximity, beacon: beacon)
        }
        
        self.delegate?.manager(self, didRangePOIs: POIs)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            self.initialize()
        }
    }
}