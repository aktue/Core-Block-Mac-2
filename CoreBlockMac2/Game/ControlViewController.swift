//
//  ControlViewController.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/12.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Cocoa

class ControlViewController: NSViewController {
    
    // MARK: - property
    
    //// view
    
    /// 按键检测 最上层 view
    var keyView: KeyView!
    /// change style in setting
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
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        GameManager.shared.resetCoreBlockControl()
    }
    
    override var preferredContentSize: NSSize {
        set { }
        get {
            return NSSize(width: 400, height: 600)
        }
    }
    
}

// MARK: - view

extension ControlViewController {
    
    func initView() {
        
        self.title = "Controlls"
        
        /// background color
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.cbm_gray_250.cgColor
        self.view.needsDisplay = true
        
        self.initKeyView()
        self.initGameSettingView()
    }
    
    /// 按键检测 最上层 view
    func initKeyView() {
        
        /// 当前活动方块 阴影
        self.keyView = KeyView(pressKeyHandler: { (down: Bool, event: NSEvent) in
            self.pressKey(down: down, event: event)
        })
        self.view.addSubview(self.keyView)
        self.keyView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.keyView.becomeFirstResponder()
    }
    
    func initGameSettingView() {
        
        var lastView: NSView!
        
        for index: Int in (0 ..< GameManager.shared.allControlKeyNameArray().count) {
        
            let kayName: String = GameManager.shared.allControlKeyNameArray()[index]
            
            let backView: NSView = NSView()
            backView.wantsLayer = true
            backView.layer?.backgroundColor = NSColor.cbm_gray_250.cgColor
            backView.needsDisplay = true
            self.view.addSubview(backView)
            backView.snp.makeConstraints { (make) in
                make.top.equalTo(lastView?.snp.bottom ?? 50)
                make.width.centerX.equalToSuperview()
                make.height.equalTo(50)
//                make.size.equalTo(NSMakeSize(300, 50))
            }
            
            /// left key name
            do {
                let textField: NSTextField = NSTextField()
                textField.stringValue = kayName
                textField.font = NSFont.init(name: "Menlo", size: 15)
                textField.alignment = NSTextAlignment.right
                textField.textColor = NSColor.cbm_black_500
                textField.backgroundColor = NSColor.cbm_clear
                textField.isBordered = false
                textField.isEditable = false
                textField.isSelectable = false
                backView.addSubview(textField)
                textField.snp.makeConstraints { (make) in
                    make.left.equalToSuperview()
                    make.centerY.equalToSuperview().offset(-1)
                    make.right.equalTo(backView.snp.centerX).offset(5)
                }
            }
            
            /// right key code
            do {
                let textField: NSTextField = NSTextField()
                textField.tag = self.baseKeyCodeTextFieldTag + index
                textField.stringValue = String(GameManager.shared.keyCode(forKey: kayName))
                textField.font = NSFont.init(name: "Menlo", size: 15)
                textField.alignment = NSTextAlignment.left
                textField.textColor = NSColor.cbm_black_500
                textField.backgroundColor = NSColor.cbm_clear
                textField.isBordered = false
                textField.isEditable = false
                textField.isSelectable = false
                backView.addSubview(textField)
                textField.snp.makeConstraints { (make) in
                    make.right.equalToSuperview()
                    make.centerY.equalToSuperview().offset(-1)
                    make.left.equalTo(backView.snp.centerX).offset(20)
                }
            }
            
            /// button
            do {
                let keyButton = NSButton()
                keyButton.tag = self.baseKeyButtonTag + index
                keyButton.title = kayName
                keyButton.titleTextColor = NSColor.cbm_clear
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
    }
}

// MARK: - function

extension ControlViewController {
    
    @objc func didClickKeyButton(_ button: NSButton) {
        
        self.currentKeyButton?.alphaValue = 0
        self.currentKeyButton = button
        self.currentKeyButton.alphaValue = 0.4
    }
    
    func pressKey(down: Bool, event: NSEvent) {
        
        if down, let button = self.currentKeyButton {
            
            GameManager.shared.setKeyCode(Int(event.keyCode), forKey: button.title)
            button.alphaValue = 0
            self.currentKeyButton = nil
            
            if let textField: NSTextField = self.view.viewWithTag(button.tag - self.baseKeyButtonTag + self.baseKeyCodeTextFieldTag) as? NSTextField {
                textField.stringValue = String(event.keyCode)
            }
        }
    }
}

extension NSButton {
    
    var titleTextColor : NSColor {
        get {
            let attrTitle = self.attributedTitle
            return attrTitle.attribute(NSAttributedStringKey.foregroundColor, at: 0, effectiveRange: nil) as! NSColor
        }
        
        set(newColor) {
            let attrTitle = NSMutableAttributedString(attributedString: self.attributedTitle)
            let titleRange = NSMakeRange(0, self.title.count)
            
            attrTitle.addAttributes([NSAttributedStringKey.foregroundColor: newColor], range: titleRange)
            self.attributedTitle = attrTitle
        }
    }
    
}
