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
    
    init() {
        let solidColorArray: [NSColor] = [
            // 0
            0xc1c1c1.color,
            /// I 0x009bd6
            0x0f9bd7.color,
            /// J 0x1d3bc4
            0x2141c6.color,
            /// L 0xe55711
            0xe35b02.color,
            /// O 0xe59f18
            0xe39f02.color,
            /// S 0x56b414
            0x59b101.color,
            /// T 0xb11b89
            0xaf298a.color,
            /// Z 0xd90039
            0xd70f37.color,
            0x898989.color,
            0xc1c1c1.color,
        ]
        
        let minoSize: Int = GameSetting.shared.minoSize
        let spriteCanvasHeight: Int = minoSize
        let spriteCanvasWidth: Int = spriteCanvasHeight * solidColorArray.count
        
        let image: NSImage = NSImage(size: NSSize(width: spriteCanvasWidth, height: spriteCanvasHeight))
        image.lockFocus()
        
        for i in (0 ..< solidColorArray.count) {
            
            let x = i * minoSize
            let color: NSColor = solidColorArray[i]
            color.set()
            NSRect(x: x, y: 0, width: minoSize, height: minoSize).fill()
        }
        
        image.unlockFocus()
        self.minoImage = image
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
                    self.drawCell(x: x + cx, y: y + cy, color: color != Int.undefined ? color : tetro[x][y])
                }
            }
        }
    }
    
    /**
     * Draws a pre-rendered mino.
     */
    func drawCell(x: Int, y: Int, color: Int) {
        
        let minoSize: Int = GameSetting.shared.minoSize
        let x = x * minoSize
        let y = (y - 2) * minoSize
        
        self.minoImage.draw(in: NSRect(x: x, y: y, width: minoSize, height: minoSize), from: NSRect(x: color * minoSize, y: 0, width: minoSize, height: minoSize), operation: NSCompositingOperation.copy, fraction: 1)
    }
}
