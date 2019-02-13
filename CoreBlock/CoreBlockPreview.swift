//
//  CoreBlockPreview.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/11.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Foundation

class CoreBlockPreview {
    
    static var shared: CoreBlockPreview = CoreBlockPreview()
    
    var grabBag: [Int] = []
    
    func new() {
        //XXX fix ugly code lolwut
        while (true) {
            self.grabBag = self.gen()
            if ([3, 4, 6].index(of: self.grabBag[0]) == nil) {
                break
            }
        }
        self.grabBag.append(contentsOf: self.gen())
        self.draw()
    }
}

extension CoreBlockPreview {
    
    func next() -> Int {
        let next = self.grabBag.remove(at: 0)
        if (self.grabBag.count == 7) {
            self.grabBag.append(contentsOf: self.gen())
        }
        self.draw()
        return next
        //TODO Maybe return the next piece?
    }
    
    /**
     * Creates a "grab bag" of the 7 tetrominos.
     */
    func gen() -> [Int] {
        let pieceList = [0, 1, 2, 3, 4, 5, 6]
        return pieceList.sorted(by: { (_, _) -> Bool in
            return 0.5 - CoreBlockRng.shared.next() > 0
        })
    }
    
    /**
     * Draws the piece preview.
     */
    func draw() {
        
        var drawInfoArray: [CoreBlockController.DrawInfo] = []
        for i in (0 ..< 6) {
            drawInfoArray.append(
                CoreBlockController.DrawInfo(
                    tetro: CoreBlockData.pieces[self.grabBag[i]].tetro,
                    cx: CoreBlockData.pieces[self.grabBag[i]].x - 3,
                    cy: CoreBlockData.pieces[self.grabBag[i]].y + 2 + i * 3,
                    type: CoreBlockController.DrawType.preview
            ))
        }
        CoreBlockController.draw(drawInfoArray)
    }
}
