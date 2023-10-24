//
//  Utility.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/12.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Cocoa
import SnapKit

extension NSColor {
    
    static var cbm_gray_064: NSColor { return 0xeeeeee.cbm_color }
    static var cbm_gray_125: NSColor { return 0xcccccc.cbm_color }
    /// background
    static var cbm_gray_250: NSColor { return 0x999999.cbm_color }
    /// stackBackView border
    static var cbm_gray_500: NSColor { return 0x393939.cbm_color }
    /// stackBackView line 1
    static var cbm_gray_750: NSColor { return 0x2c2c2c.cbm_color }
    /// stackBackView line 2
    static var cbm_gray_875: NSColor { return 0x1c1c1c.cbm_color }
    
    /// clear
    static var cbm_clear: NSColor { return NSColor.clear }
    
    /// black
    static var cbm_black_500: NSColor { return NSColor.black }
    
    /// white
    static var cbm_white_500: NSColor { return NSColor.white }
}


extension Int {
    
    var cbm_color: NSColor {
        let red = CGFloat((self & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((self & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((self & 0xFF)) / 255.0
        return NSColor(calibratedRed: red, green: green, blue: blue, alpha: 1.0)
    }
}


extension NSButton {
    
    var cbm_titleTextColor : NSColor {
        get {
            let attrTitle = self.attributedTitle
            return attrTitle.attribute(NSAttributedString.Key.foregroundColor, at: 0, effectiveRange: nil) as! NSColor
        }
        
        set(newColor) {
            let attrTitle = NSMutableAttributedString(attributedString: self.attributedTitle)
            let titleRange = NSMakeRange(0, self.title.count)
            
            attrTitle.addAttributes([NSAttributedString.Key.foregroundColor: newColor], range: titleRange)
            self.attributedTitle = attrTitle
        }
    }
}


extension NSView {
    
    @discardableResult
    public func cbm_snpMakeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) -> NSView {
        self.snp.makeConstraints(closure)
        return self
    }
    
    @discardableResult
    public func cbm_snpRemakeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) -> NSView {
        self.snp.remakeConstraints(closure)
        return self
    }
    
    @discardableResult
    public func cbm_snpUpdateConstraints(_ closure: (_ make: ConstraintMaker) -> Void) -> NSView {
        self.snp.updateConstraints(closure)
        return self
    }
}


extension NSView {
    
    @discardableResult
    func cbm_addSubview<T: NSView>(_ subview: T) -> T {
        self.addSubview(subview)
        return subview
    }
    
    @discardableResult
    func cbm_addSubview(withBackgroundColor backgroundColor: NSColor? = nil) -> NSView {
        
        let view: NSView = NSView()
        if let backgroundColor = backgroundColor {
            view.wantsLayer = true
            view.layer?.backgroundColor = backgroundColor.cgColor
            view.needsDisplay = true
        }
        return self.cbm_addSubview(view)
    }
    
    @discardableResult
    func cbm_addTextField(
        
        withTitle title: String = "",
        textColor: NSColor? = nil,
        fontSize: CGFloat,
        alignment: NSTextAlignment? = NSTextAlignment.center,
        maximumNumberOfLines: Int = 0,
        
        backgroundColor: NSColor? = nil,
        
        tag: Int? = nil
        ) -> NSTextField {
        
        let textField: NSTextField = NSTextField()
        
        textField.stringValue = title
        textField.font = NSFont.init(name: "Menlo", size: fontSize)
        textField.textColor = textColor ?? NSColor.cbm_gray_250
        if let alignment = alignment {
            textField.alignment = alignment
        }
        textField.maximumNumberOfLines = maximumNumberOfLines
        
        textField.backgroundColor = backgroundColor ?? NSColor.cbm_clear
        
        if let tag = tag {
            textField.tag = tag
        }
        
        textField.isBordered = false
        textField.isEditable = false
        textField.isSelectable = false
        
        return self.cbm_addSubview(textField)
    }
    
    @discardableResult
    /// it return NSTextField, not NSButton
    func cbm_addButton(
        
        withTitle title: String = "",
        textColor: NSColor? = nil,
        fontSize: CGFloat = 15,
        
        backgroundColor: NSColor? = nil,
        
        tag: Int = 0,
        
        target: AnyObject,
        action: Selector
        ) -> NSView {
        
        let textField: NSTextField = self.cbm_addTextField(withTitle: title, textColor: textColor, fontSize: fontSize, backgroundColor: backgroundColor)
        self.addSubview(textField)
        
        let button = NSButton()
        
        button.title = ""
        
        button.tag = tag
        /// show click button effect
        button.alphaValue = 0.15
        
        button.target = target
        button.action = action
        
        textField.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return textField
    }
}


public class CCGCD {
    
    public class main {
        
        public static func async(_ handler: @escaping () -> Void) {
            
            if Thread.isMainThread {
                handler()
            } else {
                DispatchQueue.main.async(execute: handler)
            }
        }
        
        public static func sync(_ handler: @escaping () -> Void) {
            
            if Thread.isMainThread {
                handler()
            } else {
                DispatchQueue.main.sync(execute: handler)
            }
        }
        
        public static func after(_ time: Double, _ handler: @escaping () -> Void) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: handler)
        }
    }
    
    public class global {
        
        public static func async(_ handler: @escaping () -> Void) {
            
            DispatchQueue.global().async(execute: handler)
        }
        
        public static func after(_ time: Double, _ handler: @escaping () -> Void) {
            
            DispatchQueue.global().asyncAfter(deadline: .now() + time, execute: handler)
        }
    }
}

extension NSImage {
    
    /// Rotates the image by the specified degrees around the center.
    /// Note that if the angle is not a multiple of 90°, parts of the rotated image may be drawn outside the image bounds.
    func rotated(by angle: CGFloat) -> NSImage {
        let img = NSImage(size: self.size, flipped: false, drawingHandler: { (rect) -> Bool in
            let (width, height) = (rect.size.width, rect.size.height)
            let transform = NSAffineTransform()
            transform.translateX(by: width / 2, yBy: height / 2)
            transform.rotate(byDegrees: angle)
            transform.translateX(by: -width / 2, yBy: -height / 2)
            transform.concat()
            self.draw(in: rect)
            return true
        })
        img.isTemplate = self.isTemplate // preserve the underlying image's template setting
        return img
    }
    
    func dimmed(alpha: CGFloat) -> NSImage {
        let newImage = NSImage(size: self.size)
        newImage.lockFocus()

        let imageRect = NSRect(origin: .zero, size: self.size)
        self.draw(in: imageRect, from: imageRect, operation: .sourceOver, fraction: alpha)

        newImage.unlockFocus()
        return newImage
    }
}
