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
    
    var budget:Float
    var income:Float
    var savings:Float
    var first_name:String
    var last_name:String
    var id:String
    var email:String
    let db = Firestore.firestore()
    
    
    
    init(first_name:String,last_name:String,email:String,id:String,income:Float,budget:Float,savings:Float) {
            self.first_name = first_name
            self.last_name = last_name
            self.email = email
            self.id = id
            self.income = income
            self.budget = budget
            self.savings = savings
       }
    
    
    func getID()->String{
        return Auth.auth().currentUser!.uid
    }
    
    func setToDic() -> [String:Any]{
        return ["First Name":first_name, "Last Name":last_name, "Email":email, "uid":id, "Income":income, "Budget":budget, "Savings":savings]
    }
        
    
    
}
