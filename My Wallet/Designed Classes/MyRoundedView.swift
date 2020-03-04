//
//  MyRoundedView.swift
//  My Wallet
//
//  Created by Safwan Saigh on 25/09/2019.
//  Copyright © 2019 Safwan Saigh. All rights reserved.
//

import UIKit

@IBDesignable
class MyRoundedView: UIView {
}

extension UIView {
    
    @IBInspectable
    var VcornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
