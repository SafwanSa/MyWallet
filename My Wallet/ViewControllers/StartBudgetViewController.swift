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
    
    //MARK: -UI vars related
    @IBOutlet weak var bottomView: GradientView!
    @IBOutlet weak var topView: GradientView!
    @IBOutlet weak var txt_fname: UITextField!
    @IBOutlet weak var txt_lname: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    
    
    @IBOutlet weak var lbl_savings: UILabel!
    @IBOutlet weak var lbl_budget: UILabel!

    
    
    @IBOutlet weak var sldr_budget_out: UISlider!
    @IBAction func sldr_budget(_ sender: UISlider) {
        updateSliders()
    }
    
    @IBOutlet weak var sldr_savings_out: UISlider!
    @IBAction func sldr_savings(_ sender: UISlider) {
        updateSliders()
    }
    
    var dataSourceDelivery : DataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeKeyboard()
        dataSourceDelivery = DataSource()
        dataSourceDelivery?.dataSourceDelegate = self
        bottomView.layer.shadowOpacity = 0.6
        bottomView.layer.shadowRadius = 5
        bottomView.layer.shadowOffset = .zero
        bottomView.layer.masksToBounds = false
        topView.layer.shadowOpacity = 0.6
        topView.layer.shadowRadius = 5
        topView.layer.shadowOffset = .zero
        topView.layer.masksToBounds = false
    }
    
    //MARK: -Updating the sliders
    func updateSliders(){
        self.lbl_budget.text = String(Int(sldr_budget_out.value))+".0"
        self.lbl_savings.text = String(Int(sldr_savings_out.value))+".0"
        sldr_savings_out.maximumValue = Float(lbl_budget.text!)!
    }
    
    //MARK: -Update Button Pressed function
    @IBAction func updateButtonPressed(_ sender: Any) {
        //Create a Budget
        let budget = Float(lbl_budget.text!)
        let savings = Float(lbl_savings.text!)
        let newData = ["Starting Amount":budget, "Current Amount":budget, "Savings":savings]
        //Update the database
        dataSourceDelivery?.updateUserInformation(data: newData as! [String : Float])
            
    }
    
    
    func closeKeyboard(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
}

//MARK:- Delegate and protocol overriding
extension StartBudgetViewController: DataSourceProtocol{
    func getMonths(months: [String]) {}
    func paidDataUpdated(data: [[Payment]]) {}
    func unpaidDataUpdated(data: [Payment]) {}
    
    func userDataUpdated(data: [String : Any], which:String) {
        if(which == "user"){
            txt_email.text = data["Email"] as? String
            txt_fname.text = data["First Name"] as? String
            txt_lname.text = data["Last Name"] as? String
        }else{
            sldr_budget_out.value = (data["Current Amount"] as? Float)!
            lbl_budget.text = String((data["Current Amount"] as? Float)!)
            sldr_savings_out.value = (data["Savings"] as? Float)!
            lbl_savings.text = String((data["Savings"] as? Float)!)
        }

    }
    
    
}
