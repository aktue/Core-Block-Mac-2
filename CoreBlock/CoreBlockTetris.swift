//
//  CoreBlockTetris.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/10.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

/*
 README:
 
 how to use this CoreBlock?
 
 - implement CoreBlockControllerProtocol, to show game view or message.
   - tetro.y should -2 when you draw it (because the grid size is 10 x 22).
 
 - set CoreBlockData.settings
 - set CoreBlockData.binds
 - call CoreBlock.shared.new(gameType gt: Int)
 - call CoreBlock.shared.pressKey(down: Bool, keyCode: Int)
 
 var
 
 */

import Foundation


// MARK: - data

class CoreBlockData {
    
    /**
     * Playfield.
     */
    static var column: Int = 0
    
    /**
     * Piece data
     */
    
    // NOTE y values are inverted since our matrix counts from top to bottom.
    static var kickData: [[[Int]]] = [
        [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0]],
        [[0, 0], [1, 0], [1, 1], [0, -2], [1, -2]],
        [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0]],
        [[0, 0], [-1, 0], [-1, 1], [0, -2], [-1, -2]],
        ]
    static var kickDataI: [[[Int]]] = [
        [[0, 0], [-1, 0], [2, 0], [-1, 0], [2, 0]],
        [[-1, 0], [0, 0], [0, 0], [0, -1], [0, 2]],
        [[-1, -1], [1, -1], [-2, -1], [1, 0], [-2, 0]],
        [[0, -1], [0, -1], [0, -1], [0, 1], [0, -2]],
        ]
    // TODO get rid of this lol.
    static var kickDataO: [[[Int]]] = [[[0, 0]], [[0, 0]], [[0, 0]], [[0, 0]]]
    
    // Define shapes and spawns.
    static var PieceI = (
        index: 0,
        x: 2,
        y: -1,
        kickData: kickDataI,
        tetro: [
            [0, 0, 0, 0, 0],
            [0, 0, 1, 0, 0],
            [0, 0, 1, 0, 0],
            [0, 0, 1, 0, 0],
            [0, 0, 1, 0, 0],
            ]
    )
    static var PieceJ = (
        index: 1,
        x: 3,
        y: 0,
        kickData: kickData,
        tetro: [[2, 2, 0], [0, 2, 0], [0, 2, 0]]
    )
    static var PieceL = (
        index: 2,
        x: 3,
        y: 0,
        kickData: kickData,
        tetro: [[0, 3, 0], [0, 3, 0], [3, 3, 0]]
    )
    static var PieceO = (
        index: 3,
        x: 4,
        y: 0,
        kickData: kickDataO,
        tetro: [[4, 4], [4, 4]]
    )
    static var PieceS = (
        index: 4,
        x: 3,
        y: 0,
        kickData: kickData,
        tetro: [[0, 5, 0], [5, 5, 0], [5, 0, 0]]
    )
    static var PieceT = (
        index: 5,
        x: 3,
        y: 0,
        kickData: kickData,
        tetro: [[0, 6, 0], [6, 6, 0], [0, 6, 0]]
    )
    static var PieceZ = (
        index: 6,
        x: 3,
        y: 0,
        kickData: kickData,
        tetro: [[7, 0, 0], [7, 7, 0], [0, 7, 0]]
    )
    static var pieces = [PieceI, PieceJ, PieceL, PieceO, PieceS, PieceT, PieceZ]
    
    // Finesse data
    // index x orientatio x CoreBlockData.column = finesse
    // finesse[0][0][4] = 1
    // TODO double check these.
    static var finesse: [[[Int]]] = [
        [
            [1, 2, 1, 0, 1, 2, 1],
            [2, 2, 2, 2, 1, 1, 2, 2, 2, 2],
            [1, 2, 1, 0, 1, 2, 1],
            [2, 2, 2, 2, 1, 1, 2, 2, 2, 2],
            ],
        [
            [1, 2, 1, 0, 1, 2, 2, 1],
            [2, 2, 3, 2, 1, 2, 3, 3, 2],
            [3, 4, 3, 2, 3, 4, 4, 3],
            [2, 3, 2, 1, 2, 3, 3, 2, 2],
            ],
        [
            [1, 2, 1, 0, 1, 2, 2, 1],
            [2, 2, 3, 2, 1, 2, 3, 3, 2],
            [3, 4, 3, 2, 3, 4, 4, 3],
            [2, 3, 2, 1, 2, 3, 3, 2, 2],
            ],
        [
            [1, 2, 2, 1, 0, 1, 2, 2, 1],
            [1, 2, 2, 1, 0, 1, 2, 2, 1],
            [1, 2, 2, 1, 0, 1, 2, 2, 1],
            [1, 2, 2, 1, 0, 1, 2, 2, 1],
            ],
        [
            [1, 2, 1, 0, 1, 2, 2, 1],
            [2, 2, 2, 1, 1, 2, 3, 2, 2],
            [1, 2, 1, 0, 1, 2, 2, 1],
            [2, 2, 2, 1, 1, 2, 3, 2, 2],
            ],
        [
            [1, 2, 1, 0, 1, 2, 2, 1],
            [2, 2, 3, 2, 1, 2, 3, 3, 2],
            [3, 4, 3, 2, 3, 4, 4, 3],
            [2, 3, 2, 1, 2, 3, 3, 2, 2],
            ],
        [
            [1, 2, 1, 0, 1, 2, 2, 1],
            [2, 2, 2, 1, 1, 2, 3, 2, 2],
            [1, 2, 1, 0, 1, 2, 2, 1],
            [2, 2, 2, 1, 1, 2, 3, 2, 2],
            ],
        ]
    
    /**
     * Gameplay specific vars.
     */
    /// default gravity
    static var gravity: Double = 1.0 / 64
    
    static var settings = (
        DAS: 6,
        ARR: 0,
        Gravity: 0.0156,
        SoftDrop: 200.0,
        LockDelay: 30,
        Ghost: 1,
        FinesseFaultRepeat: 10
    )
    
    /// after finesse fault, this will > 0, place a piece and -1
    static var finesseFaultRepeat = 0
    
    /// total frames
    static var frame = 0
    
    /**
     *Pausing variables
     */
    
    static var startPauseTime = 0
    static var pauseTime = 0
    
    /**
     * 0 = normal
     * 1 = win
     * 2 = countdown
     * 3 = game not played
     * 9 = loss
     */
    static var gameState = 3
    
    static var paused = false
    /// while sprint, this is 40
    static var lineLimit = 0
    
    /*
     -1 : seed
     x : frame
     */
    static var replayKeys: [Int: Int] = [:]
    static var watchingReplay = false
    
    /*
     -1: Replay
     0 : Sprint 40
     1 : Sprint 1000
     3 : Dig race
     */
    static var gameType = 0
    
    //TODO Make dirty flags for each canvas, draw them all at once during frame call.
    // var dirtyHold, dirtyActive, dirtyStack, dirtyPreview
    /// mark current piece location, draw if different
    static var lastX = 0, lastY = 0, lastPos = 0, landed = false
    
    // Stats
    static var lines = 0
    static var statsFinesse = 0
    static var piecesSet = 0
    static var startTime = 0
    static var digLines: [Int] = []
    
    // Keys
    /// press down keys
    static var keysDown = 0
    static var lastKeys = 0
    
    static var binds = (
        pause: 12,      /// q
        moveLeft: 38,   /// j
        moveRight: 37,  /// l
        softDrop: 40,   /// k
        hardDrop: 34,   /// i
        hold: 49,       /// space
        rotateRight: 3, /// f
        rotateLeft: 2,  /// d
        rotate180: 1,   /// s
        retry: 15,      /// r
        stopRepeat: 14  /// e
    )
    
    static var flags = (
        hardDrop: 1,
        moveRight: 2,
        moveLeft: 4,
        softDrop: 8,
        hold: 16,
        rotateRight: 32,
        rotateLeft: 64,
        rotate180: 128
    )
}


