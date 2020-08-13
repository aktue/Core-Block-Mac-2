//
//  ControlViewController.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/12.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Cocoa

class ControlViewController: BaseViewController {
    
    // MARK: - property
    
    //// view
    /// "Press key for: xxx"
    var titleTextField: NSTextField!
    
    
    //// data
    var currentKeyIndex: Int = 0
    
    // MARK: - life cycle
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.initView()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        self.addKeyEventMonitor()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        self.removeKeyEventMonitor()
        GameSetting.shared.resetCoreBlockControl()
    }
    
    override func pressKey(down: Bool, event: NSEvent) {
        
        if down, self.hasFocus() {
            
            let kayName: String = GameSetting.shared.allControlKeyNameArray()[self.currentKeyIndex]
            GameSetting.shared.setKeyCode(Int(event.keyCode), forKey: kayName)
            
            self.currentKeyIndex += 1
            if self.currentKeyIndex < GameSetting.shared.allControlKeyNameArray().count {
                self.updateTitleTextField()
            } else {
                self.dismiss(nil)
            }
        }
    }
    
}

// MARK: - view

extension ControlViewController {
    
    func initView() {
        
        self.title = "Controls"
        
        /// background color
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.cbm_gray_125.cgColor
        self.view.needsDisplay = true
        
        self.initGameSettingView()
    }
    
    func initGameSettingView() {
        
        self.view.cbm_snpMakeConstraints { (make) in
            make.width.equalTo(400)
            make.height.equalTo(200)
        }
        
        self.titleTextField = (self.view
            .cbm_addTextField(withTitle: "", textColor: NSColor.cbm_black_500, fontSize: 20, maximumNumberOfLines: 0, backgroundColor: NSColor.cbm_gray_125)
            .cbm_snpMakeConstraints { (make) in
                make.center.equalToSuperview()
            } as! NSTextField)
        
        self.updateTitleTextField()
    }
    
    func updateTitleTextField() {
        
        let kayName: String = GameSetting.shared.allControlKeyNameArray()[self.currentKeyIndex]
        self.titleTextField.stringValue = "Press key for: \(kayName)"
    }
}

// MARK: - function

extension ControlViewController {
    
}
