//
//  DataSource.swift
//  My Wallet
//
//  Created by Safwan Saigh on 06/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


@objc protocol DataSourceProtocol{
    @objc optional func paidDataUpdated(data:[[Payment]])
    @objc optional func unpaidDataUpdated(data: [Payment])
    @objc optional func userDataUpdated(data: [String:Any], which: String)
    @objc optional func getMonths(months: [String])
    @objc optional func getPrevBudgets(budgets: [Budget])
}


class DataSource{
    
    var unpaidPaymentsList = [Payment]()
    var paidPaymentsList = [[Payment](),[Payment](),[Payment](),[Payment](),[Payment](),[Payment](),[Payment]()]
    var db = Firestore.firestore()
    var dataSourceDelegate: DataSourceProtocol?
    var userData = [String:Any]()
    var type: String
    var category = ""
    var months = [String]()
    var budgets = [Budget]()
    
    init() {
        self.type = ""
        self.getUserInfoWhenUpdated()
        self.getPreviuosBudgets()
    }
    
    init(type: String){
        self.type = type
        if(type == "uppayment"){
            self.getData(type)
            self.getUserInfoWhenUpdated()
        }else if(type == "ppayment"){
            self.getData(type)
            self.getUserInfoWhenUpdated()
        }else if(type == "months"){
            self.getMonthsData()
            self.getUserInfoWhenUpdated()
        }
    }
    
    func getPaymentID(id: String)->String{
        let a = Calendar.getFormatedDate(by: "day", date: id)
        let b = Calendar.getFormatedDate(by: "month", date: id)
        let c = Calendar.getFormatedDate(by: "time", date: id)
        return a+"_"+b+"_"+c+"_"+getID()
    }
    
    func getID()->String{
        return Auth.auth().currentUser!.uid
    }
    
    
    func dataCleaner(data:[String:Any], _ type: String)-> Any{
        //This method convert a Dictionary from the DataBase to array
        var costs = [String]()
        var titles = [String]()
        var ats = [String]()
        var types = [String]()
        var paids = [Bool]()
        var days = [String]()
        var lastUpdates = [String]()
        for i in data{
            let key = i.key
            let value = i.value
            if key == "Cost"{
                let q = value as? NSNumber
                costs.append("\(q!.stringValue)")
            }else if key == "Title"{
                titles.append("\((value as? String)!)")
            }else if key == "At"{
                ats.append("\((value as? String)!)")
            }else if key == "Type"{
                types.append("\((value as? String)!)")
            }else if key == "Paid"{
                paids.append((value as? Bool)!)
            }else if key == "Day"{
                days.append("\((value as? String)!)")
            }else if key == "Last Updated"{
                lastUpdates.append("\((value as? String)!)")
            }
        }
        if(type == "uppayment"){
            for i in 0...costs.count-1{
                if(types[i] == "فواتير"){
                    if(lastUpdates.count>0){
                        let bill = Bill(titles[i], Float(costs[i])!, days[i], ats[i], lastUpd: lastUpdates[i])
                        unpaidPaymentsList.append(bill)
                    }else{
                        let bill = Bill(titles[i], Float(costs[i])!, days[i], ats[i], lastUpd: "")
                        unpaidPaymentsList.append(bill)
                    }
                }else{
                    let payment = Payment(titles[i], Float(costs[i])!, types[i], paids[i], ats[i])
                    unpaidPaymentsList.append(payment)
                }
            }
            //Sorting the array by the date
            unpaidPaymentsList.sort(by: { $0.at.compare($1.at) == .orderedDescending })
            return unpaidPaymentsList
        }else{
            for i in 0...costs.count-1{
                let payment = Payment(titles[i], Float(costs[i])!, types[i], paids[i], ats[i])
                if types[i] == "أخرى"{
                    paidPaymentsList[0].append(payment)
                }else if types[i] == "صحة"{
                    paidPaymentsList[1].append(payment)
                }else if types[i] == "ترفيه"{
                    paidPaymentsList[2].append(payment)
                }else if types[i] == "مواصلات"{
                    paidPaymentsList[3].append(payment)
                }else if types[i] == "طعام"{
                    paidPaymentsList[4].append(payment)
                }else if types[i] == "تسوق"{
                    paidPaymentsList[5].append(payment)
                }else if types[i] == "فواتير"{
                    paidPaymentsList[6].append(payment)
                }
            }
            //If category == current month, remove evrey thing not in that month
            for i in 0..<paidPaymentsList.count{
                paidPaymentsList[i].removeAll { (payment) -> Bool in
                    let month = Calendar.getFormatedDate(by: "month", date: payment.at)
                    let year = Calendar.getFormatedDate(by: "year", date: payment.at)
                    if(Calendar.categ == ""){return false}
                    let categMonth = Calendar.categ.split(separator: "/")[0]//03
                    let categYear = Calendar.categ.split(separator: "/")[1]//2020
                    if year == categYear{
                        if month == categMonth{
                            //Do not remove
                            return false
                        }else{
                            //Remove
                            return true
                        }
                    }else{
                        if month == categMonth{
                            //Remove
                            return true
                        }else{
                            //Remove
                            return true
                        }
                    }
                }
            }
            //Sorting thr array by date
            for i in 0..<paidPaymentsList.count{
                paidPaymentsList[i].sort(by: { $0.at.compare($1.at) == .orderedDescending })
            }
            return paidPaymentsList
        }
    }
    
    
    func clearArray(){
        months.removeAll()
        unpaidPaymentsList.removeAll()
        for i in 0 ... paidPaymentsList.count - 1{
            paidPaymentsList[i].removeAll()
        }
    }
    
    
    
