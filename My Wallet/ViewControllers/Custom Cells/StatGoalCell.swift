//
//  MaxTypeCell.swift
//  My Wallet
//
//  Created by Safwan Saigh on 14/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class StatGoalCell: UITableViewCell {

    @IBOutlet weak var lbl_dGoal: UILabel!
    @IBOutlet weak var lbl_wGoal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let dataSourceDelivery = DataSource()
        dataSourceDelivery.dataSourceDelegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupGoals(goals: [String:Any]){
        lbl_dGoal.text = String(goals["dailyCostGoal"] as! Float)
        lbl_wGoal.text = String(goals["weeklyCostGoal"] as! Float)
    }
    
}
extension StatGoalCell: DataSourceProtocol{
    func userDataUpdated(data: [String : Any], which: String) {
        if(which == "goals"){
            print(data)
            setupGoals(goals: data)
        }
    }
}
