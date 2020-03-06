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
    func unpaidDataUpdated(data: [String])
    func userDataUpdated(data: [String:Any])
}


class DataSource{
    

    
    var unpaidList = [String]()
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
    
    func toArray(data:[String:Any])->[String]{
        //This method convert a Dictionary from the DataBase to array
        var costs = [String]()
        var titles = [String]()
        var ats = [String]()
        var types = [String]()
        
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
                    }else if key == "Paid"{}
        }
        for i in 0...costs.count-1{
            unpaidList.append(titles[i]+","+costs[i]+","+types[i]+","+ats[i])//TODO
        }
        return unpaidList
    }
    
    func clearArray(){
        unpaidList.removeAll()
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
                self.unpaidList = self.toArray(data: doc.data())
            }
            print("From Data Source2",self.unpaidList.capacity)
            if self.unpaidList.capacity>=0{
                self.dataSourceDelegate?.unpaidDataUpdated(data: self.unpaidList)
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
