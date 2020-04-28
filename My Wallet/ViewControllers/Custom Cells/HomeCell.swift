//
//  HomeCell.swift
//  My Wallet
//
//  Created by Safwan Saigh on 15/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import UICircularProgressRing

protocol HomeCellProtocol {
    func transitions()
}

class HomeCell: UITableViewCell {

    @IBOutlet weak var prog_view: UICircularProgressRing!
    @IBOutlet weak var prog_cost_view: UICircularProgressRing!
    @IBOutlet weak var prog_savings_view: UICircularProgressRing!
    
    @IBOutlet weak var btn_add: BorderedButton!
    @IBOutlet weak var lbl_budget: UILabel!
    @IBOutlet weak var lbl_savings: UILabel!
    @IBOutlet weak var lbl_totalPaymentsCost: UILabel!
    
    @IBOutlet weak var gradView: GradientView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var hightExpensesLabelView: UIView!
    @IBOutlet weak var lbl_highExpenses: UILabel!
    
    @IBOutlet weak var blwSavingsLabelView: UIView!
    @IBOutlet weak var lbl_blwSavings: UILabel!
    
    
    @IBOutlet weak var dcostLabelView: UIView!
    @IBOutlet weak var lbl_dcost: UILabel!
    
    @IBOutlet weak var wcostLabelView: UIView!
    @IBOutlet weak var lbl_wcost: UILabel!
    
    var t1 = 0
    var t2 = 0
    var goals = [Goal]()
    var budget: Budget?
    var delegate: HomeCellProtocol?
    var allPayments = [[Payment]]()
    
    override func awakeFromNib() {

        
        gradView.layer.shadowOpacity = 0.6
        gradView.layer.shadowRadius = 1
        gradView.layer.shadowOffset = .zero
        gradView.layer.masksToBounds = false
        rightView.layer.shadowOpacity = 0.6
        rightView.layer.shadowRadius = 1
        rightView.layer.shadowOffset = .zero
        rightView.layer.masksToBounds = false
        bottomView.layer.shadowOpacity = 0.6
        bottomView.layer.shadowRadius = 1
        bottomView.layer.shadowOffset = .zero
        bottomView.layer.masksToBounds = false
        
        Calendar.categ = Calendar.getCurrentMonth()+"/"+Calendar.getCurrentYear()
        DataBank.shared.getCurrentBudget { (bdg) in
            self.budget = bdg
            self.goals = bdg.goals
            self.setUserData()
        }
        DataBank.shared.getPaidPayemnts(all: false) { (paidList) in
            self.allPayments = paidList
            self.setUserData()
            self.checkGoals()
        }
    }
    
    @IBAction func btn_addPressed(_ sender: Any) {
        if(self.delegate != nil){ //Just to be safe.
            self.delegate?.transitions()
        }
    }
    
    func checkGoals(){
        let goal = Goal(type: .belowBudgetGoal, value: -1)
        goal.setAmounts(start_amount: budget!.start_amount, budget_amount: budget!.current_amount , savings_amount: budget!.savings)
        
        let savingsCheck = goal.checkSavings()
        let blwBudget = goal.checkBelowBudget()
        let dailyCost = goal.checkDailyCost(payemnts: allPayments, dailyCost: goals[0].value)
        let weeklyCost = goal.checkWeeklyCost(payments: allPayments, weeklyCost: goals[1].value)
        let expensesCheck = goal.checkHighExpenses(payments: self.allPayments)
        if savingsCheck{
            lbl_blwSavings.textColor = .systemRed
            blwSavingsLabelView.backgroundColor = .systemRed
        }else{
            lbl_blwSavings.textColor = .white
            blwSavingsLabelView.backgroundColor = .white
        }
        if blwBudget{
            lbl_budget.textColor = .systemRed
        }else{
            lbl_budget.textColor = .white
        }
        if expensesCheck{
            lbl_highExpenses.textColor = .systemRed
            hightExpensesLabelView.backgroundColor = .systemRed
        }else{
            lbl_highExpenses.textColor = .white
            hightExpensesLabelView.backgroundColor = .white
        }
        if dailyCost{
            lbl_dcost.textColor = .systemRed
            dcostLabelView.backgroundColor = .systemRed
        }else{
            lbl_dcost.textColor = .white
            dcostLabelView.backgroundColor = .white
        }
        if weeklyCost{
            lbl_wcost.textColor = .systemRed
            wcostLabelView.backgroundColor = .systemRed
        }else{
            lbl_wcost.textColor = .white
            wcostLabelView.backgroundColor = .white
        }
    }
    
    func setUserData(){
        var percent: Float = 0.0
        if budget!.start_amount != 0{percent = (100 * budget!.current_amount)/budget!.start_amount}
        let totalCosts = round(Float(Calculations.getTotalCost(paymnets: self.allPayments)))
        
        self.lbl_totalPaymentsCost.text = "مصروفات "+String(totalCosts)+" SAR "
        self.lbl_savings.text = "مدخرات "+String(budget!.savings)+" SAR "
        self.lbl_budget.text = String(budget!.current_amount)+" SAR "
        self.prog_view.startProgress(to: CGFloat(percent), duration: 3.0) {}
        self.prog_cost_view.startProgress(to: CGFloat(CFloat((100*totalCosts)/budget!.start_amount)), duration: 3.0){}
        self.prog_savings_view.startProgress(to: CGFloat(CFloat((100*budget!.savings)/budget!.start_amount)), duration: 3.0){}
    }
    
    func round(_ num: Float)->Float{
        return (num*100).rounded()/100
    }
}

