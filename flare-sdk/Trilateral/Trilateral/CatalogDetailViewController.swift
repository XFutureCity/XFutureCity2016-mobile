//
//  CatalogDetailViewController.swift
//  Trilateral
//
//  Created by Simone Civetta on 02/04/16.
//  Copyright © 2016 Cisco. All rights reserved.
//

import Foundation
import UIKit
import Flare

class CatalogDetailViewController : UIViewController {
    
    var thing: Thing!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func didSelectCloseButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = thing.uiColor
        self.titleLabel.text = thing.name
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}