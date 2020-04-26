//
//  User.swift
//  My Wallet
//
//  Created by Safwan Saigh on 03/10/2019.
//  Copyright © 2019 Safwan Saigh. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserInfo{
    

    var name:String
    var id:String
    var email:String
    var income: Float
    
    
    init(name:String,email:String,id:String, income: Float) {
        self.name = name
        self.email = email
        self.id = id
        self.income = income
       }
    
    
    func getID()->String{
        return Auth.auth().currentUser!.uid
    }
    
    func setUserInfoData() -> [String:Any]{
        return ["Name": name, "Email":email, "uid":id]
    }
        
    func createBudget(amount: Float, savings: Float)->Budget{
        return Budget(amount: amount, savings: savings, dGoal: 0.0, wGoal: 0.0)
    }
    
}
