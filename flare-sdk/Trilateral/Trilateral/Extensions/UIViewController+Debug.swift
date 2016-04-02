//
//  UIViewController+Debug.swift
//  Trilateral
//
//  Created by Simone Civetta on 02/04/16.
//  Copyright © 2016 Cisco. All rights reserved.
//

import Foundation

extension UIViewController {
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