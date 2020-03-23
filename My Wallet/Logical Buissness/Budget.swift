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

class Budget{
    
    var bid: String
    var current_amount: Float
    var savings: Float
    var start_amount: Float
    var userId: String
    init(amount: Float, savings: Float, user: UserInfo) {
        self.bid = Calendar.getBudgetId()
        self.start_amount = amount
        self.current_amount = amount
        self.savings = savings
        self.userId = user.id
    }
    
    
    func getID()->String{
        return Auth.auth().currentUser!.uid
    }
    
    func setBudgetData() -> [String:Any]{
        return ["bid": bid,"Start Amount":start_amount, "Current Amount":current_amount, "Savings":savings, "uid":userId]
    }
    
    
}
