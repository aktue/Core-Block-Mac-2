//
//  GameViewController.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/11.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Cocoa

class GameViewController: BaseViewController {
    
    // MARK: - property
    
    //// view
    
    var stackGridView: StackGridView!
    var stackView: BaseMinoView!
    
    var ghostView: BaseMinoView!
    var activeView: BaseMinoView!
    
    var holdView: BaseMinoView!
    var nextView: NextView!
    
    var gameMessageTextField: NSTextField!
    var lineTextField: NSTextField!
    var bigLineTextField: NSTextField!
    var finesseTextField: NSTextField!
    var finesseFaultRepeatTextField: NSTextField!
    var ppsTextField: NSTextField!
    var kppTextField: NSTextField!
    var timeTextField: NSTextField!

    //// data
    let minoSize: Int = GameSetting.shared.minoSize
    
    // MARK: - life cycle
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.initView()
        self.addKeyEventMonitor()
        
        self.initCoreBlockController()
        self.startGame()
    }
    
    override func pressKey(down: Bool, event: NSEvent) {
        
        CoreBlockController.shared.pressKey(down: down, keyCode: Int(event.keyCode))
    }
    
}

// MARK: - view

extension GameViewController {
    
    func initView() {
        
        /// background color
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.cbm_black_500.cgColor
        self.view.needsDisplay = true
        
        self.view.snp.makeConstraints { (make) in
            make.size.equalTo(NSSize(width: GameSetting.shared.windowWidth, height: GameSetting.shared.windowHeight))
        }
        
        self.initGameView()
        self.initMessageView()
        
        self.initSettingButton()
    }
    
    func initGameView() {
        
        /// stack
        do {
            self.stackGridView = self.view.cbm_addSubview(StackGridView())
            self.stackGridView.cbm_snpMakeConstraints { (make) in
                    make.right.equalTo(self.view.snp.centerX).offset(self.minoSize)
                    make.centerY.equalToSuperview()
                    make.width.equalTo(self.minoSize * 10)
                    make.height.equalTo(self.minoSize * 20)
            }
            
            self.stackView = self.view.cbm_addSubview(BaseMinoView())
            self.stackView.cbm_snpMakeConstraints { (make) in
                make.edges.equalTo(self.stackGridView)
            }
        }
        
        /// ghost & active piece
        do {
            self.ghostView = self.view.cbm_addSubview(BaseMinoView())
            self.ghostView.snp.makeConstraints { (make) in
                make.edges.equalTo(self.stackView)
            }
            
            self.activeView = self.view.cbm_addSubview(BaseMinoView())
            self.activeView.snp.makeConstraints { (make) in
                make.edges.equalTo(self.stackView)
            }
        }
        
        /// hold & next
        do {
            self.holdView = self.view.cbm_addSubview(BaseMinoView())
            self.holdView.snp.makeConstraints { (make) in
                make.top.equalTo(self.stackView).offset(self.minoSize)
                make.right.equalTo(self.stackView.snp.left).offset(-self.minoSize / 2)
                make.width.equalTo(self.minoSize * 4)
                make.height.equalTo(self.minoSize * 3)
            }
            
            self.nextView = self.view.cbm_addSubview(NextView())
            self.nextView.snp.makeConstraints { (make) in
                make.top.equalTo(self.stackView).offset(self.minoSize)
                make.left.equalTo(self.stackView.snp.right).offset(self.minoSize / 2)
                make.width.equalTo(self.minoSize * 4)
                make.height.equalTo(self.minoSize * 3 * 5)
            }
        }
        
    }
    
