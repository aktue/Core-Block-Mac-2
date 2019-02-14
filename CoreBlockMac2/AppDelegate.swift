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
        
        self.gameViewController = GameViewController()
        self.window.contentView?.addSubview(self.gameViewController.view)
        self.gameViewController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
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
