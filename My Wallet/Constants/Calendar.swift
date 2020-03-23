//
//  Calendar.swift
//  My Wallet
//
//  Created by Safwan Saigh on 09/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation
import Firebase
class Calendar{
    
    static var categ = ""
    static var side = -1
    
    
    static func genetrateDays()->[String]{
        var days = [String]()
        for i in 1..<32{
            days.append(String(i))
        }
        return days
    }
    
    
    static func getID()->String{
        return Auth.auth().currentUser!.uid
    }
    
    
    static func getDate()->String{
           let date = Date()
           let format = DateFormatter()
           format.dateFormat = "MM/dd"
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
        return getID()+"_Budget_"+getCurrentMonth()+"_"+getCurrentYear()
    }
    
    
    static func getMaxDayInCurrentMonth()->Int{
        let date = Date()
        let cal = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)!
        let days = cal.range(of: .day, in: .month, for: date)
        return days.upperBound-1
    }
    
    
    static func getTheDayOfBill(day: String)->String{
        let dayInt:Int = Int(day)!
        var validDay = ""
        if(dayInt <= getMaxDayInCurrentMonth()){
            validDay = String(dayInt)
        }else{
            validDay = String(getMaxDayInCurrentMonth())
        }
        if(validDay.count < 2){
            validDay = "0"+validDay
        }
        return validDay
    }
    
}