/**
 * Add divisor method so we can do clock arithmetics. This is later used to
 *  determine tetromino orientation.
 */
extension Int {
    
    func mod(_ n: Int) -> Int {
        return ((self % n) + n) % n
    }
    
    /// as an unknow or default
    static var undefined: Int {
        return 999999
    }
}


extension Double {
    
    /// as an unknow or default
    static var max: Double {
        return 999999
    }
}


// MARK: - game controller

protocol CoreBlockControllerProtocol {
    
    /// common
    func draw(_ drawInfo: CoreBlockController.DrawInfo)
    func clear(_ type: CoreBlockController.DrawType)
    /// preview
    func draw(_ drawInfoArray: [CoreBlockController.DrawInfo])
    
    /// message
    func message(_ message: String, _ type: CoreBlockController.MessageType)
}

class CoreBlockController {
    
    static var shared: CoreBlockController = CoreBlockController()
    
    var delegate: CoreBlockControllerProtocol?
    
    var timer: DispatchSourceTimer!
    var pageStepTime: DispatchTimeInterval = .microseconds(1000000 / 60)
    
    /**
     * Resets all the settings and starts the game.
     */
    func new(gameType gt: Int) {
        if (gt == -1) {
            CoreBlockData.watchingReplay = true
        } else {
            CoreBlockData.watchingReplay = false
            CoreBlockData.replayKeys = [:]
            // TODO Make new seed and rng method.
            CoreBlockData.replayKeys[-1] = Int(arc4random()) * 2147483645 + 1
            CoreBlockData.gameType = gt
        }
        
        if gt == 0 {
            CoreBlockData.lineLimit = 40
        } else if gt == 1 {
            CoreBlockData.lineLimit = 1000
        }
        
        //Reset
        CoreBlockData.column = 0
        CoreBlockData.keysDown = 0
        CoreBlockData.lastKeys = 0
        //TODO Check if needed.
        CoreBlockPiece.shared.shiftDir = 0
        CoreBlockPiece.shared.shiftReleased = true
        
        CoreBlockData.startPauseTime = 0
        CoreBlockData.pauseTime = 0
        CoreBlockData.paused = false
        
        CoreBlockRng.shared.seed = CoreBlockData.replayKeys[-1]!
        CoreBlockData.frame = 0
        CoreBlockData.lastPos = Int.undefined
        CoreBlockStack.shared.new(10, 22)
        CoreBlockHold.shared.piece = Int.undefined
        CoreBlockData.startTime = Date.now()
        
        CoreBlockPreview.shared.new()
        
        CoreBlockData.statsFinesse = 0
        CoreBlockData.lines = 0
        CoreBlockData.piecesSet = 0
        CoreBlockData.finesseFaultRepeat = 0
        
        CoreBlockController.message(CoreBlockData.statsFinesse, .finesse)
        CoreBlockController.message(CoreBlockData.piecesSet, .statsPiece)
        CoreBlockController.message(CoreBlockData.lineLimit - CoreBlockData.lines, .statsLines)
        statistics()
        CoreBlockController.message(CoreBlockData.finesseFaultRepeat, CoreBlockController.MessageType.finesseFaultRepeat)
        CoreBlockController.clear(CoreBlockController.DrawType.stack)
        CoreBlockController.clear(CoreBlockController.DrawType.active)
        CoreBlockController.clear(CoreBlockController.DrawType.hold)
        
        if (CoreBlockData.gameType == 3) {
            // Dig Race
            // make ten random numbers, make sure next isn't the same as last?
            //TODO make into function or own file.
            
            CoreBlockData.digLines = [12, 13, 14, 15, 16, 17, 18, 19, 20, 21]
            
            CoreBlockController.message(10, .statsLines)
            var randomNums: [Int] = []
            for i in (0 ..< 10) {
                let random = Int(CoreBlockRng.shared.next() * 10)
                randomNums.append(random)
            }
            for y in (12 ... 21).reversed() {
                for x in (0 ..< 10) {
                    if (randomNums[y - 12] != x) {
                        CoreBlockStack.shared.grid[x][y] = 8
                    }
                }
            }
            CoreBlockStack.shared.draw()
        }
        
//        menu()
        
        // Only start a loop if one is not running already.
        if (CoreBlockData.gameState == 3) {
            CoreBlockData.gameState = 2
            startGameLoop()
        } else {
            CoreBlockData.gameState = 2
        }
    }
    
