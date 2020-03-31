//
//  FinanceTableViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 28/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class FinanceTableViewController: UITableViewController {

    
    
    var dataSourceDelivery: DataSource?
    var userBudget = [String:Any]()
    var budget: Float = 0.0
    var savings: Float = 0.0
    var dailyCost: Float = 0.0
    var weeklyCost: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSourceDelivery = DataSource()
        dataSourceDelivery?.dataSourceDelegate = self
        
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
        print("Update")
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
            self.budget = Float(cell.lbl_budget.text!)!
            self.savings = Float(cell.lbl_savings.text!)!
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("GoalCell", owner: self, options: nil)?.first as! GoalCell
            if indexPath.row == 0 {cell.lbl_cellTitle.text = "اليومي"} else{cell.lbl_cellTitle.text = "الأسبوعي"}
            if indexPath.row == 0 {dailyCost = Float(cell.lbl_cost.text!)!} else{weeklyCost = Float(cell.lbl_cost.text!)!}
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
extension FinanceTableViewController: DataSourceProtocol{
    func getCosts(costs: [Float]) {}
    func getMonths(months: [String]) {}
    func paidDataUpdated(data: [[Payment]]) {}
    func unpaidDataUpdated(data: [Payment]) {}
    func userDataUpdated(data: [String : Any], which:String) {}
}
