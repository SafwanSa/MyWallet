//
//  Calendar.swift
//  My Wallet
//
//  Created by Safwan Saigh on 09/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation

class Calendar{
    
    static var categ = ""
    
    static func getDate()->String{
           let date = Date()
           let format = DateFormatter()
           format.dateFormat = "MM/DD"
           let formattedDate = format.string(from: date)
           return formattedDate
       }
    
    static func getCurrentYear()->String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "YYYY"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    static func getMonthInAr(m: String)->String{
        var month = ""
        if (m == "auto"){
            let current = getDate().split(separator: "/")
            month = String(current[0])
        }else{
            month = m
        }

        var monthInAr = ""

        switch month {
        case "01":
            monthInAr = "يناير"
        case "02":
            monthInAr = "فبراير"
        case "03":
            monthInAr = "مارس"
        case "04":
            monthInAr = "أبريل"
        case "05":
            monthInAr = "مايو"
        case "06":
            monthInAr = "يونيو"
        case "07":
            monthInAr = "يوليو"
        case "08":
            monthInAr = "أغسطس"
        case "09":
            monthInAr = "سبتمبر"
        case "10":
            monthInAr = "أكتوبر"
        case "11":
            monthInAr = "نوفمبر"
        case "12":
            monthInAr = "ديسمبر"
        default:
            monthInAr = ""
                
        }
        return monthInAr
    }
    
    static func getCurrentMonth()->String{
        return String(getDate().split(separator: "/")[0])
    }
    
    static func getFormatedDate(by: String, date: String)->String{
        if(by == "month"){
            return String(date.split(separator: "/")[0])
        }
        let formated = date.split(separator: "/")[1]
        if(by == "day"){
            return String(formated.split(separator: " ")[0])
        }else if(by == "time"){
            return String(formated.split(separator: " ")[1])
        }
        return "invalid"
    }
    
    
    static func getBudgetId()->String{
        return "Budget_"+getCurrentMonth()+"_"+getCurrentYear()
    }
    
}
