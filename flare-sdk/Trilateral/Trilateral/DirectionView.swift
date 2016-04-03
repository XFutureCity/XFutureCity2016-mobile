//
//  DirectionView.swift
//  Trilateral
//
//  Created by Simone Civetta on 03/04/16.
//  Copyright © 2016 Cisco. All rights reserved.
//

import Foundation
import UIKit



func radiansToDegrees(angle: Double) -> Double {
    return angle * 180.0 / M_PI
}

class DirectionView : UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessibilityHint = "Your position from this place"
    }
    
    func setPosition(angle: Double, distance: Double) {
        self.transform = CGAffineTransformMakeRotation(CGFloat(angle));
        self.setupAccessibility(angle, distance: distance)
        self.isAccessibilityElement = true
        self.accessibilityTraits = UIAccessibilityTraitStaticText
    }
    
    private func setupAccessibility(angle: Double, distance: Double) {
        let degrees = radiansToDegrees(angle)
        let degreesNormalized = degrees < 0 ? 360 + degrees : degrees
        var accessibilityLabel = ""
        switch degreesNormalized {
        case 45..<135:
            accessibilityLabel += "On your right"
            
        case 135..<225:
            accessibilityLabel += "Behind you"
            
        case 225..<315:
            accessibilityLabel += "On your left"
            
        default:
            accessibilityLabel += "In front of you"
        }
        
        accessibilityLabel += ", at " + (NSString(format: "%.1f meters", distance) as String)
        self.accessibilityLabel = accessibilityLabel
    }
}