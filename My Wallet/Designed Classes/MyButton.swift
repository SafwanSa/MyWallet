//
//  File.swift
//  My Wallet
//
//  Created by Safwan Saigh on 19/09/2019.
//  Copyright © 2019 Safwan Saigh. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class BorderedButton: UIButton {
    @IBInspectable var lineWidth:    CGFloat = 3  { didSet { setNeedsLayout() } }
    @IBInspectable var cornerRadius: CGFloat = 10 { didSet { setNeedsLayout() } }

    let borderLayer: CAGradientLayer = {
        let borderLayer = CAGradientLayer()
        borderLayer.type = .axial
        borderLayer.colors = [#colorLiteral(red: 0.3568627451, green: 0.3450980392, blue: 0.968627451, alpha: 1).cgColor, #colorLiteral(red: 0.8431372549, green: 0.3490196078, blue: 0.7215686275, alpha: 1).cgColor]
        borderLayer.startPoint = CGPoint(x: 0, y: 1)
        borderLayer.endPoint = CGPoint(x: 1, y: 0)
        return borderLayer
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        borderLayer.frame = bounds

        let mask = CAShapeLayer()
        let rect = bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
        mask.path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        mask.lineWidth = lineWidth
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        borderLayer.mask = mask
    }
}

private extension BorderedButton {
    func configure() {
        layer.addSublayer(borderLayer)
    }
}

@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
@IBDesignable
class GradientButton: UIButton {
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
//            gradientLayer.borderColor = layer.borderColor
//            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
}
