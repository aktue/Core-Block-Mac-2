//
//  GameViewController.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/11.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Cocoa

class GameViewController: NSViewController {
    
    // MARK: - property
    
    //// view
    
    /// 矩阵背景
    var stackGridView: StackGridView!
    /// 矩阵（显示已经存在的方块，不包括当前活动的）
    var stackView: BaseMinoView!
    /// hold
    var holdView: BaseMinoView!
    /// next
    var nextView: NextView!
    /// 当前活动方块 阴影
    var ghostView: BaseMinoView!
    /// 当前活动方块
    var activeView: BaseMinoView!
    /// 按键检测 最上层 view
    var keyView: KeyView!
    
    /// 游戏信息 开始 暂停
    var gameMessageTextField: NSTextField!
    /// line
    var lineTextField: NSTextField!
    /// finesse
    var finesseTextField: NSTextField!
    /// finesseFaultRepeat
    var finesseFaultRepeatTextField: NSTextField!
    /// pps
    var ppsTextField: NSTextField!
    /// time
    var timeTextField: NSTextField!

    
    // MARK: - life cycle
    
    override func loadView() {
        self.view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.initView()
        self.initCoreBlockController()
        
        GameManager.shared.resetCoreBlockSetting()
        GameManager.shared.resetCoreBlockControl()
        self.startGame()
    }
    
    override var preferredContentSize: NSSize {
        set { }
        get {
            return NSSize(width: GameManager.shared.windowWidth, height: GameManager.shared.windowHeight)
        }
    }
    
}

// MARK: - view

extension GameViewController {
    
    func initView() {
        
        /// background color
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.cbm_black_500.cgColor
        self.view.needsDisplay = true
        
        self.initBaseMinoView()
        self.initHoldAndNextView()
        self.initPieceView()
        self.initKeyView()
        self.initMessageView()
        self.initGameButton()
    }
    
    /// 矩阵（显示已经存在的方块，不包括当前活动的）
    func initBaseMinoView() {
        
        let minoSize: Int = GameManager.shared.minoSize
        
        /// 矩阵 背景
        self.stackGridView = StackGridView()
        self.view.addSubview(self.stackGridView)
        self.stackGridView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(minoSize * 10)
            make.height.equalTo(minoSize * 20)
        }
        
