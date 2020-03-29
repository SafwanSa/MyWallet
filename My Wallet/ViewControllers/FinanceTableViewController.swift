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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        dataSourceDelivery = DataSource()
        dataSourceDelivery?.dataSourceDelegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionNames = ["حدد الميزانية والمدخرات","  مقدار الصرف","   حد الصرف لكل تصنيف  "]
        let title = UILabel()
        view.addSubview(title)
        title.text = sectionNames[section]
        title.textAlignment = .init(CTTextAlignment.right)
        title.font = UIFont(name: "JF Flat", size: 16)
        title.textColor = .lightGray
        return title
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 2{
            return 6
        } else if section == 1{
            return 2
        }
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = Bundle.main.loadNibNamed("BdgSavCell", owner: self, options: nil)?.first as! BdgSavCell
            //Config the cell
            self.budget = Float(cell.lbl_budget.text!)!
            self.savings = Float(cell.lbl_savings.text!)!
            return cell
        }else if indexPath.section == 1{
            let cell = Bundle.main.loadNibNamed("GoalCell", owner: self, options: nil)?.first as! GoalCell
            if indexPath.row == 0 {cell.lbl_cellTitle.text = "اليومي"} else{cell.lbl_cellTitle.text = "الأسبوعي"}
            //Config the cell
            return cell
        }else{
            let types = ["أخرى","صحة","ترفيه","مواصلات","طعام","تسوق"]
            let cell = Bundle.main.loadNibNamed("GoalCell", owner: self, options: nil)?.first as! GoalCell
            cell.lbl_cellTitle.text = types[indexPath.row]
            //Config the cell
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

    @IBAction func updateButtonPressed(_ sender: UIButton) {
        print("Update")
        //Update the database
        let newData = ["Start Amount":budget, "Current Amount":budget, "Savings":savings]
        //Update the database
        dataSourceDelivery?.updateUserInformation(data: newData)
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
extension FinanceTableViewController: DataSourceProtocol{
    func getCosts(costs: [Float]) {}
    func getMonths(months: [String]) {}
    func paidDataUpdated(data: [[Payment]]) {}
    func unpaidDataUpdated(data: [Payment]) {}
    func userDataUpdated(data: [String : Any], which:String) {}
}
