//
//  NearbyThingController.swift
//  Trilateral
//
//  Created by Andrew Zamler-Carhart on 12/9/15.
//  Copyright © 2015 Cisco. All rights reserved.
//

import UIKit
import Flare

extension Device {
    var normalizedAngle: CGFloat {
        let originalAngle = self.angle()
        return originalAngle < 0 ? CGFloat(360 - originalAngle) : CGFloat(originalAngle)
    }
}

@available(iOS 9.0, *)
class CatalogController: UIViewController, UICollectionViewDataSource, FlareController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let thingCellIdentifier = "Cell"
    var thingsSortedByAngle = [Thing]()
    
    var currentEnvironment: Environment? { didSet(value) {
        self.collectionView.reloadData()
        
        // Set current position (for demo)
        if let device = device {
            appDelegate.flareManager.setPosition(device, position: Point3D(x: Double(100), y: Double(100), z: Double(0)), sender: nil)
        }
    }}
    
    var currentZone: Zone?
    var device: Device?
    var nearbyThing: Thing? { didSet(value) {
            // update selection
            dataChanged()
        }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        appDelegate.flareController = self
        appDelegate.updateFlareController()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(300, self.view.frame.height)
        dataChanged()
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if currentEnvironment == nil { return 0 }
        return currentEnvironment!.zones.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thingsSortedByAngle.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(thingCellIdentifier, forIndexPath: indexPath) as! CatalogCell
        cell.update(thingsSortedByAngle[indexPath.item])
        return cell
    }

    func dataChanged() {
        guard let currentEnvironment = self.currentEnvironment, device = device else {
            return
        }
        thingsSortedByAngle = currentEnvironment.zones[0].things.sort {
            device.angleTo($0) < device.angleTo($1)
        }
        collectionView.reloadData()
    }
    
    func animate() {
        guard let device = device else {
            return
        }
        
        let convertedOffset = device.normalizedAngle / 360.0 * collectionView.contentSize.width
        
        UIView.animateWithDuration(0.3, delay: 0, options: [.BeginFromCurrentState, .AllowUserInteraction, .CurveEaseOut], animations: {
            self.collectionView.contentOffset = CGPointMake(convertedOffset, 0)
        }, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addDebugModeRecognizer()
    }
    
    func addDebugModeRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CompassViewController.toggleDebug))
        gestureRecognizer.numberOfTapsRequired = 3
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    func toggleDebug() {
        guard let tabBar = self.tabBarController?.tabBar else {
            return
        }
        tabBar.hidden = !tabBar.hidden
    }
}