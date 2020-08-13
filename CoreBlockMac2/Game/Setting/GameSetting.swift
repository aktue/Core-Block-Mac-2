//
//  GameSetting.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/11.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Cocoa

class GameSetting {
    
    // MARK: - property
    
    static var shared: GameSetting = GameSetting()
    
    /// doesn't change value until restart app
    var windowWidth: CGFloat = 0
    var windowHeight: CGFloat = 0
    var minoSize: Int = 0
    
    var settingString: String {
        
        get {
            if let value: String = UserDefaults.standard.value(forKey: "GameSetting.settingString") as? String,
                !value.isEmpty {
                
                return value
                
            } else {
                
                return """
                
                // Edit settings below
                // FPS: 100
                
                DAS: 9 // frame
                ARR: 0 // frame
                
                Gravity: 0.01 // cell/frame
                SoftDrop: 100.0 // cell/frame
                
                LockDelay: 50 // frame
                
                Ghost: 1 // 1: on, 0: off
                FinesseFaultRepeat: 10
                
                // window size
                WindowWidth: 800
                WindowHeight: 600
                """
            }
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "GameSetting.settingString")
        }
    }
    
    var controlDict: [String: Int] {
        
        get {
            if let value: [String: Int] = UserDefaults.standard.value(forKey: "GameSetting.controlDict") as? [String: Int],
                !value.isEmpty {
                
                return value
                
            } else {
                
                return [
                    /// q
                    "pause": 12,
                    /// j
                    "moveLeft": 38,
                    /// l
                    "moveRight": 37,
                    /// k
                    "softDrop": 40,
                    /// i
                    "hardDrop": 34,
                    /// space
                    "hold": 49,
                    /// f
                    "rotateRight": 3,
                    /// d
                    "rotateLeft": 2,
                    /// s
                    "rotate180": 1,
                    /// r
                    "retry": 15,
                    /// w
                    "stopRepeat": 13,
                ]
            }
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "GameSetting.controlDict")
        }
    }
    
    init() {
        
        self.windowWidth = self.cgFloatValue(forKey: "WindowWidth", defaultValue: 800.0)
        self.windowHeight = self.cgFloatValue(forKey: "WindowHeight", defaultValue: 600.0)
        self.minoSize = Int(min(self.windowWidth, self.windowHeight) / 25)
    }
}

// MARK: - function setting

extension GameSetting {
    
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
        for var lineString: Substring in self.settingString.split(separator: "\n") {
            
            /// remove comment
            if let index: String.Index = (lineString.range(of: "//")?.lowerBound) {
                
                lineString = lineString.prefix(upTo: index)
            }
            
            if !lineString.isEmpty {
                
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

extension GameSetting {
    
    func keyCode(forKey key: String) -> Int {
        
        return self.controlDict[key] ?? -1
    }
    
    func setKeyCode(_ keyCode: Int, forKey key: String) {
        
        self.controlDict[key] = keyCode
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
            "moveLeft",
            "moveRight",
            "softDrop",
            "hardDrop",
            "rotateLeft",
            "rotateRight",
            "rotate180",
            "hold",
            "pause",
            "retry",
            "stopRepeat",
        ]
    }
}
