//
//  SuperNavigationController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 31/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation
import UIKit
class SuperNavigationController {
    static func setTitle(title : String, nv: UIViewController){
        nv.navigationItem.title = title
        nv.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "JF Flat", size: 23)!]
        nv.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "JF Flat", size: 32)!]
        nv.navigationController?.navigationBar.subviews[1].semanticContentAttribute = .forceRightToLeft
    }
}
