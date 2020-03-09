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
    static func getCurrentMonthInAr()->String{
        let current = getDate().split(separator: "/")
        let month = current[0]
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
    
    
}
