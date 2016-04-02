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
class CatalogController: UIViewController, UICollectionViewDataSource, FlareController, UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var backgroundImage1: UIImageView!
    @IBOutlet weak var backgroundImage2: UIImageView!

    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let thingCellIdentifier = "Cell"
    var thingsSortedByAngle = [Thing]()
    var currentPage = 0
    
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
        self.setupCollectionViewLayout()
        dataChanged()
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if currentEnvironment == nil { return 1 }
        return currentEnvironment!.zones.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thingsSortedByAngle.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(thingCellIdentifier, forIndexPath: indexPath) as! CatalogCell
        cell.update(thingsSortedByAngle[indexPath.item], device: device!)
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
        collectionView.reloadData()
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
    
    private var itemSize: CGSize {
        let nominalScreenWidth: CGFloat = 320.0
        let nominalItemWidth: CGFloat = 246.0
        let nominalItemHeight: CGFloat = 500.0
        let coefficient: CGFloat = self.view.bounds.size.width / nominalScreenWidth
        return CGSize(width: coefficient * nominalItemWidth, height: coefficient * nominalItemHeight)
    }
    
    func setupCollectionViewLayout() {
        let layout = YRCoverFlowLayout()
        layout.maxCoverDegree = 0.0
        layout.coverDensity = 0.0
        layout.minCoverOpacity = 0.8
        layout.minCoverScale = 1.0
        layout.scrollDirection = .Horizontal
        layout.itemSize = self.itemSize
        self.collectionView.collectionViewLayout = layout
    }
    
    func updatePagingIndicator() {
        guard self.collectionView.bounds.width > 0 else {
            return
        }
        let xOffset = self.collectionView.contentOffset.x
        let page: Int = Int(round(xOffset / self.collectionView.bounds.width))
        
        guard self.currentPage != page else {
            return
        }
        
        self.currentPage = page
        if let nextImage = self.thingsSortedByAngle[page].image {
            backgroundImage1.image = backgroundImage2.image
            backgroundImage2.image = UIImage(named: nextImage)
            UIView.animateWithDuration(0.5, animations: {
                self.backgroundImage1.alpha = 0.0
                self.backgroundImage2.alpha = 1.0
            }, completion: { completed in
                self.backgroundImage1.image = self.backgroundImage2.image
                self.backgroundImage1.alpha = 1.0
                self.backgroundImage2.alpha = 0.0
            })
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.updatePagingIndicator()
    }
}