//
//  AddPaymentViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 22/02/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddPaymentViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource{
    

    @IBOutlet weak var sgmnt_paid: UISegmentedControl!
    @IBOutlet weak var txt_title: UITextField!
    @IBOutlet weak var txt_cost: UITextField!
    @IBOutlet weak var txt_type: UITextField!
    @IBOutlet weak var topView: MyRoundedView!
    
    //Setting the picker view functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txt_type.text = PickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PickerData[row]
    }
    private let PickerData = ["أخرى","صحة","ترفيه","مواصلات","طعام","تسوق"]
    private var type = UIPickerView()
    private var paidOrNot = false
    let db = Firestore.firestore()
    
    
    
    override func viewDidLoad() {
        closeKeyboard()
        //Connecting the PickerView With delegate and dataSource
        //Connecting the textField with PickerView
        type.dataSource = self
        type.delegate = self
        txt_type.inputView = type

        
        topView.layer.shadowOpacity = 0.6
        topView.layer.shadowRadius = 5
        topView.layer.shadowOffset = .zero
        topView.layer.masksToBounds = false
        
        let font = UIFont(name: "JF Flat", size: 11)
        sgmnt_paid.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)

        
    }
    
    
    @IBAction func sgmnt_choose(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex==0){
            paidOrNot = false
        }else{
            paidOrNot = true
        }
    }
    
    func getID()->String{
        return Auth.auth().currentUser!.uid
    }
    
    @IBAction func btn_addPayment(_ sender: UIButton) {
        //Initilizing default
        var title = "No Title"
        var cost = Float(0.0)
        var paid = false
        var paymentType = PickerData[0]
        //Check if one of the fields is not empty.
        if txt_type.text != ""{
            paymentType = txt_type.text!
        }
        if txt_title.text != ""{
            title = txt_title.text!
        }
        if txt_cost.text != ""{
            cost = Float(txt_cost.text!)!
        }
        if paidOrNot{
            paid = true
        }
        //Check if there is a cost or not, because we do not want to add a payment without cost
        if cost > 0{
            //Create a payment object
            let payment = Payment(title, cost, paymentType, paid, "auto")
            //Do this if he adds a paid payemnt
            if(paid){
            payment.addPayemnt()
            //Subtract the cost from the budget
            payment.payPayment(cost: cost)
            }else{
                //Do this if he adds unpaid payment
                payment.addPayemnt()
            }
            //Readjust the fields of adding payments
            txt_cost.text = ""
            txt_title.text = ""
            txt_type.text = ""
            paidOrNot = false
            sgmnt_paid.selectedSegmentIndex = 0
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    func closeKeyboard(){
           let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
           view.addGestureRecognizer(tap)
       }
       
}