    func initMessageView() {
        
        /// game message (in stack view)
        do {
            self.gameMessageTextField = self.view.cbm_addTextField(fontSize: 35)
            self.gameMessageTextField.textColor = NSColor.cbm_white_500
            self.gameMessageTextField.backgroundColor = NSColor.cbm_gray_500
            self.gameMessageTextField.alignment = NSTextAlignment.center
            self.gameMessageTextField.snp.makeConstraints { (make) in
                make.center.width.equalTo(self.stackView)
                make.height.equalTo(60)
            }
        }
        
        /// big line message (under next view)
        do {
            self.bigLineTextField = (self.view
                .cbm_addTextField(fontSize: 45)
                .cbm_snpMakeConstraints { (make) in
                    make.top.equalTo(self.nextView.snp.bottom)
                    make.left.equalTo(self.stackView.snp.right).offset(minoSize / 2)
            } as! NSTextField)
        }
        
        var lastView: NSView!
        let titleFontSize: CGFloat = 15
        let contentFontSize: CGFloat = 20
        let outerOffset: CGFloat = 10
        let innerOffset: CGFloat = -5
        
        /// line
        do {
            lastView = self.view
                .cbm_addTextField(withTitle: "Line", fontSize: titleFontSize)
                .cbm_snpMakeConstraints { (make) in
                make.top.equalTo(self.stackView).offset(minoSize)
                    
                make.left.equalTo(self.nextView.snp.right).offset(minoSize)
            }
            
            lastView = self.view
                .cbm_addTextField(fontSize: contentFontSize)
                .cbm_snpMakeConstraints { (make) in
                make.top.equalTo(lastView.snp.bottom).offset(innerOffset)
                make.left.equalTo(lastView)
            }
            self.lineTextField = (lastView as! NSTextField)
        }
        
        /// finesse
        do {
            lastView = self.view
                .cbm_addTextField(withTitle: "Finesse", fontSize: titleFontSize)
                .cbm_snpMakeConstraints { (make) in
                make.top.equalTo(lastView.snp.bottom).offset(outerOffset)
                make.left.equalTo(lastView)
            }
            
            lastView = self.view
                .cbm_addTextField(fontSize: contentFontSize)
                .cbm_snpMakeConstraints { (make) in
                make.top.equalTo(lastView.snp.bottom).offset(innerOffset)
                make.left.equalTo(lastView)
            }
            self.finesseTextField = (lastView as! NSTextField)
        }
        
        /// finesseFaultRepeat
        do {
            lastView = self.view
                .cbm_addTextField(withTitle: "Repeat Times", fontSize: titleFontSize)
                .cbm_snpMakeConstraints { (make) in
                make.top.equalTo(lastView.snp.bottom).offset(outerOffset)
                make.left.equalTo(lastView)
            }
            
            lastView = self.view
                .cbm_addTextField(fontSize: contentFontSize)
                .cbm_snpMakeConstraints { (make) in
                make.top.equalTo(lastView.snp.bottom).offset(innerOffset)
                make.left.equalTo(lastView)
            }
            self.finesseFaultRepeatTextField = (lastView as! NSTextField)
        }
        
        /// pps
        do {
            lastView = self.view
                .cbm_addTextField(withTitle: "PPS", fontSize: titleFontSize)
                .cbm_snpMakeConstraints { (make) in
                make.top.equalTo(lastView.snp.bottom).offset(outerOffset)
                make.left.equalTo(lastView)
            }
            
            lastView = self.view
                .cbm_addTextField(fontSize: contentFontSize)
                .cbm_snpMakeConstraints { (make) in
                make.top.equalTo(lastView.snp.bottom).offset(innerOffset)
                make.left.equalTo(lastView)
            }
            self.ppsTextField = (lastView as! NSTextField)
        }
        
        /// kpp
        do {
            lastView = self.view
                .cbm_addTextField(withTitle: "KPP", fontSize: titleFontSize)
                .cbm_snpMakeConstraints { (make) in
                make.top.equalTo(lastView.snp.bottom).offset(outerOffset)
                make.left.equalTo(lastView)
            }
            
            lastView = self.view
                .cbm_addTextField(fontSize: contentFontSize)
                .cbm_snpMakeConstraints { (make) in
                make.top.equalTo(lastView.snp.bottom).offset(innerOffset)
                make.left.equalTo(lastView)
            }
            self.kppTextField = (lastView as! NSTextField)
        }
        
        /// time
        do {
            lastView = self.view
                .cbm_addTextField(withTitle: "Time", fontSize: titleFontSize)
                .cbm_snpMakeConstraints { (make) in
                make.top.equalTo(lastView.snp.bottom).offset(outerOffset)
                make.left.equalTo(lastView)
            }
            
            lastView = self.view
                .cbm_addTextField(fontSize: contentFontSize)
                .cbm_snpMakeConstraints { (make) in
                make.top.equalTo(lastView.snp.bottom).offset(innerOffset)
                make.left.equalTo(lastView)
            }
            self.timeTextField = (lastView as! NSTextField)
        }
    }
    