    func pause() {
        if (CoreBlockData.gameState == 0) {
            CoreBlockData.paused = true
            CoreBlockData.startPauseTime = Date.now()
            CoreBlockController.message("Paused", .game)
//            menu(4)
        }
    }
    
    func unpause() {
        CoreBlockData.paused = false
        CoreBlockData.pauseTime += Date.now() - CoreBlockData.startPauseTime
        CoreBlockController.message("", .game)
//        menu()
    }
    
    /**
     * Draws the stats next to the tetrion.
     */
    func statistics() {
        
        let time = Date.now() - CoreBlockData.startTime - CoreBlockData.pauseTime
        let seconds = time / 1000
        let microseconds = (time / 10) % 100
        CoreBlockController.message((seconds < 10 ? "0" : "") + String(seconds) +
            (microseconds < 10 ? ":0" : ":") + String(microseconds), .statsTime)
        
        let pps: Double = CoreBlockData.piecesSet > 0 ? Double(CoreBlockData.piecesSet) / Double(time) * 1000 : 0
        CoreBlockController.message(String(format: "%.2f", pps), .pps)
    }
    
    func pressKey(down: Bool, keyCode: Int) {
        
        /// key down
        if down {
            // TODO send to menu or game depending on context.
//            if ([32, 37, 38, 39, 40].indexOf(keyCode) !== -1) e.preventDefault()
            //TODO if active, prevent default for binded keys
            //if (bindsArr.indexOf(keyCode) !== -1)
            //  e.preventDefault()
            if (keyCode == CoreBlockData.binds.pause) {
                if (CoreBlockData.paused) {
                    unpause()
                } else {
                    pause()
                }
            }
            if (keyCode == CoreBlockData.binds.retry) {
                CoreBlockController.shared.new(gameType: CoreBlockData.gameType)
            }
            if (keyCode == CoreBlockData.binds.stopRepeat) {
                CoreBlockData.finesseFaultRepeat = 0
                CoreBlockController.message(CoreBlockData.finesseFaultRepeat, CoreBlockController.MessageType.finesseFaultRepeat)
            }
            if (!CoreBlockData.watchingReplay) {
                if (keyCode == CoreBlockData.binds.moveLeft) {
                    CoreBlockData.keysDown |= CoreBlockData.flags.moveLeft
                    //CoreBlockPiece.shared.finesse++
                } else if (keyCode == CoreBlockData.binds.moveRight) {
                    CoreBlockData.keysDown |= CoreBlockData.flags.moveRight
                } else if (keyCode == CoreBlockData.binds.softDrop) {
                    CoreBlockData.keysDown |= CoreBlockData.flags.softDrop
                } else if (keyCode == CoreBlockData.binds.hardDrop) {
                    CoreBlockData.keysDown |= CoreBlockData.flags.hardDrop
                } else if (keyCode == CoreBlockData.binds.rotateRight) {
                    CoreBlockData.keysDown |= CoreBlockData.flags.rotateRight
                } else if (keyCode == CoreBlockData.binds.rotateLeft) {
                    CoreBlockData.keysDown |= CoreBlockData.flags.rotateLeft
                } else if (keyCode == CoreBlockData.binds.rotate180) {
                    CoreBlockData.keysDown |= CoreBlockData.flags.rotate180
                } else if (keyCode == CoreBlockData.binds.hold) {
                    CoreBlockData.keysDown |= CoreBlockData.flags.hold
                }
            }
        }
        /// key up
        else {
            if (!CoreBlockData.watchingReplay) {
                if (keyCode == CoreBlockData.binds.moveLeft && (CoreBlockData.keysDown & CoreBlockData.flags.moveLeft) > 0) {
                    CoreBlockData.keysDown ^= CoreBlockData.flags.moveLeft
                } else if (keyCode == CoreBlockData.binds.moveRight && (CoreBlockData.keysDown & CoreBlockData.flags.moveRight) > 0) {
                    CoreBlockData.keysDown ^= CoreBlockData.flags.moveRight
                } else if (keyCode == CoreBlockData.binds.softDrop && (CoreBlockData.keysDown & CoreBlockData.flags.softDrop) > 0) {
                    CoreBlockData.keysDown ^= CoreBlockData.flags.softDrop
                } else if (keyCode == CoreBlockData.binds.hardDrop && (CoreBlockData.keysDown & CoreBlockData.flags.hardDrop) > 0) {
                    CoreBlockData.keysDown ^= CoreBlockData.flags.hardDrop
                } else if (keyCode == CoreBlockData.binds.rotateRight && (CoreBlockData.keysDown & CoreBlockData.flags.rotateRight) > 0) {
                    CoreBlockData.keysDown ^= CoreBlockData.flags.rotateRight
                } else if (keyCode == CoreBlockData.binds.rotateLeft && (CoreBlockData.keysDown & CoreBlockData.flags.rotateLeft) > 0) {
                    CoreBlockData.keysDown ^= CoreBlockData.flags.rotateLeft
                } else if (keyCode == CoreBlockData.binds.rotate180 && (CoreBlockData.keysDown & CoreBlockData.flags.rotate180) > 0) {
                    CoreBlockData.keysDown ^= CoreBlockData.flags.rotate180
                } else if (keyCode == CoreBlockData.binds.hold && (CoreBlockData.keysDown & CoreBlockData.flags.hold) > 0) {
                    CoreBlockData.keysDown ^= CoreBlockData.flags.hold
                }
            }
        }
    }
}


