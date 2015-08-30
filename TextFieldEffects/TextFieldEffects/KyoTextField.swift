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
    @IBInspectable var activeTextColor: UIColor?
    @IBInspectable var textFieldBackgroundColor: UIColor?
    
    private var textFieldBackgroundView = UIView()
    private var colorViewTopConstraint = NSLayoutConstraint()
    private var colorViewHeightConstraint = NSLayoutConstraint()
    private var colorViewLeftConstraint = NSLayoutConstraint()
    private var colorViewRightConstraint = NSLayoutConstraint()
    
    let colorView = UIView()
    
    override public func drawViewsForRect(rect: CGRect) {
        updateBorder()
        updatePlaceholder()
        addSubview(placeholderLabel)
        addTextFieldBackgroundView()
        addColorView()
    }
    
    private func updateBorder() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
    }
    
    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = textColor
        placeholderLabel.sizeToFit()
        placeholderLabel.font = placeholderFontFromFont(font!)
        placeholderLabel.frame = CGRect(x: cornerRadius, y: frame.height - placeholderLabel.frame.size.height, width: placeholderLabel.frame.width, height: placeholderLabel.frame.height)
    }
    
    private func addTextFieldBackgroundView() {
        textFieldBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - placeholderLabel.frame.size.height))
        textFieldBackgroundView.backgroundColor = textFieldBackgroundColor
        textFieldBackgroundView.layer.cornerRadius = cornerRadius
        textFieldBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target:self, action:Selector("tap")))
        
        addSubview(textFieldBackgroundView)
        sendSubviewToBack(textFieldBackgroundView)
        addTextFieldBackgroundViewConstraints()
    }
    
    private func addTextFieldBackgroundViewConstraints() {
        textFieldBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: textFieldBackgroundView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: textFieldBackgroundView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: textFieldBackgroundView.frame.size.height)
        let leftConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: textFieldBackgroundView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: textFieldBackgroundView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        
        addConstraints([topConstraint, heightConstraint, leftConstraint, rightConstraint])
    }
    
    private func addColorView() {
        colorView.frame = superview!.convertRect(textFieldBackgroundView.frame, fromView:self)
        colorView.layer.cornerRadius = cornerRadius
        colorView.backgroundColor = activeColor
        superview?.addSubview(colorView)
        superview?.bringSubviewToFront(self)
        addColorViewConstraints()
    }
    
    private func addColorViewConstraints() {
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        colorViewTopConstraint = NSLayoutConstraint(item: colorView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: superview!, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: colorView.frame.origin.y)
        colorViewHeightConstraint = NSLayoutConstraint(item: colorView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: colorView.frame.size.height)
        colorViewLeftConstraint = NSLayoutConstraint(item: colorView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: superview!, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: colorView.frame.origin.x)
        colorViewRightConstraint = NSLayoutConstraint(item: superview!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: colorView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: colorView.frame.origin.x)
        
        superview!.addConstraints([colorViewTopConstraint, colorViewHeightConstraint, colorViewLeftConstraint, colorViewRightConstraint])
    }
    
    func tap() {
        if !isFirstResponder() {
            becomeFirstResponder()
        }
    }
    
    private func placeholderFontFromFont(font: UIFont) -> UIFont! {
        return UIFont(name: font.fontName, size: font.pointSize * 0.65)
    }

    public override func animateViewsForTextEntry() {
        colorViewTopConstraint.constant = 0
        colorViewHeightConstraint.constant = (superview?.frame.size.height)!
        colorViewLeftConstraint.constant = -cornerRadius
        colorViewRightConstraint.constant = -cornerRadius
        
        superview?.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(fadeSpeed, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.superview?.layoutIfNeeded()
            self.placeholderLabel.textColor = self.activeTextColor
            }, completion: nil)
    }
    
    public override func animateViewsForTextDisplay() {
        let textFieldBackgroundViewLocationInSuperView = self.superview!.convertRect(self.textFieldBackgroundView.frame, fromView:self)
        
        colorViewTopConstraint.constant = textFieldBackgroundViewLocationInSuperView.origin.y
        colorViewHeightConstraint.constant = textFieldBackgroundViewLocationInSuperView.size.height
        colorViewLeftConstraint.constant = textFieldBackgroundViewLocationInSuperView.origin.x
        colorViewRightConstraint.constant = textFieldBackgroundViewLocationInSuperView.origin.x

        superview?.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(fadeSpeed, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.superview?.layoutIfNeeded()
            self.placeholderLabel.textColor = self.textColor
            }, completion: nil)
    }
    
    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRect(x: cornerRadius, y: (textFieldBackgroundView.frame.size.height - font!.lineHeight) / 2, width: frame.size.width, height: frame.size.height)
    }
    
    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRect(x: cornerRadius, y: (textFieldBackgroundView.frame.size.height - font!.lineHeight) / 2, width: frame.size.width, height: frame.size.height)
    }

}