    func initSettingButton() {
        
        var lastView: NSView!
        let buttonSize: CGSize = CGSize(width: 110, height: 30)
        let outerOffset: CGFloat = 10
        
        /// game type button
        do {
            let gameItemArray: [(title: String, type: Int)] = [
                (title: "Sprint", type: 0),
                (title: "Sprint 1K", type: 1),
                (title: "Replay", type: -1),
                ]
            
            for item: (title: String, type: Int) in gameItemArray {
                
                lastView = self.view
                    .cbm_addButton(
                        withTitle: item.title,
                        textColor: NSColor.cbm_gray_064,
                        fontSize: 16,
                        backgroundColor: NSColor.cbm_gray_500,
                        tag: item.type,
                        target: self,
                        action: #selector(GameViewController.didClickGameButton)
                    )
                    .cbm_snpMakeConstraints { (make) in
                        if let lastView = lastView {
                            make.top.equalTo(lastView.snp.bottom).offset(outerOffset)
                            make.centerX.equalTo(lastView)
                        }
                        make.size.equalTo(buttonSize)
                }
            }
        }
        
        /// setting button
        do {
            let settingItemArray: [(title: String, action: Selector)] = [
                (title: "Settings", action: #selector(GameViewController.didClickSettingButton)),
                (title: "Controlls", action: #selector(GameViewController.didClickControlButton)),
                ]
            
            for item: (title: String, action: Selector) in settingItemArray {
                
                lastView = self.view
                    .cbm_addButton(
                        withTitle: item.title,
                        textColor: NSColor.cbm_gray_064,
                        fontSize: 16,
                        backgroundColor: NSColor.cbm_gray_500,
                        target: self,
                        action: item.action
                    )
                    .cbm_snpMakeConstraints { (make) in
                        if let lastView = lastView {
                            make.top.equalTo(lastView.snp.bottom).offset(outerOffset)
                            make.centerX.equalTo(lastView)
                        }
                        make.size.equalTo(buttonSize)
                }
            }
        }
        
        lastView?.snp.makeConstraints({ (make) in
            make.right.equalTo(self.stackView.snp.left).offset(-minoSize)
            make.bottom.equalTo(self.stackView.snp.bottom)
        })
    }
}


// MARK: - function

extension GameViewController {
    
    func initCoreBlockController() {
        
        CoreBlockController.shared.delegate = self
        GameSetting.shared.resetCoreBlockSetting()
        GameSetting.shared.resetCoreBlockControl()
    }
    
    func startGame(gameType: Int = 0) {
        
        CoreBlockController.shared.new(gameType: gameType)
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
        
        DispatchQueue.main.async {
            
            switch type {
            case .game:
                self.gameMessageTextField.stringValue = message
                self.gameMessageTextField.isHidden = message.isEmpty
            case .finesse:
                self.finesseTextField.stringValue = message
            case .pps:
                self.ppsTextField.stringValue = message
            case .kpp:
                self.kppTextField.stringValue = message
            case .statsLines:
                self.lineTextField.stringValue = message
                self.bigLineTextField.stringValue = message
            case .statsTime:
                self.timeTextField.stringValue = message
            case .finesseFaultRepeat:
                self.finesseFaultRepeatTextField.stringValue = message
            default:
                break
            }
        }
    }
    
}
