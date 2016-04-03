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
    
    var angle: Double = 0.0 {
        didSet(value) {
            self.transform = CGAffineTransformMakeRotation(CGFloat(value));
            self.applyAccessibilityLabel()
            self.isAccessibilityElement = true
            self.accessibilityTraits = UIAccessibilityTraitStaticText
        }
    }
    
    private func applyAccessibilityLabel() {
        let degrees = radiansToDegrees(angle)
        let degreesNormalized = degrees < 0 ? 360 + degrees : degrees
        switch degreesNormalized {
        case 45..<135:
            self.accessibilityLabel = "Right"
            
        case 135..<225:
            self.accessibilityLabel = "Behind"
            
        case 225..<315:
            self.accessibilityLabel = "Left"
            
        default:
            self.accessibilityLabel = "Ahead"
        }
    }
}