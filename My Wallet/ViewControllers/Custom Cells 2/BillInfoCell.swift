//
//  BillInfoCell.swift
//  My Wallet
//
//  Created by Safwan Saigh on 17/04/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class BillInfoCell: UITableViewCell {

    @IBOutlet weak var lbl_billNum: UILabel!
    @IBOutlet weak var lbl_billCost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DataBank.shared.getUnpaidPayemnts() { (UnpaidList) in
            var count = 0
            var cost: Float = 0.0
            for payment in UnpaidList{
                if payment.type == "فواتير"{
                    count+=1
                    cost+=payment.cost
                }
            }
            self.setupInfo(count, cost)
        }
    }
    
    func setupInfo(_ count: Int, _ cost: Float){
        lbl_billNum.text = String(count)
        lbl_billCost.text = "SAR "+String(cost)
    }
    
}
