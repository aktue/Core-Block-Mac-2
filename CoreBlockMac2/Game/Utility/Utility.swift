//
//  Utility.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/12.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Cocoa

extension NSColor {
    
    /// background
    static var cbm_gray_125: NSColor { return 0xcccccc.color }
    /// background
    static var cbm_gray_250: NSColor { return 0x999999.color }
    /// stackBackView border
    static var cbm_gray_500: NSColor { return 0x393939.color }
    /// stackBackView line 1
    static var cbm_gray_750: NSColor { return 0x2c2c2c.color }
    /// stackBackView line 2
    static var cbm_gray_875: NSColor { return 0x1c1c1c.color }
    
    /// clear
    static var cbm_clear: NSColor { return NSColor.clear }
    
    /// black
    static var cbm_black_500: NSColor { return NSColor.black }
    
    /// white
    static var cbm_white_500: NSColor { return NSColor.white }
}


extension Int {
    
    var color: NSColor {
        let red = CGFloat((self & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((self & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((self & 0xFF)) / 255.0
        return NSColor(calibratedRed: red, green: green, blue: blue, alpha: 1.0)
    }
}