// MARK: - draw

extension CoreBlockController {
    
    enum DrawType {
        case hold, stack, active, ghost, preview
    }
    
    class DrawInfo {
        var tetro: [[Int]]
        var cx: Int
        var cy: Int
        var type: DrawType
        var color: Int
        
        init(tetro: [[Int]], cx: Int, cy: Int, type: DrawType, color: Int = Int.undefined) {
            self.tetro = tetro
            self.cx = cx
            self.cy = cy
            self.type = type
            self.color = color
        }
    }
    
    /**
     * Draws a 2d array of minos.
     */
    /// common
    static func draw(_ drawInfo: DrawInfo) {
        self.shared.delegate?.draw(drawInfo)
    }
    
    static func clear(_ type: DrawType) {
        self.shared.delegate?.clear(type)
    }
    
    /// preview
    static func draw(_ drawInfoArray: [DrawInfo]) {
        self.shared.delegate?.draw(drawInfoArray)
    }
}


// MARK: - game loop

extension CoreBlockController {
    
    /// start timer
    func startGameLoop() {
        
        self.timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        self.timer.schedule(deadline: .now() + self.pageStepTime, repeating: self.pageStepTime)
        self.timer.setEventHandler {
            self.gameLoop()
        }
        // 启动定时器
        self.timer.resume()
    }
    
