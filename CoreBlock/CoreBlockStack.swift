//
//  CoreBlockStack.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/11.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Foundation

class CoreBlockStack {
    
    static var shared: CoreBlockStack = CoreBlockStack()
    
    var grid: [[Int]] = []
    
    /**
     * Creates a matrix for the playfield.
     */
    func new(_ x: Int, _ y: Int) {
        self.grid = Array(repeating: Array(repeating: 0, count: y), count: x)
    }
}

extension CoreBlockStack {
    
    /**
     * Check if finesse fault
     */
    func hasFinesseFault(_ tetro: [[Int]]) -> Bool {
        var once = false
        
        for x in (0 ..< tetro.count) {
            for y in (0 ..< tetro[x].count) {
                if (tetro[x][y] > 0) {
                    // Get column for finesse
                    if (!once || x + CoreBlockPiece.shared.x < CoreBlockData.column) {
                        CoreBlockData.column = x + CoreBlockPiece.shared.x
                        once = true
                    }
                }
            }
        }
        
        if CoreBlockPiece.shared.finesse > CoreBlockData.finesse[CoreBlockPiece.shared.index][CoreBlockPiece.shared.pos][CoreBlockData.column] {
            
            CoreBlockData.statsFinesse += CoreBlockPiece.shared.finesse - CoreBlockData.finesse[CoreBlockPiece.shared.index][CoreBlockPiece.shared.pos][CoreBlockData.column]
            CoreBlockController.message(CoreBlockData.statsFinesse, .finesse)
            
            return true
        }
        return false
    }
    
    /**
     * Adds tetro to the stack, and clears lines if they fill up.
     */
    func addPiece(_ tetro: [[Int]]) {
        var once = false
        
        // Add the piece to the stack.
        var range: [Int] = []
        var valid = false
        for x in (0 ..< tetro.count) {
            for y in (0 ..< tetro[x].count) {
                if (tetro[x][y] > 0) {
                    self.grid[x + CoreBlockPiece.shared.x][y + CoreBlockPiece.shared.floorY] = tetro[x][y]
                    // Get column for finesse
                    if (!once || x + CoreBlockPiece.shared.x < CoreBlockData.column) {
                        CoreBlockData.column = x + CoreBlockPiece.shared.x
                        once = true
                    }
                    // Check which lines get modified
                    if (!range.contains(y + CoreBlockPiece.shared.floorY)) {
                        range.append(y + CoreBlockPiece.shared.floorY)
                        // This checks if any cell is in the play field. If there
                        //  isn't any this is called a lock out and the game ends.
                        if (Double(y) + CoreBlockPiece.shared.y > 1) {
                            valid = true
                        }
                    }
                }
            }
        }
        
        // Lock out
        if (!valid) {
            CoreBlockData.gameState = 9
            CoreBlockController.message("LOCK OUT!", .game)
//            menu(3)
            return
        }
        
        // Check modified lines for full lines.
        range.sort { (a: Int, b: Int) -> Bool in
            return b - a >= 0
        }
        
        for row in (range[0] ..< range[0] + range.count) {
            var count = 0
            for x in (0 ..< 10) {
                if (self.grid[x][row] > 0) {
                    count += 1
                }
            }
            // Clear the line. This basically just moves down the stack.
            // TODO Ponder during the day and see if there is a more elegant solution.
            if (count == 10) {
                CoreBlockData.lines += 1 // NOTE stats
                if (CoreBlockData.gameType == 3) {
                    if (CoreBlockData.digLines[row] != -1) {
                        CoreBlockData.digLines.remove(at: CoreBlockData.digLines[row])
                    }
                }
                for y in (1 ... row).reversed() {
                    for x in (0 ..< 10) {
                        self.grid[x][y] = self.grid[x][y - 1]
                    }
                }
            }
        }
        
        if CoreBlockPiece.shared.finesse > CoreBlockData.finesse[CoreBlockPiece.shared.index][CoreBlockPiece.shared.pos][CoreBlockData.column] {
            
            CoreBlockData.statsFinesse += CoreBlockPiece.shared.finesse - CoreBlockData.finesse[CoreBlockPiece.shared.index][CoreBlockPiece.shared.pos][CoreBlockData.column]
            CoreBlockController.message(CoreBlockData.statsFinesse, .finesse)
        }
        
        CoreBlockData.piecesSet += 1 // NOTE Stats
        
        CoreBlockController.message(CoreBlockData.piecesSet, .statsPiece)
        
        let kpp: Double = CoreBlockData.keyPressCount > 0 ? Double(CoreBlockData.keyPressCount) / Double(CoreBlockData.piecesSet) : 0
        CoreBlockController.message(String(format: "%.2f", kpp), .kpp)
        
        if (CoreBlockData.gameType != 3) {
            CoreBlockController.message(CoreBlockData.lineLimit - CoreBlockData.lines, .statsLines)
        } else {
            CoreBlockController.message(CoreBlockData.digLines.count, .statsLines)
        }
        
        self.draw()
    }
    
    /**
     * Draws the stack.
     */
    func draw() {
        CoreBlockController.draw(
            CoreBlockController.DrawInfo(
                tetro: self.grid,
                cx: 0,
                cy: 0,
                type: CoreBlockController.DrawType.stack
        ))
    }
}
