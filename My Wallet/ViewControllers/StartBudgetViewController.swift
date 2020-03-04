//
//  StartBudgetViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 21/09/2019.
//  Copyright © 2019 Safwan Saigh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class StartBudgetViewController: UIViewController {

    
    let db = Firestore.firestore()
    

    @IBOutlet weak var lbl_savings: UILabel!
    @IBOutlet weak var lbl_budget: UILabel!
    @IBOutlet weak var lbl_income: UILabel!
    @IBOutlet weak var lbl_error: UILabel!
    
    
    @IBOutlet weak var sldr_income_out: UISlider!
    @IBAction func sldr_income(_ sender: UISlider) {
        updateSliders()

    }
    
    @IBOutlet weak var sldr_budget_out: UISlider!
    @IBAction func sldr_budget(_ sender: UISlider) {
        updateSliders()

        
    }
    
    @IBOutlet weak var sldr_savings_out: UISlider!
    @IBAction func sldr_savings(_ sender: UISlider) {
        updateSliders()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeKeyboard()
    }
    
    func updateSliders(){
        self.lbl_income.text = String(Int(sldr_income_out.value))+".0"
        self.lbl_budget.text = String(Int(sldr_budget_out.value))+".0"
        self.lbl_savings.text = String(Int(sldr_savings_out.value))+".0"
        sldr_budget_out.maximumValue = Float(lbl_income.text!)!
        sldr_savings_out.maximumValue = Float(lbl_budget.text!)!
    }
    
    
    
    func getID()->String{
        return Auth.auth().currentUser!.uid
    }
    
    func updateUserInfo(income:Float,budget:Float,savings:Float){
        let newData = ["Income":income, "Budget":budget, "Savings":savings]
        db.collection("user").document(getID()).updateData(newData)
    }
    
    
    
    @IBAction func updateButtonPressed(_ sender: Any) {
                   //Create a Budget
                   let income = Float(lbl_income.text!)
                   let budget = Float(lbl_budget.text!)
                   let savings = Float(lbl_savings.text!)
                   updateUserInfo(income: income!, budget: budget!, savings: savings!)
    }
    
    
    func closeKeyboard(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
}
