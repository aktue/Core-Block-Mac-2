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
    
    /// change button color after click
    var currentKeyButton: NSButton!
    
    
    //// data
    let baseKeyButtonTag: Int = 1000
    let baseKeyCodeTextFieldTag: Int = 2000
    
    // MARK: - life cycle
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.initView()
        self.addKeyEventMonitor()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        GameSetting.shared.resetCoreBlockControl()
    }
    
    override func pressKey(down: Bool, event: NSEvent) {
        
        if down, let button = self.currentKeyButton {
            
            GameSetting.shared.setKeyCode(Int(event.keyCode), forKey: button.title)
            button.alphaValue = 0
            self.currentKeyButton = nil
            
            if let textField: NSTextField = self.view.viewWithTag(button.tag - self.baseKeyButtonTag + self.baseKeyCodeTextFieldTag) as? NSTextField {
                textField.stringValue = String(event.keyCode)
            }
        }
    }
    
}

// MARK: - view

extension ControlViewController {
    
    func initView() {
        
        self.title = "Controlls"
        
        /// background color
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.cbm_gray_125.cgColor
        self.view.needsDisplay = true
        
        self.initGameSettingView()
    }
    
    func initGameSettingView() {
        
        var lastView: NSView!
        
        /// introduction
        lastView = self.view
            .cbm_addTextField(withTitle: "Click items below, then press a key to bind them.", textColor: NSColor.cbm_black_500, fontSize: 20, maximumNumberOfLines: 100, backgroundColor: NSColor.cbm_gray_125)
            .cbm_snpMakeConstraints { (make) in
                make.top.equalTo(lastView?.snp.bottom ?? 5)
                make.left.right.equalToSuperview()
                make.width.equalTo(400)
        }
        
        /// button
        for index: Int in (0 ..< GameSetting.shared.allControlKeyNameArray().count) {
        
            let kayName: String = GameSetting.shared.allControlKeyNameArray()[index]
            
            let backView: NSView = self.view
                .cbm_addSubview(withBackgroundColor: NSColor.cbm_gray_250)
                .cbm_snpMakeConstraints { (make) in
                make.top.equalTo(lastView?.snp.bottom ?? 0).offset(5)
                make.left.right.centerX.equalToSuperview()
                make.height.equalTo(50)
                make.width.equalTo(400)
            }
            
            /// left key name
            backView
                .cbm_addTextField(withTitle: kayName, textColor: NSColor.cbm_black_500, fontSize: 20, backgroundColor: NSColor.cbm_clear)
                .cbm_snpMakeConstraints { (make) in
                    make.centerY.equalToSuperview().offset(-1)
                    make.right.equalTo(backView.snp.centerX).offset(5)
            }
            
            /// right key code
            backView
                .cbm_addTextField(withTitle: String(GameSetting.shared.keyCode(forKey: kayName)), textColor: NSColor.cbm_black_500, fontSize: 20, backgroundColor: NSColor.cbm_clear, tag: self.baseKeyCodeTextFieldTag + index)
                .cbm_snpMakeConstraints { (make) in
                    make.centerY.equalToSuperview().offset(-1)
                    make.left.equalTo(backView.snp.centerX).offset(20)
            }
            
            /// button
            do {
                let keyButton = NSButton()
                keyButton.tag = self.baseKeyButtonTag + index
                keyButton.title = kayName
                keyButton.cbm_titleTextColor = NSColor.cbm_clear
                keyButton.isBordered = false
                keyButton.wantsLayer = true
                keyButton.layer?.backgroundColor = NSColor.cbm_gray_500.cgColor
                keyButton.alphaValue = 0
                keyButton.target = self
                keyButton.action = #selector(ControlViewController.didClickKeyButton)
                backView.addSubview(keyButton)
                keyButton.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
            
            lastView = backView
        }
        
        lastView?.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview()
        })
    }
}

// MARK: - function

extension ControlViewController {
    
    @objc func didClickKeyButton(_ button: NSButton) {
        
        self.currentKeyButton?.alphaValue = 0
        self.currentKeyButton = button
        self.currentKeyButton.alphaValue = 0.2
    }
}
