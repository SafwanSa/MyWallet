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
import FirebaseAuth
import SVProgressHUD
class AddPaymentViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource{
    

    @IBOutlet weak var sgmnt_paid: UISegmentedControl!
    @IBOutlet weak var txt_title: UITextField!
    @IBOutlet weak var txt_cost: UITextField!
    @IBOutlet weak var txt_type: UITextField!
    @IBOutlet weak var topView: MyRoundedView!
    @IBOutlet weak var btn_add: RoundButton!
    
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
        sgmnt_paid.setTitleTextAttributes([NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 11)], for: .normal)

        
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
    
    
    func validation()->Bool{
           let numbers:[Character] = ["1","2","3","4","5","6","7","8","9","0"]
           if txt_cost.text == ""{
               showError( "ادخل التكلفة..")
               return false
           }
           for char in txt_cost.text!{
               if(!numbers.contains(char)){
                   showError( "أدخل التكلفة بشكل صحيح...")
                   return false
               }
           }
           if(Int(txt_cost.text!)! <= 0){
               showError( "يجب أن تكون التكلفة أكبر من ٠...")
               return false
           }
           return true
       }
       
       func showProgress(){
              btn_add.isEnabled = false
              btn_add.alpha = 0.7
              SVProgressHUD.show()
          }
          
          func stopProgress(){
              btn_add.isEnabled = true
              btn_add.alpha = 1
              SVProgressHUD.dismiss()
          }
          
           func showError(_ message:String){
               stopProgress()
               let msg = message + " ...!"
               let alert = UIAlertController(title: "حدث خطأ", message: msg, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "حسناً", style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
             }
    
    
    @IBAction func btn_addPayment(_ sender: UIButton) {
        showProgress()
        //Initilizing default
        var title = "بدون عنوان"
        var cost = Float(0.0)
        var paid = false
        var paymentType = PickerData[0]
        //Check if one of the fields is not empty.
        if validation(){
            if txt_type.text != ""{paymentType = txt_type.text!}
            if txt_title.text != ""{title = txt_title.text!}
            cost = Float(txt_cost.text!)!
            if paidOrNot{
                paid = true
            }
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
            stopProgress()
            self.dismiss(animated: true, completion: nil)
        }

    }
    
    
    
    func closeKeyboard(){
           let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
           view.addGestureRecognizer(tap)
       }
       
}


