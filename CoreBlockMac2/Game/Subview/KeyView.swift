//
//  KeyView.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/11.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Cocoa

class KeyView: NSView {
    
    var pressKeyHandler: ((_ down: Bool, _ event: NSEvent) -> Void)?

    init(pressKeyHandler: @escaping (_ down: Bool, _ event: NSEvent) -> Void) {
        self.pressKeyHandler = pressKeyHandler
        super.init(frame: NSRect.zero)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
}

extension KeyView {
    
    override func keyDown(with event: NSEvent) {
        self.pressKeyHandler?(true, event)
    }
    
    override func keyUp(with event: NSEvent) {
        self.pressKeyHandler?(false, event)
    }
}

