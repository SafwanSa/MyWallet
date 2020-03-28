//
//  Goal.swift
//  My Wallet
//
//  Created by Safwan Saigh on 26/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation

enum GoalType {
    case dailyCost
    case weeklyCost
    case maxCost
    case trackExpenses
    case savings
    case belowBudget
    case importantList
}

class Goal{
    
    var type: GoalType
    var value: Float?
    private var paidPayments: [[Payment]]?
    private var unpaidPayments: [Payment]?
    private var budget_amount: Float = 0.0
    private var start_amount: Float = 0.0
    private var savings: Float = 0.0
    private var types_cost: [Float]?
    
    var dataSourceDeleviry: DataSource?
    
    init(type: GoalType) {
        self.type = type
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
    
    func setMaxCost(types_costs: [String:Float]){
        //Set it in the database
        _ = ["bills": 400, "food": 200]
    }
    
    func checkMaxCost()->[String:Float]{
        //Take the data from the database
        //Run an alogorithm that calculates the >
        return ["":0.0]
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
