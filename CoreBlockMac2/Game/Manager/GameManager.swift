//
//  GameManager.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/11.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Cocoa

class GameManager {
    
    static var shared: GameManager = GameManager()
    
    var settingString: String {
        get {
            if let value = UserDefaults.standard.value(forKey: "GameManager.settingString") as? String,
                !value.isEmpty {
                return value
            } else {
                return """
                /// TODO: 全写上单位，现在先试一试
                DAS: 6
                ARR: 0
                /// TODO: 如果有，就固定值，单位G
                Gravity: 0.0156
                /// TODO: 单位G
                SoftDrop: 200.0
                LockDelay: 30
                Ghost: 1
                
                /// 窗口大小
                WindowWidth: 800
                WindowHeight: 600
                CellSize: 24
                """
            }
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "GameManager.settingString")
        }
    }
}

extension GameManager {
    
    func value(forKey key: String, defaultValue: Int) -> Int {
        
        let rawValue: String = self.rawValue(forKey: key)
        return Int(rawValue) ?? defaultValue
    }
    
    func value(forKey key: String, defaultValue: CGFloat) -> CGFloat {
        
        let rawValue: String = self.rawValue(forKey: key)
        return CGFloat(Double(rawValue) ?? Double(defaultValue))
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
}
