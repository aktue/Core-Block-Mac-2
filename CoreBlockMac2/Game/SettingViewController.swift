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
    
    override var preferredContentSize: NSSize {
        set { }
        get {
            return NSSize(width: 400, height: 600)
        }
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
        
        var lastView: NSView!
        
        /// introduction
        do {
            let textField: NSTextField = NSTextField()
            textField.stringValue = "Edit settings below, it save automatically when close window."
            textField.font = NSFont.init(name: "Menlo", size: 20)
            textField.alignment = NSTextAlignment.center
            textField.maximumNumberOfLines = 9
            textField.textColor = NSColor.cbm_black_500
            textField.backgroundColor = NSColor.cbm_gray_125
            textField.isBordered = false
            textField.isEditable = false
            textField.isSelectable = false
            self.view.addSubview(textField)
            textField.snp.makeConstraints { (make) in
                make.top.equalTo(lastView?.snp.bottom ?? 5)
                make.left.right.equalToSuperview()
                make.width.equalTo(400)
            }
            
            lastView = textField
        }
        
        self.gameSettingTextField = NSTextView()
        self.gameSettingTextField.string = GameSetting.shared.settingString
        self.gameSettingTextField.font = NSFont.init(name: "Menlo", size: 20)
        self.gameSettingTextField.textColor = NSColor.cbm_gray_875
        self.gameSettingTextField.backgroundColor = NSColor.cbm_gray_250
        self.view.addSubview(self.gameSettingTextField)
        self.gameSettingTextField.snp.makeConstraints { (make) in
            make.top.equalTo(lastView.snp.bottom).offset(5)
            make.left.bottom.right.equalToSuperview()
        }
    }
}
