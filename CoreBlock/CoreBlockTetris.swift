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
var gravityUnit: Double = 0.00390625
var gravity: Double = 0
var gravityArr: [Double] = [0, 1.0/64.0, 2.0/64.0, 4.0/64.0, 8.0/64.0, 16.0/64.0, 32.0/64.0, 1, 20]

var settings = (
    DAS: 6,
    ARR: 0,
    Gravity: 0,
    SoftDrop: 31,
    LockDelay: 30,
    Ghost: 0,
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

/// replay: -1
/*
 -1 : replay
  3 : dig race
 */
var gametype = 0

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
    pause: 32,
    moveLeft: 1,
    moveRight: 2,
    moveDown: 3,
    hardDrop: 4,
    holdPiece: 11,
    rotRight: 22,
    rotLeft: 21,
    rot180: 23,
    retry: 31
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


// MARK: - game controller

class CoreBlockController {
    
    static var shared: CoreBlockController = CoreBlockController()
    
    /**
     * Resets all the settings and starts the game.
     */
    func new(_ gt: Int) {
        if (gt == -1) {
            watchingReplay = true
        } else {
            watchingReplay = false
            replayKeys = [:]
            // TODO Make new seed and rng method.
            replayKeys[-1] = Int(arc4random() * 2147483645 + 1)
            gametype = gt
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
        if (settings.Gravity == 0) {
            gravity = gravityUnit * 4
        }
        startTime = Date.now()
        
        CoreBlockPreview.shared.new()
        
        statsFinesse = 0
        lines = 0
        piecesSet = 0
        
        CoreBlockMessage.statsPiece(piecesSet)
        CoreBlockMessage.statsLines(lineLimit - lines)
        statistics()
        CoreBlockController.clear(CoreBlockController.DrawType.stack)
        CoreBlockController.clear(CoreBlockController.DrawType.active)
        CoreBlockController.clear(CoreBlockController.DrawType.hold)
        
        if (gametype == 3) {
            // Dig Race
            // make ten random numbers, make sure next isn't the same as last?
            //TODO make into function or own file.
            
            digLines = [12, 13, 14, 15, 16, 17, 18, 19, 20, 21]
            
            CoreBlockMessage.statsLines(10)
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
            CoreBlockMessage.game("Paused")
            menu(4)
        }
    }
    
    func unpause() {
        paused = false
        pauseTime += Date.now() - startPauseTime
        CoreBlockMessage.game("")
        menu()
    }
    
    /**
     * Draws the stats next to the tetrion.
     */
    func statistics() {
        let time = Date.now() - startTime - pauseTime
        let seconds = time / 1000
        let microseconds = (time / 10) % 100
        CoreBlockMessage.statsTime((seconds < 10 ? "0" : "") + String(seconds) +
            (microseconds < 10 ? ":0" : ":") + String(microseconds))
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
                CoreBlockController.shared.new(gametype)
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
        case hold, stack, active, preview
    }
    
    /**
     * Draws a 2d array of minos.
     */
    static func draw(_ tetro: [[Int]], _ cx: Int, _ cy: Int, _ type: DrawType, _ color: Int = Int.undefined) {
        
        for x in (0 ..< tetro.count) {
            for y in (0 ..< tetro[x].count) {
                if (tetro[x][y] != 0) {
                    //                drawCell(x + cx, y + cy, color != Int.undefined ? color : tetro[x][y], type)
                }
            }
        }
    }
    
    static func clear(_ type: DrawType) {
        
    }
}


// MARK: - game loop

extension CoreBlockController {
    
    /// start timer
    func startGameLoop() {
        
        let timer: DispatchSourceTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        let pageStepTime: DispatchTimeInterval = .microseconds(1000000 / 60)
        timer.schedule(deadline: .now() + pageStepTime, repeating: pageStepTime)
        timer.setEventHandler {
            self.gameLoop();
        }
        // 启动定时器
        timer.resume()
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
            CoreBlockPiece.shared.rotate(1)
            CoreBlockPiece.shared.rotate(1)
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
        if (gametype != 3) {
            if (lines >= lineLimit) {
                gameState = 1
                CoreBlockMessage.game("GREAT!")
                menu(3)
            }
        } else {
            if (digLines.count == 0) {
                gameState = 1
                CoreBlockMessage.game("GREAT!")
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
        frame += 1;
        
        if (gameState == 0) {
            // Playing
            
            if (!paused) {
                update();
            }
            
            // TODO improve this with 'dirty' flags.
            if (
                CoreBlockPiece.shared.x != lastX ||
                    Int(CoreBlockPiece.shared.y) != lastY ||
                    CoreBlockPiece.shared.pos != lastPos ||
                    CoreBlockPiece.shared.dirty
                ) {
                CoreBlockController.clear(CoreBlockController.DrawType.active)
                CoreBlockPiece.shared.drawGhost();
                CoreBlockPiece.shared.draw();
            }
            lastX = CoreBlockPiece.shared.x;
            lastY = Int(CoreBlockPiece.shared.y);
            lastPos = CoreBlockPiece.shared.pos;
            CoreBlockPiece.shared.dirty = false;
        } else if (gameState == 2) {
            // Count Down
            if (frame < 50) {
                CoreBlockMessage.game("READY")
            } else if (frame < 100) {
                CoreBlockMessage.game("GO!")
            } else {
                CoreBlockMessage.game("")
                gameState = 0;
                startTime = Date.now();
                CoreBlockPiece.shared.new(CoreBlockPreview.shared.next());
            }
            // DAS Preload
            if (lastKeys != keysDown && !watchingReplay) {
                replayKeys[frame] = keysDown;
            } else if let value = replayKeys[frame] {
                keysDown = value
            }
            if (keysDown & flags.moveLeft) > 0 {
                lastKeys = keysDown;
                CoreBlockPiece.shared.shiftDelay = settings.DAS;
                CoreBlockPiece.shared.shiftReleased = false;
                CoreBlockPiece.shared.shiftDir = -1;
            } else if (keysDown & flags.moveRight) > 0 {
                lastKeys = keysDown;
                CoreBlockPiece.shared.shiftDelay = settings.DAS;
                CoreBlockPiece.shared.shiftReleased = false;
                CoreBlockPiece.shared.shiftDir = 1;
            }
        }
    }
}


// MARK: - message

class CoreBlockMessage {
    
    static var lastGameMessage: String = ""
    
    static func game(_ message: String) {
        
        if self.lastGameMessage != message {
            self.lastGameMessage = message
            print(message)
        }
    }
    
    static func statsPiece(_ message: Int) {
        print(message)
    }
    
    static func statsLines(_ message: Int) {
        print(message)
    }
    
    static func statsTime(_ message: String) {
        print(message)
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
        self.seed = self.seed * 16807 % 2147483647
        return self.seed
    }
}


// MARK: - time

extension Date {
    static func now() -> Int {
        return Int((Date.timeIntervalSinceReferenceDate + Date.timeIntervalBetween1970AndReferenceDate) * 1000)
    }
}
