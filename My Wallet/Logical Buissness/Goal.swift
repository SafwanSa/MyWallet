//
//  Goal.swift
//  My Wallet
//
//  Created by Safwan Saigh on 26/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation
import Firebase
enum GoalType {
    case dailyCostGoal
    case weeklyCostGoal
    case trackExpensesGoal
    case savingGoal
    case belowBudgetGoal
    case importantListGoal
}

class Goal{
    
    var type: String = ""
    var value: Float = 0.0
    private var paidPayments: [[Payment]]?
    private var unpaidPayments: [Payment]?
    private var budget_amount: Float = 0.0
    private var start_amount: Float = 0.0
    private var savings: Float = 0.0
    private var types_cost: [Float]?
    
    var dataSourceDeleviry: DataSource?
    var db = Firestore.firestore()
    
    init(type: GoalType, value: Float) {
        self.type = self.converter(type)
        self.value = value
        self.dataSourceDeleviry = DataSource(type: "ppayment")
        self.dataSourceDeleviry?.dataSourceDelegate = self
    }
    
    func setValue(newValue: Float){
        self.value = newValue
    }
    
    func checkBelowBudget(budget_amount: Float)->Bool{
        return budget_amount < 0
    }
    
    func checkHighExpenses(payment_cost: Float)->Bool{
         //Call this from the addPayment, addbill, pay any thing
        if self.budget_amount > 0{
            if (payment_cost * 100) / self.budget_amount > 40{return true}
        }
        return false
    }
    
    func checkSavings()->Bool{
        //Call this from the addPayment, addbill, pay any thing
        if self.budget_amount < self.savings{
            return true
        }else{
            return false
        }
    }
    
    
    func checkDailyCost()->Bool{
        //Take the daily cost form the database
        //Get the total cost in the current day, and then see if it is > DC
        return false
    }
    
    func checkWeeklyCost()->Bool{
        //Take the weekly cost form the database
        //Get the total cost in the current week, and then see if it is > DC
        //Get the date of Sunday add 
        return false
    }
    
    func addGoal(){
        let data:[String:Any] = [type : value]
        db.collection("goals").document(getID()).updateData(data)
    }
    
    func getID()->String{
        return Auth.auth().currentUser!.uid
    }
    
    func converter(_ type: GoalType)->String{
        var strType = ""
        switch type {
        case GoalType.savingGoal:
            strType = "savingGoal";
        case GoalType.dailyCostGoal:
            strType = "dailyCostGoal";
        case GoalType.weeklyCostGoal:
            strType = "weeklyCostGoal"
        case GoalType.belowBudgetGoal:
            strType = "belowBudgetGoal"
        case GoalType.trackExpensesGoal:
            strType = "trackExpensesGoal"
        case GoalType.importantListGoal:
            strType = "importantListGoal"
        }
        return strType
    }
    
}
extension Goal: DataSourceProtocol{
    func paidDataUpdated(data: [[Payment]]) {self.paidPayments = data}
    
    func unpaidDataUpdated(data: [Payment]) {self.unpaidPayments = data}
    
    func userDataUpdated(data: [String : Any], which: String) {
        if(which == "budgets"){
            self.budget_amount = data["Current Amount"] as! Float
            self.start_amount = data["Start Amount"] as! Float
            self.savings = (data["Savings"] as! Float)
        }
    }
    
    func getMonths(months: [String]) {}//No use of this
    
    func getCosts(costs: [Float]) {self.types_cost? = costs}
    
    
}
