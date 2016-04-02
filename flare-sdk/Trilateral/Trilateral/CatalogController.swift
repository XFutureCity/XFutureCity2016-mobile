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
class CatalogController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, FlareController, UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var backgroundImage1: UIImageView!
    @IBOutlet weak var backgroundImage2: UIImageView!

    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let thingCellIdentifier = "Cell"
    var thingsSortedByAngle = [Thing]()
    var currentPage: Int?
    let scaleAnimator = ScaleAnimator()
    
    var currentEnvironment: Environment? { didSet(value) {
        // Set current position (for demo)
        if let device = device {
            appDelegate.flareManager.setPosition(device, position: Point3D(x: Double(100), y: Double(100), z: Double(0)), sender: nil)
        }
        dataChanged()
    }}
    
    var currentZone: Zone?
    var device: Device?
    var nearbyThing: Thing? { didSet {
        dataChanged()
    }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.flareController = self
        appDelegate.updateFlareController()
        self.collectionView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setupCollectionViewLayout()
        dataChanged()
    }

    func dataChanged() {
        guard let currentEnvironment = self.currentEnvironment, device = device else {
            return
        }
        thingsSortedByAngle = currentEnvironment.zones[0].things.sort {
            device.angleTo($0) < device.angleTo($1)
        }
        collectionView.reloadData()
        self.updateBackground()
    }
    
    func animate() {
        collectionView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addDebugModeRecognizer()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // CollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if currentEnvironment == nil { return 1 }
        return currentEnvironment!.zones.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thingsSortedByAngle.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let thing = thingsSortedByAngle[indexPath.item]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(thing.dataType.cellIdentifier, forIndexPath: indexPath) as! CatalogCell
        cell.update(thing, device: device!)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailViewController = storyboard!.instantiateViewControllerWithIdentifier("CardDetailViewController") as! CatalogDetailViewController
        detailViewController.thing = thingsSortedByAngle[indexPath.item]
        detailViewController.transitioningDelegate = self
        self.presentViewController(detailViewController, animated: true, completion: nil)
    }
    
    // Collection View Layout
    
    private var itemSize: CGSize {
        return CGSize(width: 320, height: 200)
    }
    
    func setupCollectionViewLayout() {
        let layout = YRCoverFlowLayout()
        layout.maxCoverDegree = 0.0
        layout.coverDensity = -0.05
        layout.minCoverOpacity = 0.8
        layout.minCoverScale = 1.0
        layout.scrollDirection = .Horizontal
        layout.itemSize = self.itemSize
        self.collectionView.collectionViewLayout = layout
    }
    
    // Background
    
    func updateBackground() {
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
        self.updateBackground()
    }
}


extension CatalogController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let indexPaths = collectionView.indexPathsForSelectedItems() where indexPaths.count > 0 else {
            return nil
        }
        guard let cell = collectionView.cellForItemAtIndexPath(indexPaths[0]) as? CatalogCell else {
            return nil
        }
        self.scaleAnimator.originFrame = cell.convertRect(cell.cardContainer.frame, toView: nil)
        self.scaleAnimator.presenting = true
        
        return self.scaleAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.scaleAnimator.presenting = false
        return self.scaleAnimator
    }
}