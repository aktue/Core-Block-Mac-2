//
//  NextView.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/12.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Cocoa

class NextView: NSView {
    
    var drawInfoArray: [CoreBlockController.DrawInfo]?
    
    override var isFlipped: Bool {
        return true
    }
    
    func draw(drawInfoArray: [CoreBlockController.DrawInfo]?) {
        self.drawInfoArray = drawInfoArray
        DispatchQueue.main.async {
            self.needsDisplay = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
        
        if let drawInfoArray = self.drawInfoArray {
            for drawInfo in drawInfoArray {
                MinoPainter.shared.draw(info: drawInfo)
            }
        }
    }
    
}
