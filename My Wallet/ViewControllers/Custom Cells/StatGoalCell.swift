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
        DataBank.shared.getGoals { (goals) in
            self.setupGoals(goals: goals)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupGoals(goals: [Goal]){
        lbl_dGoal.text = String(goals[0].value)
        lbl_wGoal.text = String(goals[1].value)
    }
    
}
