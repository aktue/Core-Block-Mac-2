//
//  CoreBlockPiece.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/10.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Foundation

class CoreBlockPiece {
    
    static var shared: CoreBlockPiece = CoreBlockPiece()
    
    var x: Int = 0
    /// y is double, because gravity is decimal, it will be added each frame and take floor value
    var y: Double = 0
    /// real y in grid
    var floorY: Int { return Int(floor(self.y)) }
    var pos: Int = 0
    var tetro: [[Int]] = []
    var index: Int = Int.undefined
    var kickData: [[[Int]]] = []
    var lockDelay: Int = 0
    var shiftDelay: Int = 0
    var shiftDir: Int = 0
    var shiftReleased: Bool = false
    var arrDelay: Int = 0
    var held: Bool = false
    var finesse: Int = 0
    var dirty: Bool = false
    
    /**
     * Removes last active piece, and gets the next active piece from the grab bag.
     */
    func new(_ index: Int) {
        
        // TODO if no arguments, get next grabbag piece
        self.pos = 0
        self.held = false
        self.finesse = 0
        self.dirty = true
        
        //TODO change this
        CoreBlockData.landed = false
        
        // TODO Do this better. Make clone object func maybe.
        //for property in pieces, self.prop = piece.prop
        self.tetro = CoreBlockData.pieces[index].tetro
        self.kickData = CoreBlockData.pieces[index].kickData
        self.x = CoreBlockData.pieces[index].x
        self.y = Double(CoreBlockData.pieces[index].y)
        self.index = index
        
        // TODO ---------------- snip
        
        //TODO Do this better. (make grabbag object)
        // Preview.next() == grabbag.next()
        // Preview.draw()
        //preview.next()
        
        // Check for blockout.
        if (!self.moveValid(0, 0, self.tetro)) {
            CoreBlockData.gameState = 9
            CoreBlockController.message("BLOCK OUT!", .game)
//            menu(3)
        }
    }
}

extension CoreBlockPiece {
    
    func rotate(_ direction: Int) {
        
        // Rotates tetromino.
//        var rotated: [[Int]] = []
        var rotated: [[Int]] = Array(repeating: Array(repeating: 0, count: self.tetro.count), count: self.tetro.count)
        if (direction == -1) {
            for i in (0 ..< self.tetro.count).reversed() {
//                rotated[i] = []
                for row in (0 ..< self.tetro.count) {
                    rotated[i][self.tetro.count - 1 - row] = self.tetro[row][i]
                }
            }
        } else if (direction == 1) {
            for i in (0 ..< self.tetro.count) {
                //                rotated[i] = []
                for row in (0 ..< self.tetro.count).reversed() {
                    rotated[i][row] = self.tetro[row][self.tetro.count - 1 - i]
                }
            }
        } else {
            for i in (0 ..< self.tetro.count) {
                //                rotated[i] = []
                for row in (0 ..< self.tetro.count).reversed() {
                    rotated[i][row] = self.tetro[row][self.tetro.count - 1 - i]
                }
            }
            var rotated180: [[Int]] = Array(repeating: Array(repeating: 0, count: rotated.count), count: rotated.count)
            for i in (0 ..< rotated.count) {
                //                rotated180[i] = []
                for row in (0 ..< rotated.count).reversed() {
                    rotated180[i][row] = rotated[row][rotated.count - 1 - i]
                }
            }
            rotated = rotated180
        }
        
        // Goes thorugh kick data until it finds a valid move.
        let curPos = self.pos.mod(4)
        let newPos = (self.pos + direction).mod(4)
        
        for x in (0 ..< self.kickData[0].count) {
            if (
                self.moveValid(
                    self.kickData[curPos][x][0] - self.kickData[newPos][x][0],
                    self.kickData[curPos][x][1] - self.kickData[newPos][x][1],
                    rotated
                    )
                ) {
                self.x += self.kickData[curPos][x][0] - self.kickData[newPos][x][0]
                self.y += Double(self.kickData[curPos][x][1] - self.kickData[newPos][x][1])
                self.tetro = rotated
                self.pos = newPos
                // TODO make 180 rotate count as one or just update finess 180s
                //self.finesse += 1
                break
            }
        }
    }
    
