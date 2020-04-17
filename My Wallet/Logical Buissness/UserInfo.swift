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
    

    var first_name:String
    var last_name:String
    var id:String
    var email:String
    
    
    
    init(first_name:String,last_name:String,email:String,id:String) {
            self.first_name = first_name
            self.last_name = last_name
            self.email = email
            self.id = id
       }
    
    
    func getID()->String{
        return Auth.auth().currentUser!.uid
    }
    
    func setUserInfoData() -> [String:Any]{
        return ["First Name":first_name, "Last Name":last_name, "Email":email, "uid":id]
    }
        
    func createBudget(amount: Float, savings: Float)->Budget{
        return Budget(amount: amount, savings: savings, dGoal: 0.0, wGoal: 0.0)
    }
    
}
