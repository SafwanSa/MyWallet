//
//  TableViewCell1.swift
//  My Wallet
//
//  Created by Safwan Saigh on 17/10/2019.
//  Copyright © 2019 Safwan Saigh. All rights reserved.
//

import UIKit
import FirebaseFirestore
class TableViewCell1: UITableViewCell {


    @IBOutlet weak var lbl_cost: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    
    var paymentDate: String = ""
    var type = ""
    let db = Firestore.firestore()
    
    
    func getID()->String{
        return paymentDate
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
 


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    @IBAction func btn_pay(_ sender: UIButton) {
        let cost = Float(lbl_cost.text!.split(separator: " ")[0])!
        let title = lbl_title.text!
        let p = Payment(title,cost,type,true,"auto")
        //Show a message
        p.addPayemnt()
        //Delete the payment from unpaid list
        p.deletePayment(id: paymentDate)
        //Subtract the cost from the budget
        p.payPayment(cost: cost)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load1"), object: nil)
        
    }
 
    
    func setPaidCell(cost:String){
        lbl_cost.text = String("-"+cost+" SAR")
        lbl_cost.textColor = UIColor.red
        lbl_title.textAlignment = NSTextAlignment.center
    }
    
    
}