    func checkShift() {
        // Shift key pressed event.
        if ((CoreBlockData.keysDown &  CoreBlockData.flags.moveLeft) > 0 && !((CoreBlockData.lastKeys &  CoreBlockData.flags.moveLeft) > 0)) {
            self.shiftDelay = 0
            self.arrDelay = 0
            self.shiftReleased = true
            self.shiftDir = -1
            self.finesse += 1
        } else if ((CoreBlockData.keysDown &  CoreBlockData.flags.moveRight) > 0 && !((CoreBlockData.lastKeys &  CoreBlockData.flags.moveRight) > 0)) {
            self.shiftDelay = 0
            self.arrDelay = 0
            self.shiftReleased = true
            self.shiftDir = 1
            self.finesse += 1
        }
        // Shift key released event.
        if (
            self.shiftDir == 1 &&
                !((CoreBlockData.keysDown &  CoreBlockData.flags.moveRight) > 0) &&
                (CoreBlockData.lastKeys &  CoreBlockData.flags.moveRight) > 0 &&
                (CoreBlockData.keysDown &  CoreBlockData.flags.moveLeft) > 0
            ) {
            self.shiftDelay = 0
            self.arrDelay = 0
            self.shiftReleased = true
            self.shiftDir = -1
        } else if (
            self.shiftDir == -1 &&
                !((CoreBlockData.keysDown &  CoreBlockData.flags.moveLeft) > 0) &&
                (CoreBlockData.lastKeys &  CoreBlockData.flags.moveLeft) > 0 &&
                (CoreBlockData.keysDown &  CoreBlockData.flags.moveRight) > 0
            ) {
            self.shiftDelay = 0
            self.arrDelay = 0
            self.shiftReleased = true
            self.shiftDir = 1
        } else if (
            !((CoreBlockData.keysDown &  CoreBlockData.flags.moveRight) > 0) &&
                (CoreBlockData.lastKeys &  CoreBlockData.flags.moveRight) > 0 &&
                (CoreBlockData.keysDown &  CoreBlockData.flags.moveLeft) > 0
            ) {
            self.shiftDir = -1
        } else if (
            !((CoreBlockData.keysDown &  CoreBlockData.flags.moveLeft) > 0) &&
                (CoreBlockData.lastKeys &  CoreBlockData.flags.moveLeft) > 0 &&
                (CoreBlockData.keysDown &  CoreBlockData.flags.moveRight) > 0
            ) {
            self.shiftDir = 1
        } else if (
            (!((CoreBlockData.keysDown &  CoreBlockData.flags.moveLeft) > 0) && (CoreBlockData.lastKeys &  CoreBlockData.flags.moveLeft) > 0) ||
                (!((CoreBlockData.keysDown &  CoreBlockData.flags.moveRight) > 0) && (CoreBlockData.lastKeys &  CoreBlockData.flags.moveRight) > 0)
            ) {
            self.shiftDelay = 0
            self.arrDelay = 0
            self.shiftReleased = true
            self.shiftDir = 0
        }
        // Handle events
        if (self.shiftDir != 0) {
            // 1. When key pressed instantly move over once.
            if (self.shiftReleased) {
                self.shift(self.shiftDir)
                self.shiftDelay += 1
                self.shiftReleased = false
                // 2. Apply DAS delay
            } else if (self.shiftDelay < CoreBlockData.settings.DAS) {
                self.shiftDelay += 1
                // 3. Once the delay is complete, move over once.
                //     Increment delay so this doesn't run again.
            } else if (self.shiftDelay == CoreBlockData.settings.DAS && CoreBlockData.settings.DAS != 0) {
                self.shift(self.shiftDir)
                if (CoreBlockData.settings.ARR != 0) {
                    self.shiftDelay += 1
                }
                // 4. Apply ARR delay
            } else if (self.arrDelay < CoreBlockData.settings.ARR) {
                self.arrDelay += 1
                // 5. If ARR Delay is full, move piece, and reset delay and repeat.
            } else if (self.arrDelay == CoreBlockData.settings.ARR && CoreBlockData.settings.ARR != 0) {
                self.shift(self.shiftDir)
            }
        }
    }
    
    func shift(_ direction: Int) {
        self.arrDelay = 0
        if (CoreBlockData.settings.ARR == 0 && self.shiftDelay == CoreBlockData.settings.DAS) {
            for i in (1 ..< 10) {
                if (!self.moveValid(i * direction, 0, self.tetro)) {
                    self.x += i * direction - direction
                    break
                }
            }
        } else if (self.moveValid(direction, 0, self.tetro)) {
            self.x += direction
        }
    }
    
