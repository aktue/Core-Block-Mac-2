//
//  MinoPainter.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/11.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Cocoa


class MinoPainter {
    
    static var shared: MinoPainter = MinoPainter()
    
    var minoImage: NSImage!
    var ghostMinoImage: NSImage!
    
    init() {
        let solidColorArray: [NSColor] = [
            // 0
            0xc1c1c1.cbm_color,
            /// I 0x009bd6
            0x0f9bd7.cbm_color,
            /// J 0x1d3bc4
            0x2141c6.cbm_color,
            /// L 0xe55711
            0xe35b02.cbm_color,
            /// O 0xe59f18
            0xe39f02.cbm_color,
            /// S 0x56b414
            0x59b101.cbm_color,
            /// T 0xb11b89
            0xaf298a.cbm_color,
            /// Z 0xd90039
            0xd70f37.cbm_color,
            0x898989.cbm_color,
            0xc1c1c1.cbm_color,
        ]
        
        let minoSize: Int = GameSetting.shared.minoSize
        let spriteCanvasHeight: Int = minoSize
        let spriteCanvasWidth: Int = spriteCanvasHeight * solidColorArray.count
        
        // init default mino images
        do {
            let image: NSImage = NSImage(size: NSSize(width: spriteCanvasWidth, height: spriteCanvasHeight))
            image.lockFocus()
            
            // draw pure color
            for i in (0 ..< solidColorArray.count) {
                
                let x = i * minoSize
                let color: NSColor = solidColorArray[i]
                color.set()
                NSRect(x: x, y: 0, width: minoSize, height: minoSize).fill()
            }
            
            // load local skin image if exist
            for i in (0 ..< solidColorArray.count) {
                
                let x = i * minoSize
                if let image = NSImage(named: "mino_" + "\(i)") {
                    image.rotated(by: 90).draw(in: NSRect(x: x, y: 0, width: minoSize, height: minoSize), from: NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height), operation: NSCompositingOperation.copy, fraction: 1)
                }
            }
            
            image.unlockFocus()
            self.minoImage = image
        }
        
        // init ghost mino images
        do {
            let image: NSImage = NSImage(size: NSSize(width: spriteCanvasWidth, height: spriteCanvasHeight))
            image.lockFocus()
            
            // draw pure color
            for i in (0 ..< solidColorArray.count) {
                
                let x = i * minoSize
                let color: NSColor = solidColorArray[i]
                color.set()
                NSRect(x: x, y: 0, width: minoSize, height: minoSize).fill()
            }
            
            // load local skin image if exist
            for i in (0 ..< solidColorArray.count) {
                
                let x = i * minoSize
                if let image = NSImage(named: "mino_" + "\(i)") {
                    image.rotated(by: 90).dimmed(alpha: 0.5).draw(in: NSRect(x: x, y: 0, width: minoSize, height: minoSize), from: NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height), operation: NSCompositingOperation.copy, fraction: 1)
                }
            }
            
            image.unlockFocus()
            self.ghostMinoImage = image
        }
    }
}

extension MinoPainter {
    
    /**
     * Draws a 2d array of minos.
     */
    func draw(info: CoreBlockController.DrawInfo) {
        
        let tetro: [[Int]] = info.tetro
        let cx: Int = info.cx
        let cy: Int = info.cy
        let color: Int = info.color
        
        for x in (0 ..< tetro.count) {
            for y in (0 ..< tetro[x].count) {
                if tetro[x][y] > 0 {
                    self.drawCell(x: x + cx, y: y + cy, color: color != Int.undefined ? color : tetro[x][y], type: info.type)
                }
            }
        }
    }
    
    /**
     * Draws a pre-rendered mino.
     */
    func drawCell(x: Int, y: Int, color: Int, type: CoreBlockController.DrawType) {
        
        let minoSize: Int = GameSetting.shared.minoSize
        let x = x * minoSize
        let y = (y - 2) * minoSize
        
        if type == CoreBlockController.DrawType.ghost {
            self.ghostMinoImage.draw(in: NSRect(x: x, y: y, width: minoSize, height: minoSize), from: NSRect(x: color * minoSize, y: 0, width: minoSize, height: minoSize), operation: NSCompositingOperation.copy, fraction: 1)
        } else {
            self.minoImage.draw(in: NSRect(x: x, y: y, width: minoSize, height: minoSize), from: NSRect(x: color * minoSize, y: 0, width: minoSize, height: minoSize), operation: NSCompositingOperation.copy, fraction: 1)
        }
    }
}
