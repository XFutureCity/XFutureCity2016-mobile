//
//  Thing+Extensions.swift
//  Trilateral
//
//  Created by Simone Civetta on 02/04/16.
//  Copyright © 2016 Cisco. All rights reserved.
//

import Foundation
import Flare

enum ThingDataType {
    case Unknown
    case GetAround
    case See
    case Buy
    case Eat
    
    var cellIdentifier: String {
        switch self {
        case .Unknown:
            return "Cell"
        case See:
            return "CellSee"
        case Buy:
            return "CellBuy"
        case .Eat:
            return "CellEat"
        case .GetAround:
            return "CellGetAround"
        }
    }
}

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
    
    var dataType: ThingDataType {
        guard let type = self.data["type"] as? String else {
            return .Unknown
        }
        
        switch type.lowercaseString {
        case "eat":
            return .Eat
        case "see":
            return .See
        case "getaround":
            return .GetAround
        case "buy":
            return .Buy
            
        default:
            return .Unknown
        }
    }
}