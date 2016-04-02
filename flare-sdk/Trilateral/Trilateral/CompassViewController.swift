//
//  CompassViewController.swift
//  Trilateral
//
//  Created by Andrew Zamler-Carhart on 12/9/15.
//  Copyright © 2015 Cisco. All rights reserved.
//

import UIKit
import Flare
import CoreLocation

class CompassViewController: UIViewController {
    
    @IBOutlet weak var compass: CompassView!

    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidAppear(animated: Bool) {
        appDelegate.flareController = compass
        appDelegate.updateFlareController()
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
    
    override func viewDidDisappear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
