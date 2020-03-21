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
        for _ in costs{
            counter = counter + 1
        }
        return Int(counter / divd) + 1
    }
    
    static func getTotalCost(paymnets: [[Payment]]) -> Double{
        let typesCosts = getCostForEachType(payments: paymnets)
        var sum: Double = 0.0
        for cost in typesCosts{
            sum += cost
        }
        return sum.rounded()
    }
    
    static func getCostForEachType(payments:[[Payment]]) -> [Double]{
        var result = [Double]()
        for i in 0..<payments.count{
            var sum : Double = 0.0
            for j in payments[i]{
                sum += Double(j.cost)
            }
            result.append(sum.rounded())
        }
        return result
    }
    
    static func getCostPercentageForTypes(payments:[[Payment]], userData: [String:Any]) -> [Double]{
        var startBudget: Double = 1
        var result = [Double]()
        if(userData.count != 0){
            startBudget = Double(userData["Start Amount"] as! Float)
        }
        for i in 0..<payments.count{
            var sum : Double = 0.0
            for j in payments[i]{
                sum += Double(j.cost)
            }
            let value = ((sum*100)/(startBudget)).rounded()
            result.append(value)
        }
        return result
    }
    
    static func getMaxCostForType(typesAndCost: [Int:Double])->Double{
        var max: Double = 0.0
        for data in typesAndCost{
            let value = data.value
            if(value > max){
                max = value
            }
        }
        if(max > 0){return max} else {return 1000}

    }
    
}

