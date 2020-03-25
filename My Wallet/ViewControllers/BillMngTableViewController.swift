//
//  BillMngTableViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 25/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class BillMngTableViewController: UITableViewController {

    
    var dataSourceDelivery: DataSource?
    var bills = [Payment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        closeKeyboard()
        dataSourceDelivery = DataSource(type: "uppayment")
        dataSourceDelivery?.dataSourceDelegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         //Styling the Title of the Table
         let label = UILabel()
        let str = " لديك " + String(self.self.bills.count) + " فواتير"
         let sectionsNames = ["",str]
         label.text = sectionsNames[section]
         label.font = UIFont.init(name: "JF Flat", size: 18)
         label.textAlignment = NSTextAlignment.center
         label.textColor = .gray
         label.alpha = 0.7
         return label
     }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0){
            return 1
        }else{
            return self.bills.count
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 321
        }else{
            return 80
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = Bundle.main.loadNibNamed("AddBillCell", owner: self, options: nil)?.first as! AddBillCell
            return cell
        }else{
            let payment = self.bills[indexPath.row] as! Bill
            let cost = payment.cost
            let title = payment.title
            let ats = payment.at
            let type = payment.type
             let day = payment.day
            let cell = Bundle.main.loadNibNamed("BillCell", owner: self, options: nil)?.first as! BillCell
            cell.lbl_cost.text = "SAR "+String(cost)
            cell.lbl_title.text = title
            cell.paymentDate = ats
            cell.paymentType = type
            cell.billDay = day
            return cell
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func closeKeyboard(){
              let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
              view.addGestureRecognizer(tap)
          }
}
extension BillMngTableViewController: DataSourceProtocol{
    func getCosts(costs: [Float]) {}
    func getMonths(months: [String]) {}
    func paidDataUpdated(data: [[Payment]]) {}
    func unpaidDataUpdated(data: [Payment]) {
        self.bills = data
        self.tableView.reloadData()
    }
    func userDataUpdated(data: [String : Any], which:String) {} //Nothing will happend here
}
