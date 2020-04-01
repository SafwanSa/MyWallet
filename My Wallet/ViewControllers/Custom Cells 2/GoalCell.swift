//
//  MaxCostGoalCell.swift
//  My Wallet
//
//  Created by Safwan Saigh on 29/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet weak var lbl_cellTitle: UILabel!
    @IBOutlet weak var lbl_cost: HSUnderLineTextField!
    
    var dataDelivery: DataSource?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dataDelivery = DataSource()
        dataDelivery?.dataSourceDelegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension GoalCell: DataSourceProtocol{

    func userDataUpdated(data: [String : Any], which:String) {
        if(which == "goals"){
            if (lbl_cellTitle.text == "اليومي"){
                lbl_cost.text = String(data["dailyCostGoal"] as! Float)
            }else{
                lbl_cost.text = String(data["weeklyCostGoal"] as! Float)
            }
        }
    }
}