        /// 矩阵
        self.stackView = BaseMinoView()
        self.view.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.stackGridView)
        }
    }
    
    /// hold 和 next
    func initHoldAndNextView() {
        
        let minoSize: Int = GameManager.shared.minoSize
        
        let holdViewWidth: Int = minoSize * 4
        let holdViewHeight: Int = minoSize * 3
        
        let nextViewWidth: Int = minoSize * 4
        let nextViewHeight: Int = minoSize * 3 * 5
        
        /// hold
        self.holdView = BaseMinoView()
        self.view.addSubview(self.holdView)
        self.holdView.snp.makeConstraints { (make) in
            make.top.equalTo(self.stackGridView).offset(minoSize)
            make.right.equalTo(self.stackGridView.snp.left).offset(-minoSize / 2)
            make.width.equalTo(holdViewWidth)
            make.height.equalTo(holdViewHeight)
        }
        
        /// next
        self.nextView = NextView()
        self.view.addSubview(self.nextView)
        self.nextView.snp.makeConstraints { (make) in
            make.top.equalTo(self.stackGridView).offset(minoSize)
            make.left.equalTo(self.stackGridView.snp.right).offset(minoSize / 2)
            make.width.equalTo(nextViewWidth)
            make.height.equalTo(nextViewHeight)
        }
    }
    
    /// 当前活动方块
    func initPieceView() {
        
        /// 当前活动方块 阴影
        self.ghostView = BaseMinoView()
        self.view.addSubview(self.ghostView)
        self.ghostView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.stackGridView)
        }
        
        /// 当前活动方块
        self.activeView = BaseMinoView()
        self.view.addSubview(self.activeView)
        self.activeView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.stackGridView)
        }
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
    
    /// 状态信息
    func initMessageView() {
        
        let minoSize: Int = GameManager.shared.minoSize
        var lastView: NSView!
        
        /// 游戏信息 开始 暂停
        self.gameMessageTextField = self.textField(fontSize: 35)
        self.gameMessageTextField.textColor = NSColor.cbm_white_500
        self.gameMessageTextField.backgroundColor = NSColor.cbm_gray_500
        self.gameMessageTextField.alignment = NSTextAlignment.center
        self.gameMessageTextField.snp.makeConstraints { (make) in
            make.center.width.equalTo(self.stackGridView)
            make.height.equalTo(60)
        }
        
        /// line
        do {
            self.lineTextField = self.textField(fontSize: 40)
            self.lineTextField.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.holdView)
            }
            
            lastView = self.textField(withTitle: "Line", fontSize: 15)
            lastView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.lineTextField)
                make.top.equalTo(self.lineTextField.snp.bottom).offset(-10)
            }
        }
        
        /// finesse
        do {
            self.finesseTextField = self.textField(fontSize: 40)
            self.finesseTextField.snp.makeConstraints { (make) in
                make.centerX.equalTo(lastView)
                make.top.equalTo(lastView.snp.bottom).offset(minoSize / 2)
            }
            
            lastView = self.textField(withTitle: "Finesse", fontSize: 15)
            lastView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.finesseTextField)
                make.top.equalTo(self.finesseTextField.snp.bottom).offset(-10)
            }
        }
        
        /// finesseFaultRepeat
        do {
            self.finesseFaultRepeatTextField = self.textField(fontSize: 20)
            self.finesseFaultRepeatTextField.snp.makeConstraints { (make) in
                make.centerX.equalTo(lastView)
                make.top.equalTo(lastView.snp.bottom).offset(minoSize / 2)
            }
            
            lastView = self.textField(withTitle: "Repeat", fontSize: 15)
            lastView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.finesseFaultRepeatTextField)
                make.top.equalTo(self.finesseFaultRepeatTextField.snp.bottom).offset(-10)
            }
        }
        
        /// pps
        do {
            self.ppsTextField = self.textField(fontSize: 20)
            self.ppsTextField.snp.makeConstraints { (make) in
                make.centerX.equalTo(lastView)
                make.top.equalTo(lastView.snp.bottom).offset(minoSize / 2)
            }
            
            lastView = self.textField(withTitle: "PPS", fontSize: 15)
            lastView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.ppsTextField)
                make.top.equalTo(self.ppsTextField.snp.bottom).offset(-5)
            }
        }
        
        /// time
        do {
            self.timeTextField = self.textField(fontSize: 20)
            self.timeTextField.snp.makeConstraints { (make) in
                make.centerX.equalTo(lastView)
                make.top.equalTo(lastView.snp.bottom).offset(minoSize / 2)
            }
            
            lastView = self.textField(withTitle: "", fontSize: 15)
            lastView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.timeTextField)
                make.top.equalTo(self.timeTextField.snp.bottom).offset(-5)
            }
        }
        
        /// settings button
        do {
            let settingButton = self.button(withTitle: "Settings", action: #selector(GameViewController.didClickSettingButton))
            settingButton.snp.makeConstraints { (make) in
                make.top.equalTo(lastView.snp.bottom).offset(5)
                make.centerX.equalTo(lastView)
                make.size.equalTo(CGSize(width: 110, height: 25))
            }
            lastView = settingButton
        }
        
        /// controls button
        do {
            let controlButton = self.button(withTitle: "Controlls", action: #selector(GameViewController.didClickControlButton))
            controlButton.snp.makeConstraints { (make) in
                make.top.equalTo(lastView.snp.bottom).offset(5)
                make.centerX.equalTo(lastView)
                make.size.equalTo(CGSize(width: 110, height: 25))
            }
            lastView = controlButton
        }
        
        lastView?.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.stackGridView.snp.bottom)
        })
    }
    
    func initGameButton() {
        
        var lastView: NSView!
        
        let gameTypeArray: [(title: String, type: Int)] = [
            (
                title: "Sprint",
                type: 0
            ),
            (
                title: "Sprint 1K",
                type: 1
            ),
            (
                title: "Replay",
                type: -1
            ),
        ]
        
        /// game button
        for item: (title: String, type: Int) in gameTypeArray {
            
            let gameButton = self.button(withTitle: item.title, tag: item.type, action: #selector(GameViewController.didClickGameButton))
            gameButton.snp.makeConstraints { (make) in
                if let lastView = lastView {
                    make.top.equalTo(lastView.snp.bottom).offset(5)
                    make.centerX.equalTo(lastView)
                }
                make.size.equalTo(CGSize(width: 110, height: 25))
            }
            lastView = gameButton
        }
        
        lastView?.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.nextView)
            make.bottom.equalTo(self.stackGridView.snp.bottom)
        })
    }
    
    func textField(withTitle title: String = "", fontSize: CGFloat) -> NSTextField {
        
        let textField: NSTextField = NSTextField()
        textField.stringValue = title
        textField.font = NSFont.init(name: "Menlo", size: fontSize)
        textField.textColor = NSColor.cbm_gray_250
        textField.backgroundColor = NSColor.cbm_clear
        textField.isBordered = false
        textField.isEditable = false
        textField.isSelectable = false
        self.view.addSubview(textField)
        return textField
    }
    
    func button(withTitle title: String = "", fontSize: CGFloat = 17, tag: Int = 0, action: Selector) -> NSView {
        
        let textField: NSTextField = self.textField(withTitle: title, fontSize: fontSize)
        textField.textColor = NSColor.cbm_white_500
        textField.alignment = NSTextAlignment.center
        textField.backgroundColor = NSColor.cbm_gray_500
        self.view.addSubview(textField)
        
        let button = NSButton()
        button.title = ""
        button.tag = tag
        button.alphaValue = 0.2
        button.target = self
        button.action = action
        textField.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return textField
    }
}


