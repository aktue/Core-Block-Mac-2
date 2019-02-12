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
    var stackView: StackView!
    /// hold
    var holdView: HoldView!
    /// next
    var nextView: NextView!
    /// 当前活动方块 阴影
    var ghostView: ActiveView!
    /// 当前活动方块
    var activeView: ActiveView!
    /// 按键检测 最上层 view
    var keyView: KeyView!
    
    /// 游戏信息 开始 暂停
    var gameMessageTextField: NSTextField!
    /// line
    var lineTextField: NSTextField!
    /// finesse
    var finesseTextField: NSTextField!
    /// pps
    var ppsTextField: NSTextField!
    /// time
    var timeTextField: NSTextField!
    
    /// 设置
//    @property (nonatomic, strong) SettingViewController *settingViewController
//    @property (nonatomic, strong) NSView *settingView

    
    // MARK: - life cycle
    
    override func loadView() {
        self.view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.initView()
        self.initCoreBlockController()
        self.startGame()
    }
    
    override var preferredContentSize: NSSize {
        set { }
        get {
            return NSSize(width: GameManager.shared.value(forKey: "WindowWidth", defaultValue: 800.0), height: GameManager.shared.value(forKey: "WindowHeight", defaultValue: 600.0))
        }
    }
    
}

// MARK: - view

extension GameViewController {
    
    func initView() {
        
        /// 设置背景色
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.cbm_black_500.cgColor
        self.view.needsDisplay = true
        
        self.initStackView()
        self.initHoldAndNextView()
        self.initPieceView()
        self.initKeyView()
        self.initMessageView()
        
//        self.initSettingView()
    }
    
    /// 矩阵（显示已经存在的方块，不包括当前活动的）
    func initStackView() {
        
        let cellSize: Int = GameManager.shared.value(forKey: "CellSize", defaultValue: 24)
        
        /// 矩阵 背景
        self.stackGridView = StackGridView()
        self.view.addSubview(self.stackGridView)
        self.stackGridView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(cellSize * 10)
            make.height.equalTo(cellSize * 20)
        }
        
        /// 矩阵
        self.stackView = StackView()
        self.view.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.stackGridView)
        }
    }
    
    /// hold 和 next
    func initHoldAndNextView() {
        
        let cellSize: Int = GameManager.shared.value(forKey: "CellSize", defaultValue: 24)
        
        let holdViewWidth: Int = cellSize * 5
        let holdViewHeight: Int = cellSize * 3
        
        let nextViewWidth: Int = cellSize * 5
        let nextViewHeight: Int = cellSize * 18
        
        /// hold
        self.holdView = HoldView()
        self.view.addSubview(self.holdView)
        self.holdView.snp.makeConstraints { (make) in
            make.top.equalTo(self.stackGridView).offset(cellSize)
            make.right.equalTo(self.stackGridView.snp.left).offset(-cellSize / 2)
            make.width.equalTo(holdViewWidth)
            make.height.equalTo(holdViewHeight)
        }
        
        /// next
        self.nextView = NextView()
        self.view.addSubview(self.nextView)
        self.nextView.snp.makeConstraints { (make) in
            make.top.equalTo(self.stackGridView).offset(cellSize)
            make.left.equalTo(self.stackGridView.snp.right)
            make.width.equalTo(nextViewWidth)
            make.height.equalTo(nextViewHeight)
        }
    }
    
    /// 当前活动方块
    func initPieceView() {
        
        /// 当前活动方块 阴影
        self.ghostView = ActiveView()
        self.view.addSubview(self.ghostView)
        self.ghostView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.stackGridView)
        }
        
        /// 当前活动方块
        self.activeView = ActiveView()
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
        
        let cellSize: Int = GameManager.shared.value(forKey: "CellSize", defaultValue: 24)
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
                make.top.equalTo(lastView.snp.bottom).offset(cellSize / 2)
            }
            
            lastView = self.textField(withTitle: "Finesse", fontSize: 15)
            lastView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.finesseTextField)
                make.top.equalTo(self.finesseTextField.snp.bottom).offset(-10)
            }
        }
        
        /// pps
        do {
            self.ppsTextField = self.textField(fontSize: 20)
            self.ppsTextField.snp.makeConstraints { (make) in
                make.centerX.equalTo(lastView)
                make.top.equalTo(lastView.snp.bottom).offset(cellSize / 2)
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
                make.top.equalTo(lastView.snp.bottom).offset(cellSize / 2)
            }
            
            lastView = self.textField(withTitle: "", fontSize: 15)
            lastView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.timeTextField)
                make.top.equalTo(self.timeTextField.snp.bottom).offset(-5)
            }
        }
        
        lastView?.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.stackGridView.snp.bottom).offset(-cellSize / 2)
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
}


// MARK: - function

extension GameViewController {
    
    func initCoreBlockController() {
        
        CoreBlockController.shared.delegate = self
    }
    
    func startGame() {
        
        CoreBlockController.shared.new(gameType: 0)
    }
    
    func pressKey(down: Bool, event: NSEvent) {
        
        CoreBlockController.shared.pressKey(down: down, keyCode: Int(event.keyCode))
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
        default:
            break
        }
    }
    
}
