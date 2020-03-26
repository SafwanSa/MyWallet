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
    
    init(type: GoalType) {
        self.type = type
    }
    
    func setValue(newValue: Float){
        self.value = newValue
    }
    
    
    
    
    
    
    
}
