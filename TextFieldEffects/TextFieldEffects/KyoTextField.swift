//
//  KyoTextField.swift
//  TextFieldEffects
//
//  Created by Keenan Cassidy on 30/08/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

@IBDesignable public class KyoTextField: TextFieldEffects {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            updateBorder()
        }
    }

    @IBInspectable var fadeSpeed: Double = 0
    @IBInspectable var activeColor: UIColor?
    @IBInspectable var inActiveColor: UIColor?
    @IBInspectable var activeTextColor: UIColor?
    @IBInspectable var textFieldBackgroundColor: UIColor?
    private var textFieldBackgroundView = UIView()
    
    override func drawViewsForRect(rect: CGRect) {
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        updateBorder()
        updatePlaceholder()
        
        addSubview(placeholderLabel)
        addTextFieldBackgroundView()
    }
    
    private func updateBorder() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
    }
    
    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = textColor
        placeholderLabel.sizeToFit()
        placeholderLabel.font = placeholderFontFromFont(font)
        placeholderLabel.frame = CGRect(x: cornerRadius, y: frame.height - placeholderLabel.frame.size.height, width: placeholderLabel.frame.width, height: placeholderLabel.frame.height)
    }
    
    private func addTextFieldBackgroundView() {
        textFieldBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - placeholderLabel.frame.size.height))
        textFieldBackgroundView.backgroundColor = textFieldBackgroundColor
        textFieldBackgroundView.layer.cornerRadius = cornerRadius
        textFieldBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target:self, action:Selector("tap")))
        
        addSubview(textFieldBackgroundView)
        sendSubviewToBack(textFieldBackgroundView)
    }
    
    func tap() {
        if !isFirstResponder() {
            becomeFirstResponder()
        }
    }
    
    private func placeholderFontFromFont(font: UIFont) -> UIFont! {
        return UIFont(name: font.fontName, size: font.pointSize * 0.65)
    }

    override func animateViewsForTextEntry() {
        UIView.animateWithDuration(fadeSpeed, animations: { () -> Void in
            self.superview?.backgroundColor = self.activeColor
            self.placeholderLabel.textColor = self.activeTextColor
        })
    }
    
    override func animateViewsForTextDisplay() {
        UIView.animateWithDuration(fadeSpeed, animations: { () -> Void in
            self.superview?.backgroundColor = self.inActiveColor
            self.placeholderLabel.textColor = self.textColor
        })
    }
    
    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRect(x: cornerRadius, y: (textFieldBackgroundView.frame.size.height - font.lineHeight) / 2, width: frame.size.width, height: frame.size.height)
    }
    
    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRect(x: cornerRadius, y: (textFieldBackgroundView.frame.size.height - font.lineHeight) / 2, width: frame.size.width, height: frame.size.height)
    }

}
