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
        DataBank.shared.getCurrentBudget { (budget) in
            self.setupGoals(goals: budget.goals)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupGoals(goals: [Goal]){
        lbl_dGoal.text = "SAR "+String(goals[0].value)
        lbl_wGoal.text = "SAR "+String(goals[1].value)
    }
    
}
