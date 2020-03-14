//
//  Calculation.swift
//  My Wallet
//
//  Created by Safwan Saigh on 14/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class Calculations{
    
    
    var costs = [Float]()
    
    static func getAverageCosts(costs: [Float], by:String)->Float{
        var sum : Float = 0
        var divd : Float = 0
        if(by == "day"){
            divd = 30
        }else if(by == "week"){
            divd = 4
        }
        for i in costs{
            sum = sum + i
        }
        return (sum / divd).rounded()
    }
    static func getAverageCounts(costs: [Float], by:String)->Int{
        var counter : Float = 0
        var divd : Float = 0
        if(by == "day"){
            divd = 30
        }else if(by == "week"){
            divd = 4
        }
        for i in costs{
            counter = counter + 1
        }
        return Int(counter / divd) + 1
    }
    
    
    
}

