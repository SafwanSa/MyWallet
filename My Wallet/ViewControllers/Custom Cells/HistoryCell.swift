//
//  HistoryCell.swift
//  My Wallet
//
//  Created by Safwan Saigh on 09/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit


protocol HistoryCellProtocol {
    func transitions(category: String)
}

class HistoryCell: UITableViewCell{
    
    @IBOutlet weak var rightView: GradientView!
    @IBOutlet weak var leftView: GradientView!
    
    
    var category = ""
    var delegate:HistoryCellProtocol!
    
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
        print("Stat", category)
    }
    
    
    @IBAction func btn_hist(_ sender: Any) {
        if(self.delegate != nil){ //Just to be safe.
            self.delegate.transitions(category: category)
        }
    }
    
    
}
