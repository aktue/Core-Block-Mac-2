//
//  BaseMinoView.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/12.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Cocoa

class BaseMinoView: NSView {
    
    var drawInfo: CoreBlockController.DrawInfo?
    
    override var isFlipped: Bool {
        return true
    }
    
    func draw(drawInfo: CoreBlockController.DrawInfo?) {
        self.drawInfo = drawInfo
        DispatchQueue.main.async {
            self.needsDisplay = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
        
        if let drawInfo = self.drawInfo {
            MinoPainter.shared.draw(info: drawInfo)
        }
    }
    
}
