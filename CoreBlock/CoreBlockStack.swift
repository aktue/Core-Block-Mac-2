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
                    self.grid[x + CoreBlockPiece.shared.x][y + Int(CoreBlockPiece.shared.y)] = tetro[x][y]
                    // Get column for finesse
                    if (!once || x + CoreBlockPiece.shared.x < column) {
                        column = x + CoreBlockPiece.shared.x
                        once = true
                    }
                    // Check which lines get modified
                    if (range[y + Int(CoreBlockPiece.shared.y)] == -1) {
                        range.append(y + Int(CoreBlockPiece.shared.y))
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
            gameState = 9
            CoreBlockMessage.game("LOCK OUT!")
            menu(3)
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
                lines += 1 // NOTE stats
                if (gametype == 3) {
                    if (digLines[row] != -1) {
                        digLines.remove(at: digLines[row])
                    }
                }
                for y in (-1 ... row).reversed() {
                    for x in (0 ..< 10) {
                        self.grid[x][y] = self.grid[x][y - 1]
                    }
                }
            }
        }
        
        statsFinesse += CoreBlockPiece.shared.finesse - finesse[CoreBlockPiece.shared.index][CoreBlockPiece.shared.pos][column]
        piecesSet += 1 // NOTE Stats
        // TODO Might not need this (same for in init)
        column = 0
        
        CoreBlockMessage.statsPiece(piecesSet)
        
        if (gametype != 3) {
            CoreBlockMessage.statsLines(lineLimit - lines)
        } else {
            CoreBlockMessage.statsLines(digLines.count)
        }
        
        self.draw()
    }
    
    /**
     * Draws the stack.
     */
    func draw() {
        CoreBlockController.draw(self.grid, 0, 0, CoreBlockController.DrawType.stack)
    }
}
