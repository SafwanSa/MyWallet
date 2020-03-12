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
    @IBOutlet weak var lbl_date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
 


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
  
    
    func setPaidCell(cost:String){
        lbl_cost.text = String("-"+cost+" SAR")
        lbl_cost.textColor = UIColor.red
        lbl_title.textAlignment = NSTextAlignment.center
    }
    
    
}
