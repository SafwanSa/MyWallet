//
//  HistoryCell.swift
//  My Wallet
//
//  Created by Safwan Saigh on 09/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell{
    
    
    
    
    @IBOutlet weak var rightView: GradientView!
    @IBOutlet weak var leftView: GradientView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rightView.layer.shadowOpacity = 0.6
        rightView.layer.shadowRadius = 5
        rightView.layer.shadowOffset = .zero
        rightView.layer.masksToBounds = false
        leftView.layer.shadowOpacity = 0.6
        leftView.layer.shadowRadius = 5
        leftView.layer.shadowOffset = .zero
        leftView.layer.masksToBounds = false
    }
    
    
    @IBAction func btn_stat(_ sender: Any) {
        print("Stat")
    }
    
    
    @IBAction func btn_hist(_ sender: Any) {
        print("Hist")
    }
    
    
}
