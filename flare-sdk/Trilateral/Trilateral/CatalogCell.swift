//
//  CatalogCell.swift
//  Trilateral
//
//  Created by Simone Civetta on 02/04/16.
//  Copyright © 2016 Cisco. All rights reserved.
//

import Foundation
import UIKit
import Flare


class CatalogCell : UICollectionViewCell {
    var device: Device?
    @IBOutlet weak var nameLabel: UILabel!

    func update(thing: Thing) {
        nameLabel.text = thing.name
//        commentLabel.text = thing?.comment
//        
//        if let price = thing?.data["price"] as? Int {
//            priceLabel.text = "$\(price)"
//        }
//        
//        if let imageName = thing?.imageName() {
//            thingImage.image = UIImage(named: imageName)
//        }
//        
//        if let distance = device?.distanceTo(thing!) {
//            distanceLabel.text = String(format: "%.1fm", distance)
//        } else {
//            distanceLabel.text = ""
//        }
    }
}