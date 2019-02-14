//
//  BaseViewController.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/14.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Cocoa

class BaseViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    /// override this if needed
    func pressKey(down: Bool, event: NSEvent) { }
}

// MARK: - function

extension BaseViewController {
    
    func addKeyEventMonitor() {
        
        NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.flagsChanged) { (event) -> NSEvent? in
            self.pressKey(down: (event.modifierFlags.rawValue != 0x10100), event: event)
            return event
        }
        
        NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.keyDown) { (event) -> NSEvent? in
            self.pressKey(down: true, event: event)
            return event
        }
        
        NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.keyUp) { (event) -> NSEvent? in
            self.pressKey(down: false, event: event)
            return event
        }
    }
}
