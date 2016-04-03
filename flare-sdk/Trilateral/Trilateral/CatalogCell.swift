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

func degreesToRadians(angle: Double) -> Double {
    return angle / 180.0 * M_PI
}

class CatalogCell : UICollectionViewCell {
    var device: Device?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subnameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cardContainer: UIView!
    @IBOutlet weak var compass: DirectionView!
    @IBOutlet weak var ligne3: UILabel!
    @IBOutlet weak var ligne7: UILabel!
    @IBOutlet weak var ligne8: UILabel!
    
    func update(thing: Thing, device: Device) {
        nameLabel.text = thing.name
        cardContainer.backgroundColor = thing.uiColor
        nameLabel.textColor = thing.uiColor == UIColor.whiteColor() ? .blackColor() : .whiteColor()
        subnameLabel.textColor = nameLabel.textColor
        
        let image = UIImage(named: "compass.png")
        let renderedImage = image?.imageWithRenderingMode(.AlwaysTemplate)
        compass.image = renderedImage
        compass.tintColor = thing.uiColor
        
        ligne3?.layer.borderColor = UIColor.whiteColor().CGColor
        ligne3?.layer.borderWidth = 1.0
        ligne7?.layer.borderColor = UIColor.whiteColor().CGColor
        ligne7?.layer.borderWidth = 1.0
        ligne8?.layer.borderColor = UIColor.whiteColor().CGColor
        ligne8?.layer.borderWidth = 1.0
        
        let rads = degreesToRadians(device.angleTo(thing)) - degreesToRadians(device.angle())
        compass.angle = rads
    }
}