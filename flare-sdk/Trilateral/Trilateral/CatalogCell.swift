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

extension Thing {
    var image: String? {
        guard let images = self.data["images"] as? [String] where images.count > 0 else {
            return nil
        }
        return images[0] + ".jpg"
    }
    
    var color: String? {
        return self.data["color"] as? String
    }
    
    var uiColor: UIColor {
        guard let color = self.color else {
            return UIColor.clearColor()
        }
        switch color {
        case "green":
            return UIColor(red:0.124,  green:0.687,  blue:0.615, alpha:1)
        case "brown":
            return UIColor(red:0.421,  green:0.255,  blue:0.036, alpha:1)
        case "red":
            return UIColor(red:0.421,  green:0.255,  blue:0.036, alpha:1)
        case "white":
            return UIColor.whiteColor()
        default:
            return UIColor.clearColor()
        }
    }
}

func degreesToRadians(angle: Double) -> Double {
    return angle / 180.0 * M_PI
}

class CatalogCell : UICollectionViewCell {
    var device: Device?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cardContainer: UIView!
    @IBOutlet weak var compass: UIView!
    
    func update(thing: Thing, device: Device) {
        nameLabel.text = thing.name
        cardContainer.backgroundColor = thing.uiColor
        nameLabel.textColor = thing.uiColor == UIColor.whiteColor() ? .blackColor() : .whiteColor()
        
        let rads = degreesToRadians(device.angleTo(thing)) - degreesToRadians(device.angle())
        compass.transform = CGAffineTransformMakeRotation(CGFloat(rads));
    }
}