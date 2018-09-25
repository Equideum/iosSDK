//
//  Helpers.swift
//  DukeHealthiOSSDK
//
//  Created by Swathi on 12/09/18.
//  Copyright © 2018 Swathi. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func colorWithHex(string: String)  -> UIColor {
        
        var cString:String = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.clear
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

