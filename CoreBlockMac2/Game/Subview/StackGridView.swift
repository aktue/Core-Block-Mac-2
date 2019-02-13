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
        let cellWidth: CGFloat = GameManager.shared.cgFloatValue(forKey: "MinoSize", defaultValue: 24.0)
        /// 外部边框 粗线宽度
        let lineWidth1: CGFloat = 2// cellWidth / 8
        /// 内部边框 细线宽度
        let lineWidth2: CGFloat = 1// lineWidth1 / 2
        /// 内部边框 短细线长度
        let lineHeight2: CGFloat = cellWidth / 2
        
        /// 内部 横细线
        NSColor.cbm_gray_875.set()
        for i in (1 ... 19) {
            NSRect(x: 0, y: CGFloat(i) * cellWidth, width: width, height: lineWidth2).fill()
        }
        for i in (1 ... 9) {
            NSRect(x: CGFloat(i) * cellWidth, y: 0, width: lineWidth2, height: height).fill()
        }
        
        /// 内部 短细线
        NSColor.cbm_gray_750.set()
        for y in (1 ... 19) {
            for x in (1 ... 9) {
                NSRect(x: CGFloat(x) * cellWidth - (lineHeight2 / 2), y: CGFloat(y) * cellWidth, width: lineHeight2, height: lineWidth2).fill()
                NSRect(x: CGFloat(x) * cellWidth, y: CGFloat(y) * cellWidth - (lineHeight2 / 2), width: lineWidth2, height: lineHeight2).fill()
            }
        }
        
        /// 外部 粗线
        NSColor.cbm_gray_500.set()
        NSRect(x: 0, y: 0, width: width, height: lineWidth1).fill()
        NSRect(x: 0, y: 0, width: lineWidth1, height: height).fill()
        NSRect(x: width - lineWidth1, y: 0, width: lineWidth1, height: height).fill()
        NSRect(x: 0, y: height - lineWidth1, width: width, height: lineWidth1).fill()
    }
    
}
