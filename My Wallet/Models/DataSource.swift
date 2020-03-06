//
//  DataSource.swift
//  My Wallet
//
//  Created by Safwan Saigh on 06/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import Firebase


protocol DataSourceProtocol {
    func paidDataUpdated(data:[[Payment]])
    func unpaidDataUpdated(data: [Payment])
    func userDataUpdated(data: [String:Any])
}


class DataSource{
    var unpaidPaymentsList = [Payment]()
    var paidPaymentsList = [[Payment](),[Payment](),[Payment](),[Payment](),[Payment](),[Payment](),[Payment]()]
    var db = Firestore.firestore()
    var dataSourceDelegate: DataSourceProtocol?
    var userData = [String:Any]()
    var type: String
    
    init(type: String){
        self.type = type
        if(type == "uppayment"){
            self.getData(type)
            self.getUserInfo()
        }else{
            self.getData(type)
            self.getUserInfo()
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
            }
        }
        if(type == "uppayment"){
            for i in 0...costs.count-1{
                unpaidPaymentsList.append(Payment(titles[i], Float(costs[i])!, types[i], paids[i], ats[i]))
            }
            return unpaidPaymentsList
        }else{
            for i in 0...costs.count-1{
                if types[i] == "أخرى"{
                    paidPaymentsList[0].append(Payment(titles[i], Float(costs[i])!, types[i], paids[i], ats[i]))
                }else if types[i] == "صحة"{
                    paidPaymentsList[1].append(Payment(titles[i], Float(costs[i])!, types[i], paids[i], ats[i]))
                }else if types[i] == "ترفيه"{
                    paidPaymentsList[2].append(Payment(titles[i], Float(costs[i])!, types[i], paids[i], ats[i]))
                }else if types[i] == "مواصلات"{
                    paidPaymentsList[3].append(Payment(titles[i], Float(costs[i])!, types[i], paids[i], ats[i]))
                }else if types[i] == "طعام"{
                    paidPaymentsList[4].append(Payment(titles[i], Float(costs[i])!, types[i], paids[i], ats[i]))
                }else if types[i] == "تسوق"{
                    paidPaymentsList[5].append(Payment(titles[i], Float(costs[i])!, types[i], paids[i], ats[i]))
                }else if types[i] == "وقود"{
                    paidPaymentsList[6].append(Payment(titles[i], Float(costs[i])!, types[i], paids[i], ats[i]))
                }
            }
            return paidPaymentsList
        }
    }
    
    
    func clearArray(){
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
            }else{
                for doc in documents{
                    self.paidPaymentsList = self.dataCleaner(data: doc.data(), type) as! [[Payment]]
                }
                if self.paidPaymentsList.capacity>=0{
                    self.dataSourceDelegate?.paidDataUpdated(data: self.paidPaymentsList)
                        }
            }
        }
    }
    
    
    func getUserInfo(){
        db.collection("user").document(getID())
        .addSnapshotListener { documentSnapshot, error in
          guard let document = documentSnapshot else {
            print("Error fetching document: \(error!)")
            return
          }
          guard let data = document.data() else {
            print("Document data was empty.")
            return
          }
            self.dataSourceDelegate?.userDataUpdated(data: data)
        }
    }
    
    
    
    
}
