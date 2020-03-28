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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("BdgSavCell", owner: self, options: nil)?.first as! BdgSavCell
        //Config the cell
        self.budget = Float(cell.lbl_budget.text!)!
        self.savings = Float(cell.lbl_savings.text!)!
        return cell
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
