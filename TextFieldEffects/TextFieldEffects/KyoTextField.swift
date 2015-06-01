//
//  KyoTextField.swift
//  TextFieldEffects
//
//  Created by Keenan Cassidy on 22/05/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

@IBDesignable public class KyoTextField: TextFieldEffects {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            updateSuperImposedBackground()
        }
    }
    
    @IBInspectable public var superImposedBackgroundColor: UIColor? {
        didSet {
            updateSuperImposedBackground()
        }
    }
    
    @IBInspectable public var highlightViewColor: UIColor? {
        didSet {
            updateHighlightView()
        }
    }

    override public var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override public var bounds: CGRect {
        didSet {
            updateSuperImposedBackground()
            highlightView.transparentRect?.size = superImposedBackground.frame.size
        }
    }
    
    private let superImposedBackground = UIView()
    private let highlightView = HightlightView()
    
    override func drawViewsForRect(rect: CGRect) {
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        updateSuperImposedBackground()
        addSubview(superImposedBackground)
        
        updatePlaceholder()
        addSubview(placeholderLabel)
    }
    
    override func animateViewsForTextEntry() {
        createHighlightView()
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.highlightView.alpha = 1
        })
    }
    
    override func animateViewsForTextDisplay() {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.highlightView.alpha = 0
        })
    }
    
    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, cornerRadius, -10)
    }
    
    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, cornerRadius, -10)
    }
        
    private func addResignTapGestureToView(view: UIView) {
        let tapGetsureRecognizer = UITapGestureRecognizer(target: self, action: Selector("resignFirstResponder"))
        view.addGestureRecognizer(tapGetsureRecognizer)
    }
    
    private func updateSuperImposedBackground() {
        superImposedBackground.layer.cornerRadius = cornerRadius
        superImposedBackground.layer.masksToBounds = cornerRadius > 0
        superImposedBackground.frame = CGRectMake(0, 0, frame.width, frame.height * 0.66)
        superImposedBackground.backgroundColor = superImposedBackgroundColor
        
        let tapGetsureRecognizer = UITapGestureRecognizer(target: self, action: Selector("becomeFirstResponder"))
        superImposedBackground.addGestureRecognizer(tapGetsureRecognizer)
    }
    
    private func updateHighlightView() {
        highlightView.backgroundColor = UIColor.clearColor()
        highlightView.alpha = 0;
    }
    
    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = textColor
        placeholderLabel.sizeToFit()
        placeholderLabel.font = placeholderFontFromFont(font)
        placeholderLabel.frame = CGRect(x: cornerRadius, y: superImposedBackground.frame.height + 5, width: placeholderLabel.frame.width, height: placeholderLabel.frame.height)
    }
    
    private func placeholderFontFromFont(font: UIFont) -> UIFont! {
        return UIFont(name: font.fontName, size: font.pointSize * 0.65)
    }
    
    private func createHighlightView() {
        let keyWindow = UIApplication.sharedApplication().keyWindow
        
        if highlightView.frame.isEmpty {
            highlightView.frame = CGRect(x: 0 - keyWindow!.frame.size.width,
                                         y: 0 - keyWindow!.frame.size.height,
                                     width: keyWindow!.frame.size.width * 3,
                                    height: keyWindow!.frame.size.height * 3)
            updateHighlightView()
            keyWindow!.addSubview(highlightView)
            
            var point = convertPoint(superImposedBackground.frame.origin, toView: highlightView)
            highlightView.transparentRect = CGRect(origin: point, size: superImposedBackground.frame.size)
            highlightView.highLightColor = highlightViewColor!
            highlightView.setNeedsDisplay()
            
            point = convertPoint(placeholderLabel.frame.origin, toView: highlightView)
            let labelCopy: UILabel = UILabel(frame: placeholderLabel.frame)
            labelCopy.frame.origin = point
            labelCopy.text = placeholder
            labelCopy.textColor = UIColor.whiteColor()
            labelCopy.font = placeholderFontFromFont(font)
            highlightView.addSubview(labelCopy)
        }
        
        addResignTapGestureToView(keyWindow!)
    }
}

public class HightlightView: UIView {
    
    public var highLightColor = UIColor.clearColor()
    
    public var transparentRect: CGRect? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private let fillLayer = CAShapeLayer()
    
    override public func drawRect(rect: CGRect) {
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: rect.size.width, height: rect.size.height))

        let highLightPath = UIBezierPath(rect: bounds)

        let transparentPath = UIBezierPath(roundedRect: transparentRect!, cornerRadius: 20)
        highLightPath.appendPath(transparentPath)
        highLightPath.usesEvenOddFillRule = true

        fillLayer.path = highLightPath.CGPath;
        fillLayer.fillRule = kCAFillRuleEvenOdd;
        fillLayer.fillColor = highLightColor.CGColor

        layer.insertSublayer(fillLayer, atIndex: 0)
    }
    
    override public func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if CGRectContainsPoint(transparentRect!, point) {
            return false;
        }

        return true;
    }
}