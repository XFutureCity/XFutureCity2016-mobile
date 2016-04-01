//
//  ListViewController.swift
//  ProjectA
//
//  Created by Simone Civetta on 01/04/16.
//  Copyright © 2016 Xebia IT Architects. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, BeaconManagerProtocol {

    let beaconManager = BeaconManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beaconManager.delegate = self
    }

    func manager(manager: BeaconManager, didRangePOIs POIs: [POI]) {
        NSLog("\(POIs)")
    }
}
