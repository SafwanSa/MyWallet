//
//  TableViewCell1.swift
//  My Wallet
//
//  Created by Safwan Saigh on 17/10/2019.
//  Copyright © 2019 Safwan Saigh. All rights reserved.
//

import UIKit

class TableViewCell1: UITableViewCell {


    @IBOutlet weak var lbl_cost: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_day: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    
    @IBOutlet weak var backGroundView: GradientView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backGroundView.layer.shadowOpacity = 0.6
        backGroundView.layer.shadowRadius = 2
        backGroundView.layer.shadowOffset = .zero
        backGroundView.layer.masksToBounds = false
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
