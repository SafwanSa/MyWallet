//
//  NotificationsHandler.swift
//  My Wallet
//
//  Created by Safwan Saigh on 25/04/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation
import UserNotifications
import FirebaseAuth



class NotificationsHandler{
    
    static var lang: String?
    
    static var arabicBodies = ["شهر جديد بدأ، لا تنسى تراجع معلوماتك المالية", "شكلك نسيت تضيف مدفوعات اليوم!", "عندك مدفوعات غير مدفوعة، تكفى لا تسحب عليهم", "عندك فواتير صدرت اليوم"]
    static var englishBodies = ["Do not forget to revise your budget", "Did you forget to add today's payments?", "You have some payments in the unpaid list, do not forget to pay them", "You have a new bill"]
    
    static func setNotifications(){
        self.newBill()
        var allNotifications = [[Any]]()
        allNotifications.append(newMonth())
        allNotifications.append(addPayments())

        for i in 0..<allNotifications.count{
            scheduleNotification(title: allNotifications[i][0] as! String, body: allNotifications[i][1] as! String, ident: allNotifications[i][2] as! String, components: allNotifications[i][3] as! DateComponents, re: false, interval: 0)
        }
        
    }
    
    static func askForPermission(){
        lang = String(NSLocale.preferredLanguages[0].split(separator: "-")[0])
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print("granted: (\(granted)")
        }
    }
    
    static func scheduleNotification(title: String, body: String, ident: String, components: DateComponents, re: Bool, interval: Int){
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = title
        content.body = body
        if interval == 0{
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: re)
            let request = UNNotificationRequest(identifier: ident, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }else{
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval), repeats: true)
            let request = UNNotificationRequest(identifier: ident, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    func isLogedIn()->Bool{
        if Auth.auth().currentUser != nil{
            return true
        }else{
            return false
        }
    }
    
    static func newMonth()->[Any]{
        var year = Int(Calendar.getCurrentYear())
        var month = Int(Calendar.getCurrentMonth())
        if month == 12{
            month = 1
            year = year! + 1
        }else{
            month = month! + 1
        }
        let components = DateComponents(calendar: .current, timeZone: .autoupdatingCurrent, year: year, month: month, day: 01, hour: 00)
        var title = "Reminder"
        var body = self.englishBodies[0]
        let identifier = "Reminder0"
        if lang == "ar"{
            title = "تذكير"
            body = arabicBodies[0]
        }
        return [title, body, identifier, components]
    }
     
    static func addPayments()->[Any]{
        let year = Int(Calendar.getCurrentYear())
        let month = Int(Calendar.getCurrentMonth())
        let day = Int(Calendar.getFormatedDate(by: "day", date: Calendar.getFullDate()))
        let components = DateComponents(calendar: .current, timeZone: .autoupdatingCurrent, year: year, month: month, day: day, hour: 00)
        var title = "Reminder"
        var body = self.englishBodies[1]
        let identifier = "Reminder0"
        if lang == "ar"{
            title = "تذكير"
            body = arabicBodies[1]
        }
        return [title, body, identifier, components]
    }
    
    static func newBill(){
        DataBank.shared.getUnpaidPayemnts { (payments) in
            var days = [Int]()
            var identifiers = [String]()
            for payment in payments{
                if payment.type == "فواتير"{
                    let bill = payment as! Bill
                    days.append(Int(bill.day)!)
                    identifiers.append("BillReminder"+bill.day)
                }
            }
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
            var title = "Reminder"
            var body = self.englishBodies[3]
            if self.lang == "ar"{
                title = "تذكير"
                body = self.arabicBodies[3]
            }
            for day in days{
                let identifier = "BillReminder"+String(day)
                let components = DateComponents(calendar: .current, timeZone: .autoupdatingCurrent, day: day, hour: 00)
                self.scheduleNotification(title: title, body: body, ident: identifier, components: components, re: true, interval: 0)
            }
        }
    }
    
    static func payPayments(){
        DataBank.shared.getUnpaidPayemnts { (payments) in
            var identifiers = [String]()
            for payment in payments{
                if payment.type != "فواتير"{
                    identifiers.append("UnpaidReminder"+payment.at)
                }
            }
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
            var title = "Reminder"
            var body = self.englishBodies[2]
            if self.lang == "ar"{
                title = "تذكير"
                body = self.arabicBodies[2]
            }
            for ident in identifiers{
                let identifier = ident
                self.scheduleNotification(title: title, body: body, ident: identifier, components: DateComponents(), re: true, interval: 86400)
            }
        }
    }
    
    
    
}
