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

    override public var placeholder: String? {
        didSet {
            updatePlaceholder()
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

    override public var bounds: CGRect {
        didSet {
            updateSuperImposedBackground()
        }
    }

    private let SuperImposedBackground = UIView()
    private var highlightView = UIView()

    override func drawViewsForRect(rect: CGRect) {
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: rect.size.width, height: rect.size.height))

        updateSuperImposedBackground()
        addSubview(SuperImposedBackground)
        sendSubviewToBack(SuperImposedBackground)

        updatePlaceholder()
        addSubview(placeholderLabel)
    }

    override func animateViewsForTextEntry() {
        if highlightView.frame.isEmpty {
            highlightView = UIView(frame: offsetFrame())
            updateHighlightView()

            addResignTapGesture()
            addSubview(highlightView)
            sendSubviewToBack(highlightView)
        }

        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.placeholderLabel.textColor = self.superImposedBackgroundColor
            self.highlightView.alpha = 1
        })
    }

    override func animateViewsForTextDisplay() {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.placeholderLabel.textColor = self.textColor
            self.highlightView.alpha = 0
        })
    }

    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, cornerRadius, -10)
    }

    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, cornerRadius, -10)
    }

    private func offsetFrame() -> CGRect {
        let keyWindow = UIApplication.sharedApplication().keyWindow
        let offsetInKeyWindow = convertPoint(frame.origin, toView: keyWindow)

        return CGRect(x: frame.origin.x - keyWindow!.frame.width,
                      y: frame.origin.y - keyWindow!.frame.height,
                  width: keyWindow!.frame.width * 3,
                 height: keyWindow!.frame.height * 3)
    }

    private func addResignTapGesture() {
        let keyWindow = UIApplication.sharedApplication().keyWindow
        var tapGetsureRecognizer = UITapGestureRecognizer(target: self, action: Selector("resignFirstResponder"))
        keyWindow!.addGestureRecognizer(tapGetsureRecognizer)
    }

    private func updateSuperImposedBackground() {
        SuperImposedBackground.layer.cornerRadius = cornerRadius
        SuperImposedBackground.layer.masksToBounds = cornerRadius > 0
        SuperImposedBackground.frame = CGRectMake(0, 0, frame.width, frame.height * 0.66)
        SuperImposedBackground.backgroundColor = superImposedBackgroundColor

        var tapGetsureRecognizer = UITapGestureRecognizer(target: self, action: Selector("becomeFirstResponder"))
        SuperImposedBackground.addGestureRecognizer(tapGetsureRecognizer)
    }

    private func updateHighlightView() {
        highlightView.backgroundColor = highlightViewColor
        highlightView.alpha = 0;
    }

    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = textColor
        placeholderLabel.sizeToFit()
        placeholderLabel.font = placeholderFontFromFont(font)
        placeholderLabel.frame = CGRect(x: cornerRadius, y: SuperImposedBackground.frame.height + 5, width: placeholderLabel.frame.width, height: placeholderLabel.frame.height)
    }

    private func placeholderFontFromFont(font: UIFont) -> UIFont! {
        return UIFont(name: font.fontName, size: font.pointSize * 0.65)
    }
}
