//
//  FinanceTableViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 28/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import SVProgressHUD
class FinanceTableViewController: UITableViewController {

    
    
    var userBudget = [String:Any]()
    var budget: Float = 0.0
    var savings: Float = 0.0
    var dailyCost: Float = 0.0
    var weeklyCost: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "BdgSavCell", bundle: nil), forCellReuseIdentifier: "BdgSavCell")
        self.tableView.register(UINib(nibName: "GoalCell", bundle: nil), forCellReuseIdentifier: "GoalCell")
        SuperNavigationController.setTitle(title: "معلومات مالية", nv: self)
        setupNavigationRightButton()
    }

    func setupNavigationRightButton(){
        let saveButton = UIBarButtonItem(title: "حفظ", style: .plain, target: self, action: #selector(save))
        navigationItem.rightBarButtonItems = [saveButton]
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionNames = ["حدد الميزانية والمدخرات","  مقدار الصرف"]
        let title = UILabel()
        view.addSubview(title)
        title.text = sectionNames[section]
        title.textAlignment = .init(CTTextAlignment.right)
        title.font = UIFont(name: "JF Flat", size: 16)
        title.textColor = .lightGray
        return title
    }
    

    @objc func save(){
        showProgress()
        //Taking the values from the cells
        if validation(){
            //Create a Budget
            let newData = ["Start Amount":budget, "Current Amount":budget, "Savings":savings, "dailyCostGoal": dailyCost, "weeklyCostGoal": weeklyCost]
            //Update the database
            DataBank.shared.updateBudget(data: newData)
            stopProgress()
            //Dismiss
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func validation()->Bool{
        let cell1 = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! BdgSavCell
        let cell2 = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! GoalCell
        let cell3 = self.tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! GoalCell
        
        if cell2.lbl_cost.text == "" || cell2.lbl_cost.text == ""{
            showError("أدخل قيمة للأهداف...")
            return false
        }
        
        let numbers:[Character] = ["1","2","3","4","5","6","7","8","9","0","."]
        var dot = 0
        var dot1 = 0
        for char in cell2.lbl_cost.text!{
            if char == "."{
                dot+=1
            }
            if(!numbers.contains(char)){
                showError("أدخل قيمة الهدف بشكل صحيح...")
                return false
            }
        }
        for char in cell3.lbl_cost.text!{
            if char == "."{
                dot1+=1
            }
            if(!numbers.contains(char)){
                showError("أدخل قيمة الهدف بشكل صحيح...")
                return false
            }
        }
        if dot > 1 || dot1 > 1{
            showError("أدخل قيمة الهدف بشكل صحيح...")
            return false
        }
        if cell2.lbl_cost.text!.last == "." || cell2.lbl_cost.text!.first == "."{
            showError("أدخل قيمة الهدف بشكل صحيح...")
            return false
        }
        if cell3.lbl_cost.text?.last == "." || cell3.lbl_cost.text?.first == "."{
            showError("أدخل قيمة الهدف بشكل صحيح...")
            return false
        }
        if Float(cell2.lbl_cost.text!)! < 0 || Float(cell3.lbl_cost.text!)! < 0{
            showError("أدخل قيمة الهدف بشكل صحيح...")
            return false
        }
        self.budget = round(Float(cell1.lbl_budget.text!)!)
        self.savings = round(Float(cell1.lbl_savings.text!)!)
        self.dailyCost = round(Float(cell2.lbl_cost.text!)!)
        self.weeklyCost = round(Float(cell3.lbl_cost.text!)!)
        return true
        }
    
    func round(_ num: Float)->Float{
        return (num*100).rounded()/100
    }
    
    
    func showProgress(){
        SVProgressHUD.show()
    }
        
    func stopProgress(){
        SVProgressHUD.dismiss()
    }
            
    func showError(_ message:String){
        stopProgress()
        let msg = message + " ...!"
        let alert = UIAlertController(title: "حدث خطأ", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "حسناً", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return 2
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "BdgSavCell") as! BdgSavCell
            return cell
        }else{
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "GoalCell") as! GoalCell
            if indexPath.row == 0 {cell.lbl_cellTitle.text = "اليومي"} else{cell.lbl_cellTitle.text = "الأسبوعي"}
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 220
        }else{
            return 74
        }
    }

    
}
