//
//  CoreBlockTetris.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/10.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Foundation

// MARK: - global variable

/**
 * Playfield.
 */
var column: Int = 0

/**
 * Piece data
 */

// NOTE y values are inverted since our matrix counts from top to bottom.
var kickData: [[[Int]]] = [
    [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0]],
    [[0, 0], [1, 0], [1, 1], [0, -2], [1, -2]],
    [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0]],
    [[0, 0], [-1, 0], [-1, 1], [0, -2], [-1, -2]],
]
var kickDataI: [[[Int]]] = [
    [[0, 0], [-1, 0], [2, 0], [-1, 0], [2, 0]],
    [[-1, 0], [0, 0], [0, 0], [0, -1], [0, 2]],
    [[-1, -1], [1, -1], [-2, -1], [1, 0], [-2, 0]],
    [[0, -1], [0, -1], [0, -1], [0, 1], [0, -2]],
]
// TODO get rid of this lol.
var kickDataO: [[[Int]]] = [[[0, 0]], [[0, 0]], [[0, 0]], [[0, 0]]]

// Define shapes and spawns.
var PieceI = (
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
var PieceJ = (
    index: 1,
    x: 3,
    y: 0,
    kickData: kickData,
    tetro: [[2, 2, 0], [0, 2, 0], [0, 2, 0]]
)
var PieceL = (
    index: 2,
    x: 3,
    y: 0,
    kickData: kickData,
    tetro: [[0, 3, 0], [0, 3, 0], [3, 3, 0]]
)
var PieceO = (
    index: 3,
    x: 4,
    y: 0,
    kickData: kickDataO,
    tetro: [[4, 4], [4, 4]]
)
var PieceS = (
    index: 4,
    x: 3,
    y: 0,
    kickData: kickData,
    tetro: [[0, 5, 0], [5, 5, 0], [5, 0, 0]]
)
var PieceT = (
    index: 5,
    x: 3,
    y: 0,
    kickData: kickData,
    tetro: [[0, 6, 0], [6, 6, 0], [0, 6, 0]]
)
var PieceZ = (
    index: 6,
    x: 3,
    y: 0,
    kickData: kickData,
    tetro: [[7, 0, 0], [7, 7, 0], [0, 7, 0]]
)
var pieces = [PieceI, PieceJ, PieceL, PieceO, PieceS, PieceT, PieceZ]

// Finesse data
// index x orientatio x column = finesse
// finesse[0][0][4] = 1
// TODO double check these.
var finesse: [[[Int]]] = [
    [
        [1, 2, 1, 0, 1, 2, 1],
        [2, 2, 2, 2, 1, 1, 2, 2, 2, 2],
        [1, 2, 1, 0, 1, 2, 1],
        [2, 2, 2, 2, 1, 1, 2, 2, 2, 2],
        ],
    [
        [1, 2, 1, 0, 1, 2, 2, 1],
        [2, 2, 3, 2, 1, 2, 3, 3, 2],
        [2, 3, 2, 1, 2, 3, 3, 2],
        [2, 3, 2, 1, 2, 3, 3, 2, 2],
        ],
    [
        [1, 2, 1, 0, 1, 2, 2, 1],
        [2, 2, 3, 2, 1, 2, 3, 3, 2],
        [2, 3, 2, 1, 2, 3, 3, 2],
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
        [2, 3, 2, 1, 2, 3, 3, 2],
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
var gravity: Double = 1.0 / 64

var settings = (
    DAS: 6,
    ARR: 0,
    Gravity: 1.0 / 64,
    SoftDrop: 200.0,
    LockDelay: 30,
    Ghost: 1
)

/// total frames
var frame = 0

/**
 *Pausing variables
 */

var startPauseTime = 0
var pauseTime = 0

/**
 * 0 = normal
 * 1 = win
 * 2 = countdown
 * 3 = game not played
 * 9 = loss
 */
var gameState = 3

var paused = false
/// while sprint, this is 40
var lineLimit = 0

/*
 -1 : seed
  x : frame
 */
var replayKeys: [Int: Int] = [:]
var watchingReplay = false

/*
 -1: Replay
 0 : Sprint
 3 : Dig race
 */
var gameType = 0

//TODO Make dirty flags for each canvas, draw them all at once during frame call.
// var dirtyHold, dirtyActive, dirtyStack, dirtyPreview
/// mark current piece location, draw if different
var lastX = 0, lastY = 0, lastPos = 0, landed = false

// Stats
var lines = 0
var statsFinesse = 0
var piecesSet = 0
var startTime = 0
var digLines: [Int] = []

// Keys
/// press down keys
var keysDown = 0
var lastKeys = 0

/// these codes are inner values, as constant, do not change it, different with outer
var binds = (
//    pause: 32,
//    moveLeft: 1,
//    moveRight: 2,
//    moveDown: 3,
//    hardDrop: 4,
//    holdPiece: 11,
//    rotRight: 22,
//    rotLeft: 21,
//    rot180: 23,
//    retry: 31
    pause: 12,
    moveLeft: 38,
    moveRight: 37,
    moveDown: 40,
    hardDrop: 34,
    holdPiece: 49,
    rotRight: 3,
    rotLeft: 2,
    rot180: 1,
    retry: 15
)
var flags = (
    hardDrop: 1,
    moveRight: 2,
    moveLeft: 4,
    moveDown: 8,
    holdPiece: 16,
    rotRight: 32,
    rotLeft: 64,
    rot180: 128
)


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
            watchingReplay = true
        } else {
            watchingReplay = false
            replayKeys = [:]
            // TODO Make new seed and rng method.
            replayKeys[-1] = Int(arc4random()) * 2147483645 + 1
            gameType = gt
        }
        
        lineLimit = 40
        
        //Reset
        column = 0
        keysDown = 0
        lastKeys = 0
        //TODO Check if needed.
        CoreBlockPiece.shared.shiftDir = 0
        CoreBlockPiece.shared.shiftReleased = true
        
        startPauseTime = 0
        pauseTime = 0
        paused = false
        
        CoreBlockRng.shared.seed = replayKeys[-1]!
        frame = 0
        lastPos = Int.undefined
        CoreBlockStack.shared.new(10, 22)
        CoreBlockHold.shared.piece = Int.undefined
        startTime = Date.now()
        
        CoreBlockPreview.shared.new()
        
        statsFinesse = 0
        lines = 0
        piecesSet = 0
        
        CoreBlockController.message(statsFinesse, .finesse)
        CoreBlockController.message(piecesSet, .statsPiece)
        CoreBlockController.message(lineLimit - lines, .statsLines)
        statistics()
        CoreBlockController.clear(CoreBlockController.DrawType.stack)
        CoreBlockController.clear(CoreBlockController.DrawType.active)
        CoreBlockController.clear(CoreBlockController.DrawType.hold)
        
        if (gameType == 3) {
            // Dig Race
            // make ten random numbers, make sure next isn't the same as last?
            //TODO make into function or own file.
            
            digLines = [12, 13, 14, 15, 16, 17, 18, 19, 20, 21]
            
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
        
        menu()
        
        // Only start a loop if one is not running already.
        if (gameState == 3) {
            gameState = 2
            startGameLoop()
        } else {
            gameState = 2
        }
    }
    
    func pause() {
        if (gameState == 0) {
            paused = true
            startPauseTime = Date.now()
            CoreBlockController.message("Paused", .game)
            menu(4)
        }
    }
    
    func unpause() {
        paused = false
        pauseTime += Date.now() - startPauseTime
        CoreBlockController.message("", .game)
        menu()
    }
    
    /**
     * Draws the stats next to the tetrion.
     */
    func statistics() {
        
        let time = Date.now() - startTime - pauseTime
        let seconds = time / 1000
        let microseconds = (time / 10) % 100
        CoreBlockController.message((seconds < 10 ? "0" : "") + String(seconds) +
            (microseconds < 10 ? ":0" : ":") + String(microseconds), .statsTime)
        
        let pps: Double = piecesSet > 0 ? Double(piecesSet) / Double(time) * 1000 : 0
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
            if (keyCode == binds.pause) {
                if (paused) {
                    unpause()
                } else {
                    pause()
                }
            }
            if (keyCode == binds.retry) {
                CoreBlockController.shared.new(gameType: gameType)
            }
            if (!watchingReplay) {
                if (keyCode == binds.moveLeft) {
                    keysDown |= flags.moveLeft
                    //CoreBlockPiece.shared.finesse++
                } else if (keyCode == binds.moveRight) {
                    keysDown |= flags.moveRight
                } else if (keyCode == binds.moveDown) {
                    keysDown |= flags.moveDown
                } else if (keyCode == binds.hardDrop) {
                    keysDown |= flags.hardDrop
                } else if (keyCode == binds.rotRight) {
                    keysDown |= flags.rotRight
                } else if (keyCode == binds.rotLeft) {
                    keysDown |= flags.rotLeft
                } else if (keyCode == binds.rot180) {
                    keysDown |= flags.rot180
                } else if (keyCode == binds.holdPiece) {
                    keysDown |= flags.holdPiece
                }
            }
        }
        /// key up
        else {
            if (!watchingReplay) {
                if (keyCode == binds.moveLeft && (keysDown & flags.moveLeft) > 0) {
                    keysDown ^= flags.moveLeft
                } else if (keyCode == binds.moveRight && (keysDown & flags.moveRight) > 0) {
                    keysDown ^= flags.moveRight
                } else if (keyCode == binds.moveDown && (keysDown & flags.moveDown) > 0) {
                    keysDown ^= flags.moveDown
                } else if (keyCode == binds.hardDrop && (keysDown & flags.hardDrop) > 0) {
                    keysDown ^= flags.hardDrop
                } else if (keyCode == binds.rotRight && (keysDown & flags.rotRight) > 0) {
                    keysDown ^= flags.rotRight
                } else if (keyCode == binds.rotLeft && (keysDown & flags.rotLeft) > 0) {
                    keysDown ^= flags.rotLeft
                } else if (keyCode == binds.rot180 && (keysDown & flags.rot180) > 0) {
                    keysDown ^= flags.rot180
                } else if (keyCode == binds.holdPiece && (keysDown & flags.holdPiece) > 0) {
                    keysDown ^= flags.holdPiece
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
        if (lastKeys != keysDown && !watchingReplay) {
            replayKeys[frame] = keysDown
        } else if let value = replayKeys[frame] {
            keysDown = value
        }
        
        if (!((lastKeys & flags.holdPiece) > 0) && (flags.holdPiece & keysDown) > 0) {
            CoreBlockPiece.shared.hold()
        }
        
        if ((flags.rotLeft & keysDown) > 0 && !((lastKeys & flags.rotLeft) > 0)) {
            CoreBlockPiece.shared.rotate(-1)
            CoreBlockPiece.shared.finesse += 1
        } else if ((flags.rotRight & keysDown) > 0 && !((lastKeys & flags.rotRight) > 0)) {
            CoreBlockPiece.shared.rotate(1)
            CoreBlockPiece.shared.finesse += 1
        } else if ((flags.rot180 & keysDown) > 0 && !((lastKeys & flags.rot180) > 0)) {
            CoreBlockPiece.shared.rotate(2)
            CoreBlockPiece.shared.finesse += 1
        }
        
        CoreBlockPiece.shared.checkShift()
        
        if (flags.moveDown & keysDown) > 0 {
            CoreBlockPiece.shared.shiftDown()
            //CoreBlockPiece.shared.finesse++
        }
        if (!((lastKeys & flags.hardDrop) > 0) && (flags.hardDrop & keysDown) > 0) {
            CoreBlockPiece.shared.hardDrop()
        }
        
        CoreBlockPiece.shared.update()
        
        // Win
        // TODO
        if (gameType != 3) {
            if (lines >= lineLimit) {
                gameState = 1
                CoreBlockController.message("GREAT!", .game)
                menu(3)
            }
        } else {
            if (digLines.count == 0) {
                gameState = 1
                CoreBlockController.message("GREAT!", .game)
                menu(3)
            }
        }
        
        statistics()
        
        if (lastKeys != keysDown) {
            lastKeys = keysDown
        }
    }
    
    func gameLoop() {
        
        //TODO check to see how pause works in replays.
        frame += 1
        
        if (gameState == 0) {
            // Playing
            
            if (!paused) {
                update()
            }
            
            // TODO improve this with 'dirty' flags.
            if (
                CoreBlockPiece.shared.x != lastX ||
                    CoreBlockPiece.shared.floorY != lastY ||
                    CoreBlockPiece.shared.pos != lastPos ||
                    CoreBlockPiece.shared.dirty
                ) {
                CoreBlockController.clear(CoreBlockController.DrawType.active)
                CoreBlockPiece.shared.drawGhost()
                CoreBlockPiece.shared.draw()
            }
            lastX = CoreBlockPiece.shared.x
            lastY = CoreBlockPiece.shared.floorY
            lastPos = CoreBlockPiece.shared.pos
            CoreBlockPiece.shared.dirty = false
        } else if (gameState == 2) {
            // Count Down
            if (frame < 50) {
                CoreBlockController.message("READY", .game)
            } else if (frame < 100) {
                CoreBlockController.message("GO!", .game)
            } else {
                CoreBlockController.message("", .game)
                gameState = 0
                startTime = Date.now()
                CoreBlockPiece.shared.new(CoreBlockPreview.shared.next())
            }
            // DAS Preload
            if (lastKeys != keysDown && !watchingReplay) {
                replayKeys[frame] = keysDown
            } else if let value = replayKeys[frame] {
                keysDown = value
            }
            if (keysDown & flags.moveLeft) > 0 {
                lastKeys = keysDown
                CoreBlockPiece.shared.shiftDelay = settings.DAS
                CoreBlockPiece.shared.shiftReleased = false
                CoreBlockPiece.shared.shiftDir = -1
            } else if (keysDown & flags.moveRight) > 0 {
                lastKeys = keysDown
                CoreBlockPiece.shared.shiftDelay = settings.DAS
                CoreBlockPiece.shared.shiftReleased = false
                CoreBlockPiece.shared.shiftDir = 1
            }
        }
    }
}


// MARK: - message

extension CoreBlockController {
    
    enum MessageType {
        case game, statsPiece, pps, statsLines, statsTime, finesse
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
