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


@objc class Payment: NSObject{
    
    let db = Firestore.firestore()
    var title :String
    var cost : Float
    var type : String
    var paid : Bool
    var at = ""
    var day = ""
    
    
    
     init(_ title:String,_ cost:Float, _ type:String, _ paid:Bool, _ at:String) {
        self.title = title
        self.cost = cost
        self.type = type
        self.paid = paid
        super.init()
        if(at == "auto"){
            self.at = self.getDate()
        }else{
            self.at = at
        }
    }
    
    
    func getDate()->String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MM/dd/YYYY HH:mm:ss"
        let formattedDate = format.string(from: date)
        return formattedDate
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

    func payPayment(cost:Float){
        db.collection("budgets").document(Calendar.getBudgetId()).getDocument { (DocumentSnapshot, Error) in
                      let data =  DocumentSnapshot!.data()
                       let budget = data!["Current Amount"] as! Float - cost
                       let newData = ["Current Amount":budget]
            self.db.collection("budgets").document(Calendar.getBudgetId()).updateData(newData)
                   }
    }
    
    
    func deletePayment(id:String){
        db.collection("uppayment").document(getPaymentID(id: id)).getDocument() { (querySnapshot, err) in
                         if let err = err {
                             print("Error getting documents: \(err)")
                         } else {
                            self.db.collection("uppayment").document(querySnapshot!.documentID).delete()
                         }
                 }
    }
    
    
    func addPayemnt(){
        if(paid){
            db.collection("ppayment").document(getPaymentID(id: self.at)).setData(["Title":self.title, "Cost":self.cost, "At":self.at,"Type":self.type, "Paid":self.paid,"uid":getID()])
        }else{
            db.collection("uppayment").document(getPaymentID(id: self.at)).setData(["Title":self.title, "Cost":self.cost, "At":self.at,"Type":self.type, "Paid":self.paid,"uid":getID()])
        }
    }
    
}
