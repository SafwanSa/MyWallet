//
//  FinanceTableViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 28/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class FinanceTableViewController: UITableViewController {

    
    
    var userBudget = [String:Any]()
    var budget: Float = 0.0
    var savings: Float = 0.0
    var dailyCost: Float = 0.0
    var weeklyCost: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func takeValues(){
        let cell1 = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! BdgSavCell
        let cell2 = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! GoalCell
        let cell3 = self.tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! GoalCell
        self.budget = Float(cell1.lbl_budget.text!)!
        self.savings = Float(cell1.lbl_savings.text!)!
        self.dailyCost = Float(cell2.lbl_cost.text!)!
        self.weeklyCost = Float(cell3.lbl_cost.text!)!
    }
    
    @objc func save(){
        //Taking the values from the cells
        takeValues()
        //Create a Budget
        let newData = ["Start Amount":budget, "Current Amount":budget, "Savings":savings]
        //Creating goals
        let goal1 = Goal(type: .dailyCostGoal, value: dailyCost)
        let goal2 = Goal(type: .weeklyCostGoal, value: weeklyCost)
        //Add them in the data base
        goal1.addGoal()
        goal2.addGoal()
        //Update the database
        DataBank.shared.updateBudget(data: newData)
        //Dismiss
        self.navigationController?.popViewController(animated: true)
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
            let cell = Bundle.main.loadNibNamed("BdgSavCell", owner: self, options: nil)?.first as! BdgSavCell
            //Config the cell
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("GoalCell", owner: self, options: nil)?.first as! GoalCell
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
