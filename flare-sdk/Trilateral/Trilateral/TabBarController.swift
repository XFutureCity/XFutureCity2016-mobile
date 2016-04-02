//
//  TabBarController.swift
//  Trilateral
//
//  Created by Simone Civetta on 02/04/16.
//  Copyright © 2016 Cisco. All rights reserved.
//

import Foundation
import UIKit

class TabBarController : UITabBarController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedIndex = 4
        self.tabBar.hidden = true
    }
}