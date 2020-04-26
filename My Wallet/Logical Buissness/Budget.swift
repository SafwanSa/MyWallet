//
//  Budget.swift
//  My Wallet
//
//  Created by Safwan Saigh on 14/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@objc class Budget: NSObject{
    
    var bid: String
    var current_amount: Float
    var savings: Float
    var start_amount: Float
    var userId: String = ""
    var goals = [Goal]()
    var db = Firestore.firestore()
    
    init(amount: Float, savings: Float, dGoal: Float, wGoal: Float) {
        self.bid = Calendar.getBudgetId()
        self.savings = savings
        start_amount = 0
        current_amount = 0
        super.init()
        start_amount = self.round(amount)
        current_amount = self.round(amount)
        self.userId = getID()
        goals.append(Goal(type: .dailyCostGoal, value: round(dGoal)))
        goals.append(Goal(type: .weeklyCostGoal, value: round(wGoal)))
    }
    
    func round(_ num: Float)->Float{
        return (num*100).rounded()/100
    }
    
    func getID()->String{
        return Auth.auth().currentUser!.uid
    }
    
    func setBudgetData(){
        let data = ["bid": bid,"Start Amount":start_amount, "Current Amount":current_amount, "Savings":savings, "dailyCostGoal":goals[0].value,"weeklyCostGoal":goals[1].value,"uid":userId] as [String : Any]
         db.collection("budgets").document(Calendar.getBudgetId()).setData(data)
    }
    
}
