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
    @IBOutlet weak var distanceLabel: UILabel!
    
    // Optionals
    @IBOutlet weak var ligne3: UILabel?
    @IBOutlet weak var ligne7: UILabel?
    @IBOutlet weak var ligne8: UILabel?
    
    private weak var overlayCursor: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(named: "compass.png")
        let renderedImage = image?.imageWithRenderingMode(.AlwaysTemplate)
        compass.image = renderedImage
        let overlay = UIImageView(image: UIImage(named: "compass-cursor@2x.png"))
        overlay.contentMode = .ScaleToFill
        overlay.frame = compass.bounds
        overlay.isAccessibilityElement = false
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
        let distance = device.distanceTo(thing)
        distanceLabel.text = NSString(format: "%.1f meters", distance) as String
        
        nameLabel.text = thing.name
        cardContainer.backgroundColor = thing.uiColor
        nameLabel.textColor = thing.uiColor == UIColor.whiteColor() ? .blackColor() : .whiteColor()
        subnameLabel.textColor = nameLabel.textColor
        compass.tintColor = thing.uiColor
        
        let rads = degreesToRadians(device.angleTo(thing)) - degreesToRadians(device.angle())
        compass.setPosition(rads, distance: distance)
        
        self.setupLines()
        self.setupAccessibility(thing)
    }
    
    private func setupLines() {
        ligne3?.layer.borderColor = UIColor.whiteColor().CGColor
        ligne3?.layer.borderWidth = 1.0
        ligne7?.layer.borderColor = UIColor.whiteColor().CGColor
        ligne7?.layer.borderWidth = 1.0
        ligne8?.layer.borderColor = UIColor.whiteColor().CGColor
        ligne8?.layer.borderWidth = 1.0
    }
    
    private func setupAccessibility(thing: Thing) {
        var accessibilityLabel = thing.name + " (Things to \(thing.dataType)). "
        if let compassAccesibilityLabel = compass.accessibilityLabel {
            accessibilityLabel += compassAccesibilityLabel + "."
        }
        
        nameLabel.accessibilityLabel = accessibilityLabel
    }
}