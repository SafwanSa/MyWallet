//
//  StatByCategory.swift
//  My Wallet
//
//  Created by Safwan Saigh on 24/02/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import FirebaseFirestore


class StatByCategory: UITableViewCell{
    
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var backGroundView: GradientView!
    @IBOutlet weak var insideBackground: GradientView!
    
    @IBOutlet weak var lbl_cost: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var btn_pay: RoundButton!
    
    
    var paymentDate = ""
    var paymentType = ""
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    
    @IBAction func btn_payAction(_ sender: RoundButton) {
        let cost = Float(lbl_cost.text!.split(separator: " ")[1])!
          let title = lbl_title.text!
          let p = Payment(title,cost,paymentType,true, "auto")
          //Show a message
          p.addPayemnt()
          //Delete the payment from unpaid list
          p.deletePayment(id: paymentDate)
          //Subtract the cost from the budget
          p.payPayment(cost: cost)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
}

