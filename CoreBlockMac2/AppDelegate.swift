//
//  AppDelegate.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/10.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Cocoa
import SnapKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var gameViewController: GameViewController!
    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // 1. 加载 vc
        self.gameViewController = GameViewController()
        // 2. 将Controller的view 添加到window的content view 中
        self.window.contentView?.addSubview(self.gameViewController.view)
        // 3. 设置Controller的view的尺寸等于窗口的尺寸
        //    self.gameViewController.view.frame = self.window.contentView.bounds
        self.gameViewController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
//        self.clickWindow()
        
        //    self.window.alphaValue = 0.4
        //    self.window.hasShadow = NO
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}


//// MARK: - click window
//
//extension AppDelegate {
//
//    func clickWindow() {
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//
////            let mousePoint: NSPoint = NSEvent.mouseLocation
//
//            var windowFrame = self.window.frame
//            windowFrame.origin.x += self.window.frame.size.width / 2
//            windowFrame.origin.y += self.window.frame.size.height / 2
//
//            self.postMouseEvent(button: CGMouseButton.left, type: CGEventType.leftMouseDown, point: windowFrame.origin)
//            self.postMouseEvent(button: CGMouseButton.left, type: CGEventType.leftMouseUp, point: windowFrame.origin)
//
////            self.postMouseEvent(button: CGMouseButton.left, type: CGEventType.mouseMoved, point: mousePoint)
//        }
//    }
//
//    func postMouseEvent(button: CGMouseButton, type: CGEventType, point: CGPoint) {
//
//        if let theEvent: CGEvent = CGEvent(mouseEventSource: nil, mouseType: type, mouseCursorPosition: point, mouseButton: button) {
//
//            theEvent.setIntegerValueField(CGEventField.mouseEventClickState, value: 1)
//            theEvent.type = type
//            theEvent.post(tap: CGEventTapLocation.cghidEventTap)
//        }
//    }
//}
