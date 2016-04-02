//
//  CatalogDetailViewController.swift
//  Trilateral
//
//  Created by Simone Civetta on 02/04/16.
//  Copyright © 2016 Cisco. All rights reserved.
//

import Foundation
import UIKit

class CatalogDetailViewController : UIViewController {
    @IBAction func didSelectCloseButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}