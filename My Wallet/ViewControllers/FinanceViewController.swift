//
//  FinanceViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 25/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class FinanceViewController: UIViewController {

    @IBOutlet weak var bottomView: GradientView!
    @IBOutlet weak var lbl_savings: UILabel!
    @IBOutlet weak var lbl_budget: UILabel!

    
    @IBOutlet weak var sldr_budget_out: UISlider!
    @IBOutlet weak var sldr_savings_out: UISlider!
    
    
    //MARK:- Intsance Vars
    var dataSourceDelivery : DataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSourceDelivery = DataSource()
        dataSourceDelivery?.dataSourceDelegate = self
        bottomView.layer.shadowOpacity = 0.6
        bottomView.layer.shadowRadius = 5
        bottomView.layer.shadowOffset = .zero
        bottomView.layer.masksToBounds = false
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Updating the sliders
    func updateSliders(){
        self.lbl_budget.text = String(Int(sldr_budget_out.value))+".0"
        self.lbl_savings.text = String(Int(sldr_savings_out.value))+".0"
        sldr_savings_out.maximumValue = Float(lbl_budget.text!)!
    }
    
    //MARK:- Sliders actions
    @IBAction func slideBudgetSlider(_ sender: UISlider) {
        //Fix the incremen to be by 50
        let steps: Float = 50
        let roundedValue = round(sender.value / steps) * steps
        sender.value = roundedValue
        updateSliders()
    }
    
    //MARK:- Update Button Pressed function
    @IBAction func updateButtonPressed(_ sender: Any) {
        //Create a Budget
        let budget = Float(lbl_budget.text!)
        let savings = Float(lbl_savings.text!)
        let newData = ["Start Amount":budget, "Current Amount":budget, "Savings":savings]
        //Update the database
        dataSourceDelivery?.updateUserInformation(data: newData as! [String : Float])
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FinanceViewController: DataSourceProtocol{
    func getCosts(costs: [Float]) {}
    func getMonths(months: [String]) {}
    func paidDataUpdated(data: [[Payment]]) {}
    func unpaidDataUpdated(data: [Payment]) {}
    
    func userDataUpdated(data: [String : Any], which:String) {
        if(which == "budgets"){
            sldr_budget_out.value = (data["Current Amount"] as? Float)!
            lbl_budget.text = String((data["Current Amount"] as? Float)!)
            sldr_savings_out.value = (data["Savings"] as? Float)!
            lbl_savings.text = String((data["Savings"] as? Float)!)
        }

    }
    
    
}