// MARK: - function

extension GameViewController {
    
    func initCoreBlockController() {
        
        CoreBlockController.shared.delegate = self
    }
    
    func startGame(gameType: Int = 0) {
        
        CoreBlockController.shared.new(gameType: gameType)
    }
    
    func pressKey(down: Bool, event: NSEvent) {
        
        CoreBlockController.shared.pressKey(down: down, keyCode: Int(event.keyCode))
    }
    
    @objc func didClickSettingButton() {
        self.presentAsModalWindow(SettingViewController())
    }
    
    @objc func didClickControlButton() {
        self.presentAsModalWindow(ControlViewController())
    }
    
    @objc func didClickGameButton(button: NSButton) {
        self.startGame(gameType: button.tag)
    }

}


// MARK: - CoreBlockControllerProtocol

extension GameViewController: CoreBlockControllerProtocol {
    
    func draw(_ drawInfo: CoreBlockController.DrawInfo) {
        
        switch drawInfo.type {
            
        case .hold:
            self.holdView.draw(drawInfo: drawInfo)
        case .stack:
            self.stackView.draw(drawInfo: drawInfo)
        case .active:
            self.activeView.draw(drawInfo: drawInfo)
        case .ghost:
            self.ghostView.draw(drawInfo: drawInfo)
        default:
            break
        }
    }
    
    func clear(_ type: CoreBlockController.DrawType) {
        
        switch type {
            
        case .hold:
            self.holdView.draw(drawInfo: nil)
        case .stack:
            self.stackView.draw(drawInfo: nil)
        case .active:
            self.activeView.draw(drawInfo: nil)
        case .ghost:
            self.ghostView.draw(drawInfo: nil)
        case .preview:
            self.nextView.draw(drawInfoArray: nil)
        }
    }
    
    func draw(_ drawInfoArray: [CoreBlockController.DrawInfo]) {
        self.nextView.draw(drawInfoArray: drawInfoArray)
    }
    
    func message(_ message: String, _ type: CoreBlockController.MessageType) {
        
        switch type {
        case .game:
            self.gameMessageTextField.stringValue = message
            self.gameMessageTextField.isHidden = message.isEmpty
        case .finesse:
            self.finesseTextField.stringValue = message
        case .pps:
            self.ppsTextField.stringValue = message
        case .statsLines:
            self.lineTextField.stringValue = message
        case .statsTime:
            self.timeTextField.stringValue = message
        case .finesseFaultRepeat:
            self.finesseFaultRepeatTextField.stringValue = message
        default:
            break
        }
    }
    
}
