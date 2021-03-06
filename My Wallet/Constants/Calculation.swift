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
    
   static func round(_ num: Float)->Float{
        return (num*100).rounded()/100
    }
    
    
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
        return round(sum / divd)
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
        return Double(round(Float(sum)))
    }
    
    static func getCostForEachType(payments:[[Payment]]) -> [Double]{
        var result = [Double]()
        for i in 0..<payments.count{
            var sum : Double = 0.0
            for j in payments[i]{
                sum += Double(j.cost)
            }
            result.append(Double(round(Float(sum))))
        }
        return result
    }
    
    static func getCostPercentageForTypes(payments:[[Payment]], userData: Budget) -> [Double]{
        var startBudget: Double = 1
        var result = [Double]()
        if(userData.start_amount != 0){
            startBudget = Double(userData.start_amount)
        }
        for i in 0..<payments.count{
            var sum : Double = 0.0
            for j in payments[i]{
                sum += Double(j.cost)
            }
            let value = Double(sum*100/startBudget)
            result.append(value)
        }
        return result
    }
    
    static func getMaxCost(payments: [[Payment]])->Float{
        var max: Float = 0.0
        for i in 0..<payments.count{
            for j in 0..<payments[i].count{
                let value = payments[i][j].cost
                if(value > max){
                    max = value
                }
            }
        }
        return max
    }
    
    static func getCostForWeek(payments: [[Payment]])->Float{
        var cost: Float = 0.0
        for i in 0..<payments.count{
            for j in 0..<payments[i].count{
                let value = payments[i][j].cost
                let day = Calendar.getFormatedDate(by: "day", date: payments[i][j].at)
                if(Calendar.isInWeek(day: day)){
                    cost+=value
                }
            }
        }
        return cost
    }
    
    
    static func getCostInCurrentDay(payments: [[Payment]])->Float{
        var cost: Float = 0.0
        for i in 0..<payments.count{
            for j in 0..<payments[i].count{
                let value = payments[i][j].cost
                let day = Calendar.getFormatedDate(by: "day", date: payments[i][j].at)
                let currentDay = Calendar.getFormatedDate(by: "day", date: Calendar.getFullDate())
                if(day == currentDay ){
                    cost+=value
                }
            }
        }
        return cost
    }
    
}

