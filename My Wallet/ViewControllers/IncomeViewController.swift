//
//  IncomeViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 24/04/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseFirestore
import FirebaseAuth
class IncomeViewController: UIViewController {


    @IBOutlet weak var lbl_error: UILabel!
    @IBOutlet weak var txt_income: HSUnderLineTextField!
    @IBOutlet weak var btn_start: RoundButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    

    @IBAction func startPressed(_ sender: Any) {
        showProgress()
        if validation(){
            self.setupIncome(income: Float(txt_income.text!)!)
            self.performSegue(withIdentifier: "goToHomeVC", sender: self)
        }
    }
    
    
    func showProgress(){
        btn_start.isEnabled = false
        btn_start.alpha = 0.7
        SVProgressHUD.show()
    }
    
    func stopProgress(){
        btn_start.isEnabled = true
        btn_start.alpha = 1
        SVProgressHUD.dismiss()
    }
    
     func showError(_ message:String){
        stopProgress()
        lbl_error.textColor = .red
        lbl_error.text = message + " ...!"
        lbl_error.alpha = 1
       }
    
    func showPrompt(_ message:String){
        stopProgress()
        lbl_error.textColor = .systemGreen
        lbl_error.text = message
        lbl_error.alpha = 1
    }
    
    func validation()->Bool{
           let numbers:[Character] = ["1","2","3","4","5","6","7","8","9","0","."]
           if txt_income.text == ""{
               showError( "ادخل الدخل..")
               return false
           }
           for char in txt_income.text!{
               if(!numbers.contains(char)){
                    print(char)
                   showError( "أدخل الدخل بشكل صحيح...")
                   return false
               }
           }
           if txt_income.text?.last == "." || txt_income.text?.first == "."{
               showError( "أدخل الدخل بشكل صحيح...")
               return false
           }
           if(Float(txt_income.text!)! <= 0){
               showError( "يجب أن يكون الدخل أكبر من ٠...")
               return false
           }
           return true
       }
    
    
    func setupIncome(income: Float){
        let db = Firestore.firestore()
        db.collection("user").document(Auth.auth().currentUser!.uid).updateData(["Income": income])
    }
    

}
