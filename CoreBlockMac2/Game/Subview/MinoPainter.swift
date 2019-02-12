//
//  MinoPainter.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/11.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Cocoa


extension Int {
    var color: NSColor {
        let red = CGFloat((self & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((self & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((self & 0xFF)) / 255.0
        return NSColor(calibratedRed: red, green: green, blue: blue, alpha: 1.0)
    }
}


class MinoPainter {
    
    static var shared: MinoPainter = MinoPainter()
    
    var minoImage: NSImage!
    
    init() {
        let solid: [[NSColor]] = [
            // 0         +10        -10        -20
            [0xc1c1c1.color, 0xdddddd.color, 0xa6a6a6.color, 0x8b8b8b.color],
            /// I 0x009bd6
            [0x0f9bd7.color, 0x4cd7b6.color, 0x009f81.color, 0x008568.color],
            /// J 0x1d3bc4
            [0x2141c6.color, 0x57b1f6.color, 0x007dbd.color, 0x0064a2.color],
            /// L 0xe55711
            [0xe35b02.color, 0xff993f.color, 0xc86400.color, 0xa94b00.color],
            /// O 0xe59f18
            [0xe39f02.color, 0xffdf3a.color, 0xd1a800.color, 0xb38e00.color],
            /// S 0x56b414
            [0x59b101.color, 0xb9e955.color, 0x81b214.color, 0x659700.color],
            /// T 0xb11b89
            [0xaf298a.color, 0xb873d4.color, 0x81409d.color, 0x672782.color],
            /// Z 0xd90039
            [0xd70f37.color, 0xff6853.color, 0xc62c25.color, 0xa70010.color],
            [0x898989.color, 0xa3a3a3.color, 0x6f6f6f.color, 0x575757.color],
            [0xc1c1c1.color, 0xdddddd.color, 0xa6a6a6.color, 0x8b8b8b.color],
        ]
        
        let cellSize: Int = GameManager.shared.value(forKey: "CellSize", defaultValue: 24)
        let spriteCanvasHeight: Int = cellSize
        let spriteCanvasWidth: Int = spriteCanvasHeight * 10
        
        let image: NSImage = NSImage(size: NSSize(width: spriteCanvasWidth, height: spriteCanvasHeight))
        image.lockFocus()
        
        for i in (0 ..< 10) {
            
            let x = i * cellSize
            let color: NSColor = solid[i][0]
            color.set()
            NSRect(x: x, y: 0, width: cellSize, height: cellSize).fill()
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
        
        let cellSize: Int = GameManager.shared.value(forKey: "CellSize", defaultValue: 24)
        let x = x * cellSize
        let y = (y - 2) * cellSize
        
        self.minoImage.draw(in: NSRect(x: x, y: y, width: cellSize, height: cellSize), from: NSRect(x: color * cellSize, y: 0, width: cellSize, height: cellSize), operation: NSCompositingOperation.copy, fraction: 1)
    }
}