    //TODO Cleanup gameloop and update.
    /**
     * Runs every frame.
     */
    func update() {
        //TODO Das preservation broken.
        if (CoreBlockData.lastKeys != CoreBlockData.keysDown && !CoreBlockData.watchingReplay) {
            CoreBlockData.replayKeys[CoreBlockData.frame] = CoreBlockData.keysDown
        } else if let value = CoreBlockData.replayKeys[CoreBlockData.frame] {
            CoreBlockData.keysDown = value
        }
        
        if (!((CoreBlockData.lastKeys & CoreBlockData.flags.hold) > 0) && (CoreBlockData.flags.hold & CoreBlockData.keysDown) > 0) {
            CoreBlockPiece.shared.hold()
        }
        
        if ((CoreBlockData.flags.rotateLeft & CoreBlockData.keysDown) > 0 && !((CoreBlockData.lastKeys & CoreBlockData.flags.rotateLeft) > 0)) {
            CoreBlockPiece.shared.rotate(-1)
            CoreBlockPiece.shared.finesse += 1
        } else if ((CoreBlockData.flags.rotateRight & CoreBlockData.keysDown) > 0 && !((CoreBlockData.lastKeys & CoreBlockData.flags.rotateRight) > 0)) {
            CoreBlockPiece.shared.rotate(1)
            CoreBlockPiece.shared.finesse += 1
        } else if ((CoreBlockData.flags.rotate180 & CoreBlockData.keysDown) > 0 && !((CoreBlockData.lastKeys & CoreBlockData.flags.rotate180) > 0)) {
            CoreBlockPiece.shared.rotate(2)
            CoreBlockPiece.shared.finesse += 1
        }
        
        CoreBlockPiece.shared.checkShift()
        
        if (CoreBlockData.flags.softDrop & CoreBlockData.keysDown) > 0 {
            CoreBlockPiece.shared.shiftDown()
            //CoreBlockPiece.shared.finesse++
        }
        if (!((CoreBlockData.lastKeys & CoreBlockData.flags.hardDrop) > 0) && (CoreBlockData.flags.hardDrop & CoreBlockData.keysDown) > 0) {
            CoreBlockPiece.shared.hardDrop()
        }
        
        CoreBlockPiece.shared.update()
        
        // Win
        // TODO
        if (CoreBlockData.gameType != 3) {
            if (CoreBlockData.lines >= CoreBlockData.lineLimit) {
                CoreBlockData.gameState = 1
                CoreBlockController.message("GREAT!", .game)
//                menu(3)
            }
        } else {
            if (CoreBlockData.digLines.count == 0) {
                CoreBlockData.gameState = 1
                CoreBlockController.message("GREAT!", .game)
//                menu(3)
            }
        }
        
        statistics()
        
        if (CoreBlockData.lastKeys != CoreBlockData.keysDown) {
            CoreBlockData.lastKeys = CoreBlockData.keysDown
        }
    }
    
