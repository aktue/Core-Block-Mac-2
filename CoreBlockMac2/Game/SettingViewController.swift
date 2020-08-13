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
        
        GameSetting.shared.settingString = self.gameSettingTextField.string
        GameSetting.shared.resetCoreBlockSetting()
    }
    
}

// MARK: - view

extension SettingViewController {
    
    func initView() {
        
        self.title = "Settings"
        
        /// background color
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.cbm_gray_125.cgColor
        self.view.needsDisplay = true
        
        self.initGameSettingView()
    }
    
    func initGameSettingView() {
        
        self.gameSettingTextField = NSTextView()
        self.gameSettingTextField.string = GameSetting.shared.settingString
        self.gameSettingTextField.font = NSFont.init(name: "Menlo", size: 20)
        self.gameSettingTextField.textColor = NSColor.cbm_gray_875
        self.gameSettingTextField.backgroundColor = NSColor.cbm_gray_125
        self.view.addSubview(self.gameSettingTextField)
        self.gameSettingTextField.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(400)
            make.height.equalTo(500)
        }
    }
}
