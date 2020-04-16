//
//  Goal.swift
//  My Wallet
//
//  Created by Safwan Saigh on 26/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
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
    private var budget_amount: Float = 0.0
    private var start_amount: Float = 0.0
    private var savings_amount: Float = 0.0
    var db = Firestore.firestore()
    
    init(type: GoalType, value: Float) {
        self.type = self.converter(type)
        self.value = value
    }
    
    func setValue(newValue: Float){
        self.value = newValue
    }
    
    func setAmounts(start_amount: Float, budget_amount: Float, savings_amount: Float){
        self.budget_amount = budget_amount
        self.start_amount = start_amount
        self.savings_amount = savings_amount
    }
    
    func checkBelowBudget()->Bool{
        return budget_amount < 0
    }
    
    func checkHighExpenses(payments: [[Payment]])->Bool{
        let max = Calculations.getMaxCost(payments: payments)
        if budget_amount > 0{
            if (max * 100) / budget_amount > 40{return true}
        }
        return false
    }
    
    func checkSavings()->Bool{
        if budget_amount < savings_amount{
            return true
        }else{
            return false
        }
    }
    
    
    func checkDailyCost(payemnts: [[Payment]], dailyCost: Float)->Bool{
        let dCost = Calculations.getCostInCurrentDay(payments: payemnts)
        if dCost > dailyCost{return true}
        return false
    }
    
    func checkWeeklyCost(payments: [[Payment]], weeklyCost: Float)->Bool{
        let wcost = Calculations.getCostForWeek(payments: payments)
        print(wcost)
        if wcost > weeklyCost{return true}
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