    func gameLoop() {
        
        //TODO check to see how pause works in replays.
        CoreBlockData.frame += 1
        
        if (CoreBlockData.gameState == 0) {
            // Playing
            
            if (!CoreBlockData.paused) {
                update()
            }
            
            // TODO improve this with 'dirty' CoreBlockData.flags.
            if (
                CoreBlockPiece.shared.x != CoreBlockData.lastX ||
                    CoreBlockPiece.shared.floorY != CoreBlockData.lastY ||
                    CoreBlockPiece.shared.pos != CoreBlockData.lastPos ||
                    CoreBlockPiece.shared.dirty
                ) {
                CoreBlockController.clear(CoreBlockController.DrawType.active)
                CoreBlockPiece.shared.drawGhost()
                CoreBlockPiece.shared.draw()
            }
            CoreBlockData.lastX = CoreBlockPiece.shared.x
            CoreBlockData.lastY = CoreBlockPiece.shared.floorY
            CoreBlockData.lastPos = CoreBlockPiece.shared.pos
            CoreBlockPiece.shared.dirty = false
        } else if (CoreBlockData.gameState == 2) {
            // Count Down
            if (CoreBlockData.frame < 30) {
                CoreBlockController.message("READY", .game)
            } else if (CoreBlockData.frame < 60) {
                CoreBlockController.message("GO!", .game)
            } else {
                CoreBlockController.message("", .game)
                CoreBlockData.gameState = 0
                CoreBlockData.startTime = Date.now()
                CoreBlockPiece.shared.new(CoreBlockPreview.shared.next())
            }
            // DAS Preload
            if (CoreBlockData.lastKeys != CoreBlockData.keysDown && !CoreBlockData.watchingReplay) {
                CoreBlockData.replayKeys[CoreBlockData.frame] = CoreBlockData.keysDown
            } else if let value = CoreBlockData.replayKeys[CoreBlockData.frame] {
                CoreBlockData.keysDown = value
            }
            if (CoreBlockData.keysDown & CoreBlockData.flags.moveLeft) > 0 {
                CoreBlockData.lastKeys = CoreBlockData.keysDown
                CoreBlockPiece.shared.shiftDelay = CoreBlockData.settings.DAS
                CoreBlockPiece.shared.shiftReleased = false
                CoreBlockPiece.shared.shiftDir = -1
            } else if (CoreBlockData.keysDown & CoreBlockData.flags.moveRight) > 0 {
                CoreBlockData.lastKeys = CoreBlockData.keysDown
                CoreBlockPiece.shared.shiftDelay = CoreBlockData.settings.DAS
                CoreBlockPiece.shared.shiftReleased = false
                CoreBlockPiece.shared.shiftDir = 1
            }
        }
    }
}


// MARK: - message

extension CoreBlockController {
    
    enum MessageType {
        case game, statsPiece, pps, statsLines, statsTime, finesse, finesseFaultRepeat
    }
    
    static func message(_ message: String, _ type: MessageType) {
        self.shared.delegate?.message(message, type)
    }
    
    static func message(_ message: Int, _ type: MessageType) {
        self.shared.delegate?.message(String(message), type)
    }
    
    static func message(_ message: Double, _ type: MessageType) {
        self.shared.delegate?.message(String(message), type)
    }
}


// MARK: - random

/**
 * Park Miller "Minimal Standard" PRNG.
 */
//TODO put random seed method in here.
class CoreBlockRng {
    
    static var shared: CoreBlockRng = CoreBlockRng()
    
    var seed: Int = 1
    
    func new(_ seed: Int) {
        self.seed = seed
    }
}

extension CoreBlockRng {
    
    func next() -> Double {
        // Returns a float between 0.0, and 1.0
        return Double(self.gen()) / 2147483647.0
    }
    func gen() -> Int {
        self.seed = (self.seed % 2147483647) * 16807 % 2147483647
        return self.seed
    }
}


// MARK: - time

extension Date {
    static func now() -> Int {
        return Int((Date.timeIntervalSinceReferenceDate + Date.timeIntervalBetween1970AndReferenceDate) * 1000)
    }
}
