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
    
    private weak var overlayCursor: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(named: "compass.png")
        let renderedImage = image?.imageWithRenderingMode(.AlwaysTemplate)
        compass.image = renderedImage
        let overlay = UIImageView(image: UIImage(named: "compass-cursor@2x.png"))
        overlay.contentMode = .ScaleToFill
        overlay.frame = compass.bounds
        overlayCursor = overlay
        compass.addSubview(overlay)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let overlayCursor = overlayCursor {
            overlayCursor.frame = compass.bounds
        }
    }
    
    func update(thing: Thing, device: Device) {
        nameLabel.text = thing.name
        cardContainer.backgroundColor = thing.uiColor
        nameLabel.textColor = thing.uiColor == UIColor.whiteColor() ? .blackColor() : .whiteColor()
        subnameLabel.textColor = nameLabel.textColor
        compass.tintColor = thing.uiColor
        let rads = degreesToRadians(device.angleTo(thing)) - degreesToRadians(device.angle())
        compass.angle = rads
    }
}