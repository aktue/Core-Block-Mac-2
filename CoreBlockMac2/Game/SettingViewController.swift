//
//  SettingViewController.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/12.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Cocoa

class SettingViewController: NSViewController {
    
    // MARK: - property
    
    //// view
    
    /// game setting
    var gameSettingTextField: NSTextView!
    
    
    // MARK: - life cycle
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.initView()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        GameManager.shared.settingString = self.gameSettingTextField.string
        GameManager.shared.resetCoreBlockSetting()
    }
    
    override var preferredContentSize: NSSize {
        set { }
        get {
            return NSSize(width: GameManager.shared.cgFloatValue(forKey: "WindowWidth", defaultValue: 800.0), height: GameManager.shared.cgFloatValue(forKey: "WindowHeight", defaultValue: 600.0))
        }
    }
    
}

// MARK: - view

extension SettingViewController {
    
    func initView() {
        
        self.title = "Settings"
        
        /// background color
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.cbm_black_500.withAlphaComponent(0.5).cgColor
        self.view.needsDisplay = true
        
        self.initGameSettingView()
    }
    
    /// 矩阵（显示已经存在的方块，不包括当前活动的）
    func initGameSettingView() {
        
        let backView: NSView = NSView()
        self.view.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(self.view.snp.centerX)
        }
        
        self.gameSettingTextField = NSTextView()
        self.gameSettingTextField.string = GameManager.shared.settingString
        self.gameSettingTextField.font = NSFont.init(name: "Menlo", size: 15)
        self.gameSettingTextField.textColor = NSColor.cbm_gray_875
        self.gameSettingTextField.backgroundColor = NSColor.cbm_white_500
        backView.addSubview(self.gameSettingTextField)
        self.gameSettingTextField.snp.makeConstraints { (make) in
            make.edges.equalTo(NSEdgeInsetsMake(50, 50, 50, 50))
        }
    }
}