    func getData(_ type: String){
        db.collection(type).whereField("uid", isEqualTo: getID())
            .addSnapshotListener { documentSnapshot, error in
                guard let documents = documentSnapshot?.documents else {
                    print("Error fetching document: \(error!)")
                    return
                }
                self.clearArray()
                if(type == "uppayment"){
                    for doc in documents{
                        self.unpaidPaymentsList = self.dataCleaner(data: doc.data(), type) as! [Payment]
                    }
                    if self.unpaidPaymentsList.capacity>=0{
                        self.dataSourceDelegate?.unpaidDataUpdated?(data: self.unpaidPaymentsList)
                    }
                }else if(type == "ppayment"){
                    for doc in documents{
                        self.paidPaymentsList = self.dataCleaner(data: doc.data(), type) as! [[Payment]]
                    }
                    if self.paidPaymentsList.capacity>=0{
                        self.dataSourceDelegate?.paidDataUpdated?(data: self.paidPaymentsList)
                    }
                }
        }
    }
    
    
    func addPreviuosInfo(){
        //If the previuos was 12 !!!?. Look at the current year
        // if 12 preM = 1,
        var prevMonth = String(Int(Calendar.getCurrentMonth())! - 1)
        if prevMonth.count == 1{
            prevMonth = "0"+prevMonth
        }
        let budget = getID()+"_Budget_"+prevMonth+"_"+Calendar.getCurrentYear()
        db.collection("budgets").document(budget).getDocument { (DocumentSnapshot, Error) in
            guard let previuosBudget = DocumentSnapshot?.data() else{
                print("He has no previuos budgets... never happens", budget)
                return
            }
            let budget = Budget(amount: previuosBudget["Start Amount"]! as! Float, savings: previuosBudget["Savings"]! as! Float)
            budget.setBudgetData()
        }
    }
    
    func getPreviuosBudgets(){
        db.collection("budgets").whereField("uid", isEqualTo: getID()).getDocuments { (querySnapshot, error) in
            if let docs = querySnapshot?.documents{
                for doc in docs{
                    let data = doc.data()
                    let budget = Budget(amount: data["Start Amount"] as! Float, savings: data["Savings"] as! Float)
                    budget.current_amount = data["Current Amount"] as! Float
                    budget.bid = data["bid"] as! String
                    self.budgets.append(budget)
                }
                self.dataSourceDelegate?.getPrevBudgets?(budgets: self.budgets)
            }else{
                //Erorr
                print("Error")
            }
        }
    }
    
    func getUserInfoWhenUpdated(){
        let info = ["budgets","user","goals"]
        var doc = getID()
        for dt in info{
            if(dt == "budgets"){
                doc = Calendar.getBudgetId()
            }else if dt == "user"{
                doc = getID()
            }else{
                doc = getID()
            }
            db.collection(dt).document(doc)
                .addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    guard let data = document.data() else {
                        print("Document data was empty.")
                        print("No info")
                        if dt == "budgets"{
                            self.addPreviuosInfo()
                        }
                        return
                    }
                    self.dataSourceDelegate?.userDataUpdated?(data: data, which: dt)
            }
        }
    }
    
    func updateUserInformation(data: [String:Any]){
        var newData = data
        newData["uid"] = getID() as String
        newData["bid"] = Calendar.getBudgetId() as String
        db.collection("budgets").document(Calendar.getBudgetId()).setData(newData)
    }
    
    
    func getPaymentsMonths(data: [[Payment]]) -> [String]{
        var tempArray = [String]()
        for i in 0..<data.count-1{
            for j in data[i]{
                let date = j.at
                let m = Calendar.getFormatedDate(by: "month", date: date)//03
                let y = Calendar.getFormatedDate(by: "year", date: date)//2020
                let currentMonth = Calendar.getCurrentMonth()//03
                let currentYear = Calendar.getFormatedDate(by: "year", date: Calendar.getFullDate())//2020
                if y == currentYear{
                    if m != currentMonth{
                        //Include
                        tempArray.append(String(m+"/"+y))
                    }
                }else{
                    //Include
                    tempArray.append(String(m+"/"+y))
                }
            }
        }
        tempArray = tempArray.removingDuplicates()
        self.months = tempArray
        return self.months
    }
    
    
    func getMonthsData(){
        db.collection("ppayment").whereField("uid", isEqualTo: getID())
            .addSnapshotListener { documentSnapshot, error in
                guard let documents = documentSnapshot?.documents else {
                    print("Error fetching document: \(error!)")
                    return
                }
                self.clearArray()
                for doc in documents{
                    self.months = self.getPaymentsMonths(data: self.dataCleaner(data: doc.data(), "ppayment") as! [[Payment]])
                }
                if self.months.capacity>=0{
                    self.dataSourceDelegate?.getMonths?(months: self.months)
                }
        }
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
