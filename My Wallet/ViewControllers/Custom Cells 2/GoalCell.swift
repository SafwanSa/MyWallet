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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DataBank.shared.getCurrentBudget { (budget) in
            self.setupInfo(goals: budget.goals)
        }
    }
    
    func setupInfo(goals: [Goal]){
        if (lbl_cellTitle.text == "اليومي"){
            lbl_cost.text = String(goals[0].value)
        }else{
            lbl_cost.text = String(goals[1].value)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