    func shiftDown() {
        if (self.moveValid(0, 1, self.tetro)) {
            let grav = Double(CoreBlockData.settings.SoftDrop)
            if (grav > 1) {
                self.y += self.getDrop(grav)
            } else {
                self.y += grav
            }
        }
    }
    
    func hardDrop() {
        self.y += self.getDrop(Double.max)
        self.lockDelay = CoreBlockData.settings.LockDelay
    }
    
    func getDrop(_ distance: Double) -> Double {
        
        for i in (1 ... Int(distance)) {
            if (!self.moveValid(0, i, self.tetro)) {
                return Double(i - 1)
            }
        }
        return distance - 1
    }
    
    func hold() {
        
        var temp = CoreBlockHold.shared.piece
        if (!self.held) {
            if (CoreBlockHold.shared.piece != Int.undefined) {
                CoreBlockHold.shared.piece = self.index
                self.new(temp)
            } else {
                CoreBlockHold.shared.piece = self.index
                self.new(CoreBlockPreview.shared.next())
            }
            self.held = true
            CoreBlockHold.shared.draw()
        }
    }
    
    /**
     * Checks if position and orientation passed is valid.
     *  We call it for every action instead of only once a frame in case one
     *  of the actions is still valid, we don't want to block it.
     */
    func moveValid(_ cx: Int, _ cy: Int, _ tetro: [[Int]]) -> Bool {
        let cx = cx + self.x
        let cy = cy + self.floorY
        
        for x in (0 ..< tetro.count) {
            for y in (0 ..< tetro[x].count) {
                if (
                    tetro[x][y] > 0 &&
                        (cx + x < 0 ||
                            cx + x >= 10 ||
                            cy + y >= 22 ||
                            CoreBlockStack.shared.grid[cx + x][cy + y] > 0)
                    ) {
                    return false
                }
            }
        }
        self.lockDelay = 0
        return true
    }
    
    func update() {
        if (self.moveValid(0, 1, self.tetro)) {
            CoreBlockData.landed = false
            if (CoreBlockData.settings.Gravity > 0) {
                let grav = Double(CoreBlockData.settings.Gravity)
                if (grav > 1) {
                    self.y += self.getDrop(grav)
                } else {
                    self.y += grav
                }
            } else {
                self.y += CoreBlockData.gravity
            }
        } else {
            CoreBlockData.landed = true
            self.y = Double(self.floorY)
            if (self.lockDelay >= CoreBlockData.settings.LockDelay) {
                CoreBlockStack.shared.addPiece(self.tetro)
                self.new(CoreBlockPreview.shared.next())
            } else {
                // TODO: :? fe7w8lgt
//                var a = 1 / setting['Lock Delay'][CoreBlockData.settings['Lock Delay']]
//                activeCtx.globalCompositeOperation = 'source-atop'
//                activeCtx.fillStyle = 'rgba(0,0,0,' + a + ')'
//                activeCtx.fillRect(0, 0, activeCanvas.width, activeCanvas.height)
//                activeCtx.globalCompositeOperation = 'source-over'
                self.lockDelay += 1
            }
        }
    }
    
    func draw() {
        
        CoreBlockController.draw(
            CoreBlockController.DrawInfo(
                tetro: self.tetro,
                cx: self.x,
                cy: self.floorY,
                type: CoreBlockController.DrawType.active
        ))
    }
    
    func drawGhost() {
        if (!(CoreBlockData.settings.Ghost > 0) && !CoreBlockData.landed) {
            CoreBlockController.draw(
                CoreBlockController.DrawInfo(
                    tetro: self.tetro,
                    cx: self.x,
                    cy: self.floorY + Int(self.getDrop(Double.max)),
                    type: CoreBlockController.DrawType.ghost,
                    color: 0
            ))
        } else if (CoreBlockData.settings.Ghost == 1 && !CoreBlockData.landed) {
            CoreBlockController.draw(
                CoreBlockController.DrawInfo(
                    tetro: self.tetro,
                    cx: self.x,
                    cy: self.floorY + Int(self.getDrop(Double.max)),
                    type: CoreBlockController.DrawType.ghost
            ))
        } else {
            CoreBlockController.clear(CoreBlockController.DrawType.ghost)
        }
    }

}
