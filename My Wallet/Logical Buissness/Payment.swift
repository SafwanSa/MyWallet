//
//  Payment.swift
//  My Wallet
//
//  Created by Safwan Saigh on 27/09/2019.
//  Copyright © 2019 Safwan Saigh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


class Payment{
    
    let db = Firestore.firestore()
    var title :String
    var cost : Float
    var type : String
    var paid : Bool
    var at = ""

    
    
    
    init(_ title:String,_ cost:Float, _ type:String, _ paid:Bool, _ at:String) {
        
        self.title = title
        self.cost = cost
        self.type = type
        self.paid = paid
        if(at == "auto"){
            self.at = getDate()
        }else{
            self.at = at
        }

    }
    
    
    func getDate()->String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MM/dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    
    func getID()->String{
        return Auth.auth().currentUser!.uid
    }

    func payPayment(cost:Float){
        db.collection("user").document(getID()).getDocument { (DocumentSnapshot, Error) in
                      let data =  DocumentSnapshot!.data()
                       let budget = data!["Budget"] as! Float - cost
                       let newData = ["Budget":budget]
                       self.db.collection("user").document(self.getID()).updateData(newData)
                   }
    }
    
    
    func deletePayment(id:String){
        db.collection("uppayment").whereField("At", isEqualTo: id)
                     .getDocuments() { (querySnapshot, err) in
                         if let err = err {
                             print("Error getting documents: \(err)")
                         } else {
                             for document in querySnapshot!.documents {
                            self.db.collection("uppayment").document(document.documentID).delete()
                             }
                         }
                 }
    }
    
    
    func addPayemnt(){
        if(paid){
            db.collection("ppayment").document().setData(["Title":self.title, "Cost":self.cost, "At":self.at,"Type":self.type, "Paid":self.paid,"uid":getID()])
        }else{
            db.collection("uppayment").document().setData(["Title":self.title, "Cost":self.cost, "At":self.at,"Type":self.type, "Paid":self.paid,"uid":getID()])
        }
    }
    
}
