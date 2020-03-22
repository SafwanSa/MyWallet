//
//  Bill.swift
//  My Wallet
//
//  Created by Safwan Saigh on 21/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class Bill: Payment{
    
    init(_ title: String, _ cost: Float, _ day: String, _ at: String) {
        super.init(title, cost, "فواتير", false, at)
        self.day = day
    }
    
    override func addPayemnt() {
        db.collection("uppayment").document().setData(["Title":self.title, "Cost":self.cost, "At":self.at,"Type":self.type, "Paid":self.paid,"Day":self.day,"uid":getID()])
    }
    
    
    
    
    
    
    
}
