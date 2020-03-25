//
//  Bill.swift
//  My Wallet
//
//  Created by Safwan Saigh on 21/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class Bill: Payment{
    
    var lastUpdate: String
    
    init(_ title: String, _ cost: Float, _ day: String, _ at: String, lastUpd: String) {
        self.lastUpdate = lastUpd
        super.init(title, cost, "فواتير", false, at)
        self.day = day
    }
    
    override func addPayemnt() {
        db.collection("uppayment").document().setData(["Title":self.title, "Cost":self.cost, "At":self.at,"Type":self.type, "Paid":self.paid,"Day":self.day,"uid":getID()])
    }
    
    
    func updateBillLastUpdate(id: String, lastUpdate: String){
        db.collection("uppayment").whereField("At", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.db.collection("uppayment").document(document.documentID).updateData(["Last Updated": lastUpdate, "Paid": true])
                    }
                }
        }
    }
    
    func addBillToPaidList() {
        db.collection("ppayment").document().setData(["Title":self.title, "Cost":self.cost, "At":self.at,"Type":self.type, "Paid": true,"Day":self.day,"uid":getID()])
    }
    
    
}
