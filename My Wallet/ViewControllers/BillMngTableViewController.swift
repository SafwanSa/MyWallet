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
        closeKeyboard()
        dataSourceDelivery = DataSource(type: "uppayment")
        dataSourceDelivery?.dataSourceDelegate = self
        
        SuperNavigationController.setTitle(title: "إدارة الفواتير", nv: self)
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.section == 0){return false} else{return true}
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let index = indexPath.row
        let bill = self.bills[index] as! Bill
        let payButton = UITableViewRowAction(style: .normal, title: "ادفع") { (rowAction, ibdexPath) in
                let newBill = Bill(bill.title, bill.cost, bill.day, "auto", lastUpd: "")
                let cost = bill.cost
                //Add the bill in the paidList
                newBill.addBillToPaidList()
                //Update the "last update" for a bill
                bill.updateBillLastUpdate(id: bill.at ,lastUpdate: Calendar.getFullDate())
                //Subtract the cost from the budget
                bill.payPayment(cost: cost)
            }
        let deleteButton = UITableViewRowAction(style: .destructive, title: "احذف") { (rowAction, indexPath) in
                self.bills.remove(at: index)
                let id = bill.at
                bill.deletePayment(id: id)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        setUpActionsButtons(delete: deleteButton, pay: payButton)
        return [deleteButton, payButton]
    }
    
    func setUpActionsButtons(delete: UITableViewRowAction, pay: UITableViewRowAction){
        pay.backgroundColor = UIColor.darkGray
        //Here set up tha imgaes, remove the titles
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
            return 121
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = Bundle.main.loadNibNamed("AddBillCell", owner: self, options: nil)?.first as! AddBillCell
            return cell
        }else{
            let payment = self.bills[indexPath.row]
            let cost = payment.cost
            let title = payment.title
            let ats = payment.at
            let type = payment.type
            let day = payment.day
            let cell = Bundle.main.loadNibNamed("BillCell2", owner: self, options: nil)?.first as! BillCell2
            cell.lbl_cost.text = "SAR "+String(cost)
            cell.lbl_title.text = title
            cell.paymentDate = ats
            cell.paymentType = type
            cell.lbl_day.text = day
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

    func unpaidDataUpdated(data: [Payment]) {
        self.bills = data
        self.bills.removeAll { (payment) -> Bool in
            if(payment.type != "فواتير"){
                return true
            }else{
                return false
            }
        }
        self.tableView.reloadData()
    }
}
