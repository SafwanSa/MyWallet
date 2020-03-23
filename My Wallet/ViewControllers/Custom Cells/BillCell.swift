//
//  BillCell.swift
//  My Wallet
//
//  Created by Safwan Saigh on 22/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class BillCell: UITableViewCell{
    
    @IBOutlet weak var backGroundView: GradientView!
    @IBOutlet weak var insideBackground: GradientView!
    
    @IBOutlet weak var lbl_cost: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var btn_pay: RoundButton!
    
    @IBOutlet weak var btn_dellete: RoundButton!
    
    var paymentDate = ""
    var paymentType = ""
    var billDay = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    
    @IBAction func btn_payAction(_ sender: RoundButton) {
        let cost = Float(lbl_cost.text!.split(separator: " ")[1])!
        let title = lbl_title.text!
        let bill = Bill(title, cost, billDay, "auto")
        if (sender.tag == 0){
            //Add the bill in the paidList
            bill.addBillToPaidList()
            //Update the "last update" for a bill
            bill.updateBillLastUpdate(id: paymentDate ,lastUpdate: bill.at)
            //Subtract the cost from the budget
            bill.payPayment(cost: cost)
        }else{
            //Update the "last update" for a bill
            bill.updateBillLastUpdate(id: paymentDate ,lastUpdate: bill.at)
        }

    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
}

