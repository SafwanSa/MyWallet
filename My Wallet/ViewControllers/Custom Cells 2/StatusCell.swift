//
//  StatusCell.swift
//  My Wallet
//
//  Created by Safwan Saigh on 12/04/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import UICircularProgressRing

class StatusCell: UITableViewCell {

    
    
    @IBOutlet weak var lbl_savings: UILabel!
    @IBOutlet weak var lbl_startBudget: UILabel!
    @IBOutlet weak var lbl_remaining: UILabel!
    @IBOutlet weak var lbl_expenses: UILabel!
    @IBOutlet weak var bakGroundView: GradientView!
    @IBOutlet weak var progressView: UICircularProgressRing!
    
    var budgets = [Budget]()
    var totalCost: Double = 0.0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bakGroundView.layer.shadowOffset = .zero
        bakGroundView.layer.shadowRadius = 5
        bakGroundView.layer.shadowOpacity = 0.8
        bakGroundView.layer.masksToBounds = false
        progressView.style = .dashed(pattern: [7.0, 7.0])
        bakGroundView.alpha = 0
        
    }
    
    
    func setupViews(){
        if budgets.count != 0{
            let budget = self.budgets[0]
            let remaining = budget.current_amount
            let savings = budget.savings
            let startBudget = budget.start_amount
            var percent: Float = 0.0
            if startBudget != 0{percent = (100 * remaining)/startBudget}
            
            self.lbl_expenses.text = ": مصروفات "+String(totalCost)+" SAR "
            self.lbl_savings.text = ": مدخرات "+String(savings)+" SAR "
            self.lbl_startBudget.text = ": الميزانية "+String(savings)+" SAR "
            self.lbl_remaining.text = ": المتبقي "+String(remaining)+" SAR "
            self.progressView.startProgress(to: CGFloat(percent), duration: 0.0) {self.bakGroundView.alpha = 1}

        }
    }
    
    
    
}
