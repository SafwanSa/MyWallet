//
//  DataBank.swift
//  My Wallet
//
//  Created by Safwan Saigh on 16/04/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DataBank{
    
    static var shared = DataBank()
    
    var unpaidPaymentsList = [Payment]()
    var paidPaymentsList = [[Payment](),[Payment](),[Payment](),[Payment](),[Payment](),[Payment](),[Payment]()]
    
    var db = Firestore.firestore()
    var category = ""
    var months = [String]()
    var budgets = [Budget]()
    
    
    func getPaymentID(id: String)->String{
           let a = Calendar.getFormatedDate(by: "day", date: id)
           let b = Calendar.getFormatedDate(by: "month", date: id)
           let c = Calendar.getFormatedDate(by: "time", date: id)
           return a+"_"+b+"_"+c+"_"+getID()
    }
       
    func getID()->String{
           return Auth.auth().currentUser!.uid
    }
    
    func createPaidPayment(document: [String:Any])->Payment{
        return Payment(document["Title"] as! String, document["Cost"] as! Float, document["Type"] as! String, true, document["At"] as! String)
    }
    
    func createUnpaidPayment(document: [String:Any])->Payment{
           if document["Type"] as! String == "فواتير"{
            return Bill(document["Title"] as! String, document["Cost"] as! Float, document["Day"] as! String, document["At"] as! String, lastUpd: document["Last Updated"] as? String ?? "")
           }
           return createPaidPayment(document: document)
    }
    
    func clearArray(){
        budgets.removeAll()
        months.removeAll()
        unpaidPaymentsList.removeAll()
        for i in 0 ... paidPaymentsList.count - 1{
            paidPaymentsList[i].removeAll()
        }
    }
    
    func isValidPayemnt(_ payment: Payment)->Bool{
        let month = Calendar.getFormatedDate(by: "month", date: payment.at)
        let year = Calendar.getFormatedDate(by: "year", date: payment.at)
        if(Calendar.categ == ""){return false}
        let categMonth = Calendar.categ.split(separator: "/")[0]//03
        let categYear = Calendar.categ.split(separator: "/")[1]//2020
        if year == categYear && month == categMonth{
            return true
        }
        return false
    }
    
    func getUnpaidPayemnts(complete: @escaping([Payment])->Void){
        db.collection("uppayment").whereField("uid", isEqualTo: getID())
            .addSnapshotListener { documentSnapshot, error in
                guard let documents = documentSnapshot?.documents else {
                    print("Error fetching document: \(error!)")
                        return
                }
                self.clearArray()
                for doc in documents{
                    let payment = self.createUnpaidPayment(document: doc.data())
                    self.unpaidPaymentsList.append(payment)
                }
                self.unpaidPaymentsList.sort(by: { $0.at.compare($1.at) == .orderedDescending })
                complete(self.unpaidPaymentsList)
            }
    }
    
    func getPaidPayemnts(all: Bool, complete: @escaping([[Payment]])->Void){
        db.collection("ppayment").whereField("uid", isEqualTo: getID())
            .addSnapshotListener { documentSnapshot, error in
                guard let documents = documentSnapshot?.documents else {
                    print("Error fetching document: \(error!)")
                    return
                }
                self.clearArray()
                for doc in documents{
                    let payment = self.createPaidPayment(document: doc.data())
                    var validPayemnt = self.isValidPayemnt(payment)
                    
                    //If we are requesting all the payments
                    if all{validPayemnt = true}
                    
                    if payment.type == "أخرى" && validPayemnt{
                        self.paidPaymentsList[0].append(payment)
                    }else if payment.type == "صحة" && validPayemnt{
                        self.paidPaymentsList[1].append(payment)
                    }else if payment.type == "ترفيه" && validPayemnt{
                        self.paidPaymentsList[2].append(payment)
                    }else if payment.type == "مواصلات" && validPayemnt{
                        self.paidPaymentsList[3].append(payment)
                    }else if payment.type == "طعام" && validPayemnt{
                        self.paidPaymentsList[4].append(payment)
                    }else if payment.type == "تسوق" && validPayemnt{
                        self.paidPaymentsList[5].append(payment)
                    }else if payment.type == "فواتير" && validPayemnt{
                        self.paidPaymentsList[6].append(payment)
                    }
                }
                //Sorting the array by the date
                for i in 0..<self.paidPaymentsList.count{
                    self.paidPaymentsList[i].sort(by: { $0.at.compare($1.at) == .orderedDescending })
                }
                complete(self.paidPaymentsList)
            }
    }
    
    func getBudgets(complete: @escaping ([Budget])->Void){
        db.collection("budgets").whereField("uid", isEqualTo:getID())
            .addSnapshotListener { documentSnapshot, error in
            guard let documents = documentSnapshot?.documents else {
                print("Error fetching document: \(error!)")
                    return
            }
            self.clearArray()
            for doc in documents{
                let data = doc.data()
                let budget = Budget(amount: data["Start Amount"] as! Float, savings: data["Savings"] as! Float, dGoal: data["dailyCostGoal"] as! Float, wGoal: (data["weeklyCostGoal"] as! NSNumber).floatValue)
                budget.current_amount = (data["Current Amount"] as! NSNumber).floatValue
                budget.bid = data["bid"] as! String
                self.budgets.append(budget)
            }
                complete(self.budgets)
        }
    }
    
    func getUserInfo(complete: @escaping (UserInfo)->Void){
        db.collection("user").document(getID()).addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot?.data() else{
                print("Error fetching document: \(error!)")
                    return
            }
            let user = UserInfo(name: document["Name"] as! String, email: document["Email"] as! String, id: self.getID(), income: document["Income"] as! Float)
            complete(user)
        }
    }
    
    func getCurrentBudget(complete: @escaping (Budget)->Void){
        getBudgets { (busgetsList) in
            for b in busgetsList{
                if b.bid == Calendar.getBudgetId(){
                    complete(b)
                    return
                }
            }
            self.addPreviuosInfo()
        }
    }
    
    func addPreviuosInfo(){
        var prevYear = String(Int(Calendar.getCurrentYear())!)
        var prevMonth = String(Int(Calendar.getCurrentMonth())! - 1)
        
        if Int(Calendar.getCurrentMonth()) == 1{
            prevYear = String(Int(Calendar.getCurrentYear())! - 1)
            prevMonth = "12"
        }
        if prevMonth.count == 1{
            prevMonth = "0"+prevMonth
        }
        
        let budget = getID()+"_Budget_"+prevMonth+"_"+prevYear
        db.collection("budgets").document(budget).getDocument { (DocumentSnapshot, Error) in
            guard let previuosBudget = DocumentSnapshot?.data() else{
                print("He has no previuos budgets... never happens", budget)
                return
            }
            let budget = Budget(amount: previuosBudget["Start Amount"] as! Float, savings: previuosBudget["Savings"] as! Float, dGoal: previuosBudget["dailyCostGoal"] as! Float, wGoal: previuosBudget["weeklyCostGoal"] as! Float)
            budget.setBudgetData()
        }
    }
    func updateUserData(data: [String:Any]){
        db.collection("user").document(getID()).updateData(data)
    }
    
    func updateBudget(data: [String:Any]){
        var newData = data
        newData["uid"] = getID() as String
        newData["bid"] = Calendar.getBudgetId() as String
        db.collection("budgets").document(Calendar.getBudgetId()).setData(newData)
    }
    
    func getMonths(complete: @escaping ([String])->Void){
        getPaidPayemnts(all: true) { (paidList) in
            var paidL = [Payment]()
            for list in paidList{
                for payemnt in list{
                    paidL.append(payemnt)
                }
            }
            self.getPaymentsMonths(payments: paidL)
            complete(self.months)
        }
    }
    func getPaymentsMonths(payments: [Payment]){
        for payment in payments{
            let date = payment.at
            let m = Calendar.getFormatedDate(by: "month", date: date)//03
            let y = Calendar.getFormatedDate(by: "year", date: date)//2020
            let currentMonth = Calendar.getCurrentMonth()//03
            let currentYear = Calendar.getFormatedDate(by: "year", date: Calendar.getFullDate())//2020
                if y == currentYear{
                    if m != currentMonth{
                        //Include
                        self.months.append(String(m+"/"+y))
                    }
                }else{
                    //Include
                    self.months.append(String(m+"/"+y))
                }
        }
        self.months = self.months.removingDuplicates()
    }
}
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
