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
    
    var cellID: String
        = ""
    var type = ""
    let db = Firestore.firestore()
    @IBOutlet weak var btn_pay_out: RoundButton!
    
    
    
    
    func setID(id:String){
        cellID = id
    }
    
    func getID()->String{
        return cellID
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    
 
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lbl_cost = nil
        lbl_title = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    @IBAction func btn_pay(_ sender: UIButton) {
        let cost = Float(lbl_cost.text!.split(separator: " ")[0])!
        let title = lbl_title.text!
        let p = Payment(title: title, cost: cost, type: type, paid: true)
        //Show a message
        p.addPayemnt()
        //Delete the payment from unpaid list
        p.deletePayment(id: cellID)
        //Subtract the cost from the budget
        p.payPayment(cost: cost)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load1"), object: nil)
        
    }
 
    
    func setPaidCell(cost:String){
        lbl_cost.text = String("-"+cost+" SAR")
        lbl_cost.textColor = UIColor.red
        btn_pay_out.isHidden = true
        lbl_title.textAlignment = NSTextAlignment.center
    }
    
    func setUnPaidCell(cost:String){
        lbl_cost.text = String(cost+" SAR")
        lbl_cost.textColor = UIColor.green
        btn_pay_out.isHidden = false
        lbl_title.textAlignment = NSTextAlignment.center
    }
    
    
}
