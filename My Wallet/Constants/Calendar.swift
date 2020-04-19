//
//  Calendar.swift
//  My Wallet
//
//  Created by Safwan Saigh on 09/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation
import FirebaseAuth 
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
    
    static func getFullDate()->String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MM/dd/YYYY HH:mm:ss"
        let formattedDate = format.string(from: date)
        return formattedDate
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
        //"04/10/2020 19:46:09"
        if(by == "month"){
            return String(date.split(separator: "/")[0])
        }
        if(by == "day"){
            return String(date.split(separator: "/")[1])
        }
        let formated = date.split(separator: "/")[2]
        if(by == "year"){
            return  String(formated.split(separator: " ")[0])
        }
        if(by == "time"){
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
    
    static func getWeekRange()->[String]{
        var results = [String]()
        let dt = getCurrentYear()+"-"+getCurrentMonth()+"-"
        let maxDay = getMaxDayInCurrentMonth()
        var sundays = [Int]()
        var saturdays = [Int]()
        var d = ""
        for i in 1...maxDay{
            if i < 10{d = dt+"0"+String(i)}
            else{d = dt+String(i)}
            if getDayNameBy(stringDate: d) == "Sunday"{
                sundays.append(i)
            }else if getDayNameBy(stringDate: d) == "Saturday"{
                if i >= 7{saturdays.append(i)}
            }
        }
        var min = saturdays.count
        if sundays.count < saturdays.count{min = sundays.count}
        for i in 0 ..< min{results.append(String(sundays[i])+","+String(saturdays[i]))}
        return results
    }
    
    static func isInWeek(day: String)->Bool{
        let dayInt = Int(day)
        var rangee = getWeekRange()
        rangee.append("01,"+rangee[0].split(separator: ",")[0])
        var inRange = false
        for i in rangee{
            inRange = false
            let sun = Int(i.split(separator: ",")[0])!
            let sat = Int(i.split(separator: ",")[1])!
            if dayInt! >= sun && dayInt! <= sat{
                inRange = true
            }
        }
        return inRange
    }
    
    static func getDayNameBy(stringDate: String) -> String
    {
        let df  = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        let date = df.date(from: stringDate)!
        df.dateFormat = "EEEE"
        return df.string(from: date);
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
    
    static func isValidBill(day: String,lastUpdate: String, billAt: String)->Bool{
        let billDay = Int(day)!//30
              let currentDay = Int(getFormatedDate(by: "day", date: getDate()))!//1
              let currentMonth = Int(getFormatedDate(by: "month", date: getDate()))!//04
              var lastUpdateMonth = 0
              var showBill = false
              var validUpdate = false
              if lastUpdate == ""{
                  lastUpdateMonth = Int(getFormatedDate(by: "month", date: billAt))!//03
                  if lastUpdateMonth == currentMonth{
                      if(currentDay >= billDay){return true}
                  }else{return true}
                 
              }else{
                  lastUpdateMonth = Int(getFormatedDate(by: "month", date: lastUpdate))!
                  if lastUpdateMonth != currentMonth{
                      validUpdate = true
                  }
              }
              if validUpdate{
                  if currentDay >= billDay{
                      showBill = true
                  }else if(currentDay < billDay){
                      if(currentMonth - lastUpdateMonth) > 1{
                          showBill = true
                      }
                  }
              }
              return showBill
    }
    
}


