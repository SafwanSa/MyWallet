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
    
    
    var cellID = ""
    var paymentType = ""
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    func setID(id:String){
        cellID = id
    }
    
    @IBAction func btn_payAction(_ sender: RoundButton) {
        let cost = Float(lbl_cost.text!.split(separator: " ")[1])!
          let title = lbl_title.text!
          let p = Payment(title,cost,paymentType,true)
          //Show a message
          p.addPayemnt()
          //Delete the payment from unpaid list
          p.deletePayment(id: cellID)
          //Subtract the cost from the budget
          p.payPayment(cost: cost)
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load1"), object: nil)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
}

