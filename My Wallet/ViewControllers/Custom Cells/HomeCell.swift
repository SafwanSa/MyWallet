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
    @IBOutlet weak var btn_add: RoundButton!
    @IBOutlet weak var lbl_budget: UILabel!
    @IBOutlet weak var lbl_savings: UILabel!
    @IBOutlet weak var lbl_totalPaymentsCost: UILabel!
    
    @IBOutlet weak var gradView: GradientView!
    
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
    var userGloas = [String:Any]()
    var userData = [String:Any]()
    var delegate: HomeCellProtocol?
    var allPayments = [
        [Payment](),
        [Payment](),
        [Payment](),
        [Payment](),
        [Payment](),
        [Payment](),
        [Payment]()
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btn_add.layer.shadowOffset = .zero
        btn_add.layer.shadowRadius = 5
        btn_add.layer.shadowOpacity = 0.8
        btn_add.layer.masksToBounds = false
        //Styling the progress bar
        prog_view.style = .dashed(pattern: [7.0, 7.0])
        
        Calendar.categ = Calendar.getCurrentMonth()+"/"+Calendar.getCurrentYear()
        let dataSourceDelivery = DataSource(type: "ppayment")
        dataSourceDelivery.dataSourceDelegate = self
    }
    
    @IBAction func btn_addPressed(_ sender: RoundButton) {
        if(self.delegate != nil){ //Just to be safe.
            self.delegate?.transitions()
        }
    }
    
    func checkGoals(){
        let budget = self.userData["Current Amount"] as! Float
        let savings = self.userData["Savings"] as! Float
        let start_budget = self.userData["Start Amount"] as! Float
        
        let goal = Goal(type: .belowBudgetGoal, value: -1)
        goal.setAmounts(start_amount: start_budget, budget_amount: budget , savings_amount: savings)
        
        let savingsCheck = goal.checkSavings()
        let blwBudget = goal.checkBelowBudget()
        let dailyCost = goal.checkDailyCost(payemnts: allPayments, dailyCost: self.userGloas["dailyCostGoal"] as! Float)
        let weeklyCost = goal.checkWeeklyCost(payments: allPayments, weeklyCost:  self.userGloas["weeklyCostGoal"] as! Float)
        let expensesCheck = goal.checkHighExpenses(payments: self.allPayments)
        if savingsCheck{
            lbl_blwSavings.textColor = .red
            blwSavingsLabelView.backgroundColor = .red
        }else{
            lbl_blwSavings.textColor = .white
            blwSavingsLabelView.backgroundColor = .white
        }
        if blwBudget{
            lbl_budget.textColor = .red
        }else{
            lbl_budget.textColor = .white
        }
        if expensesCheck{
            lbl_highExpenses.textColor = .red
            hightExpensesLabelView.backgroundColor = .red
        }else{
            lbl_highExpenses.textColor = .white
            hightExpensesLabelView.backgroundColor = .white
        }
        if dailyCost{
            lbl_dcost.textColor = .red
            dcostLabelView.backgroundColor = .red
        }else{
            lbl_dcost.textColor = .white
            dcostLabelView.backgroundColor = .white
        }
        if weeklyCost{
            lbl_wcost.textColor = .red
            wcostLabelView.backgroundColor = .red
        }else{
            lbl_wcost.textColor = .white
            wcostLabelView.backgroundColor = .white
        }
    }
    
    func setUserData(){
        let budget = self.userData["Current Amount"] as! Float
        let savings = self.userData["Savings"] as! Float
        let startBudget = self.userData["Start Amount"] as! Float
        var percent: Float = 0.0
        if startBudget != 0{percent = (100 * budget)/startBudget}
        let totalCosts = startBudget - budget
        
        self.lbl_totalPaymentsCost.text = "مصروفات "+String(totalCosts)+" SAR "
        self.lbl_savings.text = "مدخرات "+String(savings)+" SAR "
        self.lbl_budget.text = String(budget)+" SAR "
        self.prog_view.startProgress(to: CGFloat(percent), duration: 3.0) {}
    }
}
extension HomeCell: DataSourceProtocol{
    //This will be excuted when any updates happens to userInfo
    func userDataUpdated(data: [String : Any], which: String) {
        //Apply cloures
        if(which == "goals"){self.userGloas = data ;t1 = 1}
        if(which == "budgets"){self.userData = data;t2 = 1;setUserData()}
        if t1+t2 == 2{checkGoals()}
        
    }
    func paidDataUpdated(data: [[Payment]]) {allPayments = data}
    
}
