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
    
    @IBOutlet weak var line3: UILabel!
    @IBOutlet weak var line7: UILabel!
    @IBOutlet weak var line8: UILabel!
    
    override func viewDidLoad() {
        self.line3.layer.borderWidth = 2
        self.line3.layer.borderColor = UIColor.whiteColor().CGColor
        self.line7.layer.borderWidth = 2
        self.line7.layer.borderColor = UIColor.whiteColor().CGColor
        self.line8.layer.borderWidth = 2
        self.line8.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    
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