//
//  StackGridView.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/12.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Cocoa

class StackGridView: NSView {
    
    override var isFlipped: Bool {
        return true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        
        let width: CGFloat = self.bounds.size.width
        let height: CGFloat = self.bounds.size.height
        let cellWidth: CGFloat = GameSetting.shared.cgFloatValue(forKey: "MinoSize", defaultValue: 24.0)
        
        let outerLineWidth: CGFloat = 2 // cellWidth / 8
        let innerLineWidth: CGFloat = 1 // outerLineWidth / 2
        let innerShortLineLength: CGFloat = cellWidth / 2
        
        /// inner line
        NSColor.cbm_gray_875.set()
        for i in (1 ... 19) {
            NSRect(x: 0, y: CGFloat(i) * cellWidth, width: width, height: innerLineWidth).fill()
        }
        for i in (1 ... 9) {
            NSRect(x: CGFloat(i) * cellWidth, y: 0, width: innerLineWidth, height: height).fill()
        }
        
        /// inner short line
        NSColor.cbm_gray_750.set()
        for y in (1 ... 19) {
            for x in (1 ... 9) {
                NSRect(x: CGFloat(x) * cellWidth - (innerShortLineLength / 2), y: CGFloat(y) * cellWidth, width: innerShortLineLength, height: innerLineWidth).fill()
                NSRect(x: CGFloat(x) * cellWidth, y: CGFloat(y) * cellWidth - (innerShortLineLength / 2), width: innerLineWidth, height: innerShortLineLength).fill()
            }
        }
        
        /// outer line
        NSColor.cbm_gray_500.set()
        NSRect(x: 0, y: 0, width: width, height: outerLineWidth).fill()
        NSRect(x: 0, y: 0, width: outerLineWidth, height: height).fill()
        NSRect(x: width - outerLineWidth, y: 0, width: outerLineWidth, height: height).fill()
        NSRect(x: 0, y: height - outerLineWidth, width: width, height: outerLineWidth).fill()
    }
    
}
