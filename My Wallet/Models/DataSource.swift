//
//  DataSource.swift
//  My Wallet
//
//  Created by Safwan Saigh on 06/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import Firebase


protocol DataSourceProtocol{
    func paidDataUpdated(data:[[Payment]])
    func unpaidDataUpdated(data: [Payment])
    func userDataUpdated(data: [String:Any], which: String)
    func getMonths(months: [String])
    func getCosts(costs: [Float])
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
    var costs = [Float]()
    
    init() {
        self.type = ""
        self.getUserInfoWhenUpdated()
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
        for i in data{
            let key = i.key
            let value = i.value
                    if key == "Cost"{
                        let q = value as? NSNumber
                        costs.append("\(q!.stringValue)")
                        self.costs.append(Float(truncating: q!))
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
            }
        }
        if(type == "uppayment"){
            for i in 0...costs.count-1{
                //If it is a bill
                if(types[i] == "فواتير"){
                        let currentDay = Calendar.getFormatedDate(by: "day", date: Calendar.getDate())
                        //If it is in this day
                        if(days[i] == currentDay){
                            let bill = Bill(titles[i], Float(costs[i])!,days[i], ats[i])
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
                    }else if types[i] == "وقود"{
                        paidPaymentsList[6].append(payment)
                    }
            }
            //If category == current month, remove evrey thing not in that month
            for i in 0..<paidPaymentsList.count{
                paidPaymentsList[i].removeAll { (payment) -> Bool in
                    let month = Calendar.getFormatedDate(by: "month", date: payment.at)
                    let check1 = (month != Calendar.categ)
                    let check2 = (Calendar.categ != "")
                    return check1 && check2
                }
            }
            //Sorting thr array by date
            for i in 0..<paidPaymentsList.count{
                paidPaymentsList[i].sort(by: { $0.at.compare($1.at) == .orderedDescending })
            }
            dataSourceDelegate?.getCosts(costs: self.costs)
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
                    self.dataSourceDelegate?.unpaidDataUpdated(data: self.unpaidPaymentsList)
                }
            }else if(type == "ppayment"){
                for doc in documents{
                    self.paidPaymentsList = self.dataCleaner(data: doc.data(), type) as! [[Payment]]
                }
                if self.paidPaymentsList.capacity>=0{
                    self.dataSourceDelegate?.paidDataUpdated(data: self.paidPaymentsList)
                }
            }
        }
    }
    
    
    func getUserInfoWhenUpdated(){
        let info = ["budgets","user"]
        var doc = getID()
        for dt in info{
            if(dt == "budgets"){
                doc = Calendar.getBudgetId()
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
                return
              }
                self.dataSourceDelegate?.userDataUpdated(data: data, which: dt)
            }
        }
    }
    
    func updateUserInformation(data: [String:Float]){
        db.collection("budgets").document(Calendar.getBudgetId()).updateData(data)
    }
    
    
    func getPaymentsMonths(data: [[Payment]]) -> [String]{
        var tempArray = [String]()
        for i in 0..<data.count-1{
            for j in data[i]{
                let date = j.at
                let m = Calendar.getFormatedDate(by: "month", date: date)
                if(m != Calendar.getCurrentMonth()){
                    tempArray.append(m)
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
                    self.dataSourceDelegate?.getMonths(months: self.months)
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