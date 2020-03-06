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
    func unpaidDataUpdated(data: [Payment])
    func userDataUpdated(data: [String:Any])
}


class DataSource{
    

    
    var unpaidPaymentsList = [Payment]()
    var db = Firestore.firestore()
    var dataSourceDelegate: DataSourceProtocol?
    var userData = [String:Any]()
    
    
    init(){
        self.getUnpaidData()
        self.getUserInfo()
    }
    
    func getID()->String{
        return Auth.auth().currentUser!.uid
    }
    
    func toArray(data:[String:Any])->[Payment]{
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
        for i in 0...costs.count-1{
            unpaidPaymentsList.append(Payment(titles[i], Float(costs[i])!, types[i], paids[i], ats[i]))
        }
        return unpaidPaymentsList
    }
    
    func clearArray(){
        unpaidPaymentsList.removeAll()
    }
    
    
    
    
    func getUnpaidData(){
        clearArray()
        db.collection("uppayment").whereField("uid", isEqualTo: getID())
        .addSnapshotListener { documentSnapshot, error in
            guard let documents = documentSnapshot?.documents else {
            print("Error fetching document: \(error!)")
            return
          }
            self.clearArray()
            for doc in documents{
                self.unpaidPaymentsList = self.toArray(data: doc.data())
            }
            if self.unpaidPaymentsList.capacity>=0{
                self.dataSourceDelegate?.unpaidDataUpdated(data: self.unpaidPaymentsList)
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
