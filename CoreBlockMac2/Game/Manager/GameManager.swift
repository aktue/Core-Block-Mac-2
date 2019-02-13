//
//  GameManager.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/11.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Cocoa

class GameManager {
    
    // MARK: - property
    
    static var shared: GameManager = GameManager()
    
    /// don't change value until restart app
    var windowWidth: CGFloat = 0
    var windowHeight: CGFloat = 0
    var minoSize: Int = 0
    
    var settingString: String {
        get {
            if let value = UserDefaults.standard.value(forKey: "GameManager.settingString") as? String,
                !value.isEmpty {
                return value
            } else {
                return """
                /// unit: frame
                DAS: 6
                ARR: 0
                /// unit: G (0.0156 = 1 / 64)
                Gravity: 0.0156
                SoftDrop: 200.0
                /// unit: frame
                LockDelay: 30
                /// 1: on, 0: off
                Ghost: 1
                FinesseFaultRepeat: 10
                
                /// window size
                WindowWidth: 800
                WindowHeight: 600
                /// mino size
                MinoSize: 24
                """
            }
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "GameManager.settingString")
        }
    }
    
    var controlString: String {
        get {
            if let value = UserDefaults.standard.value(forKey: "GameManager.controlString") as? String,
                !value.isEmpty {
                return value
            } else {
                return """
                /// q
                pause: 12
                /// j
                moveLeft: 38
                /// l
                moveRight: 37
                /// k
                softDrop: 40
                /// i
                hardDrop: 34
                /// space
                hold: 49
                /// f
                rotateRight: 3
                /// d
                rotateLeft: 2
                /// s
                rotate180: 1
                /// r
                retry: 15
                /// e
                stopRepeat: 14
                """
            }
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "GameManager.controlString")
        }
    }
    
    init() {
        
        self.windowWidth = self.cgFloatValue(forKey: "WindowWidth", defaultValue: 800.0)
        self.windowHeight = self.cgFloatValue(forKey: "WindowHeight", defaultValue: 600.0)
        self.minoSize = self.intValue(forKey: "MinoSize", defaultValue: Int(min(self.windowWidth, self.windowHeight) / 25))
    }
}

// MARK: - function setting

extension GameManager {
    
    func intValue(forKey key: String, defaultValue: Int) -> Int {
        
        let rawValue: String = self.rawValue(forKey: key)
        return Int(rawValue) ?? defaultValue
    }
    
    func cgFloatValue(forKey key: String, defaultValue: CGFloat) -> CGFloat {
        
        let rawValue: String = self.rawValue(forKey: key)
        return CGFloat(Double(rawValue) ?? Double(defaultValue))
    }
    
    func doubleValue(forKey key: String, defaultValue: Double) -> Double {
        
        let rawValue: String = self.rawValue(forKey: key)
        return Double(rawValue) ?? defaultValue
    }
    
    func rawValue(forKey key: String) -> String {
        
        /// for each line
        for lineString: Substring in self.settingString.split(separator: "\n") {
            
            /// if not comment
            if !lineString.hasPrefix("//") {
                
                let wordArray: [Substring] = lineString.split(separator: ":")
                /// get key, value
                if wordArray.count >= 2,
                    wordArray[0].lowercased().contains(key.lowercased()) {
                    return String(wordArray[1]).trimmingCharacters(in: [" "])
                }
            }
        }
        return ""
    }
    
    func resetCoreBlockSetting() {
        
        CoreBlockData.settings.DAS = self.intValue(forKey: "DAS", defaultValue: 6)
        CoreBlockData.settings.ARR = self.intValue(forKey: "ARR", defaultValue: 0)
        CoreBlockData.settings.Gravity = self.doubleValue(forKey: "Gravity", defaultValue: 0.0156)
        CoreBlockData.settings.SoftDrop = self.doubleValue(forKey: "SoftDrop", defaultValue: 200.0)
        CoreBlockData.settings.LockDelay = self.intValue(forKey: "LockDelay", defaultValue: 30)
        CoreBlockData.settings.Ghost = self.intValue(forKey: "Ghost", defaultValue: 1)
        CoreBlockData.settings.FinesseFaultRepeat = self.intValue(forKey: "FinesseFaultRepeat", defaultValue: 10)
    }
}

// MARK: - function control

extension GameManager {
    
    func keyCode(forKey key: String) -> Int {
        
        /// for each line
        for lineString: Substring in self.controlString.split(separator: "\n") {
            
            /// if not comment
            if !lineString.hasPrefix("//") {
                
                let wordArray: [Substring] = lineString.split(separator: ":")
                /// get key, value
                if wordArray.count >= 2,
                    wordArray[0].lowercased().contains(key.lowercased()) {
                    
                    let rawValue: String = String(wordArray[1]).trimmingCharacters(in: [" "])
                    return Int(rawValue) ?? -1
                }
            }
        }
        return -1
    }
    
    func setKeyCode(_ keyCode: Int, forKey key: String) {
        
        var newControlString: String = ""
        var hasFoundKey: Bool = false
        
        /// for each line
        for lineString: Substring in self.controlString.split(separator: "\n") {
            
            /// if not comment
            if !lineString.hasPrefix("//") {
                
                let wordArray: [Substring] = lineString.split(separator: ":")
                /// get key, value
                if wordArray.count >= 2,
                    wordArray[0].lowercased().contains(key.lowercased()) {
                    
                    newControlString += wordArray[0] + ": " + String(keyCode) + "\n"
                    hasFoundKey = true
                    continue
                }
            }
            newControlString += lineString + "\n"
        }
        
        if !hasFoundKey {
            newControlString += key + ": " + String(keyCode) + "\n"
        }
        
        self.controlString = newControlString
    }
    
    func resetCoreBlockControl() {
        
        CoreBlockData.binds.pause = self.keyCode(forKey: "pause")
        CoreBlockData.binds.moveLeft = self.keyCode(forKey: "moveLeft")
        CoreBlockData.binds.moveRight = self.keyCode(forKey: "moveRight")
        CoreBlockData.binds.softDrop = self.keyCode(forKey: "softDrop")
        CoreBlockData.binds.hardDrop = self.keyCode(forKey: "hardDrop")
        CoreBlockData.binds.hold = self.keyCode(forKey: "hold")
        CoreBlockData.binds.rotateRight = self.keyCode(forKey: "rotateRight")
        CoreBlockData.binds.rotateLeft = self.keyCode(forKey: "rotateLeft")
        CoreBlockData.binds.rotate180 = self.keyCode(forKey: "rotate180")
        CoreBlockData.binds.retry = self.keyCode(forKey: "retry")
        CoreBlockData.binds.stopRepeat = self.keyCode(forKey: "stopRepeat")
    }
    
    func allControlKeyNameArray() -> [String] {
        
        return [
            "pause",
            "moveLeft",
            "moveRight",
            "softDrop",
            "hardDrop",
            "hold",
            "rotateRight",
            "rotateLeft",
            "rotate180",
            "retry",
            "stopRepeat",
        ]
    }
}
