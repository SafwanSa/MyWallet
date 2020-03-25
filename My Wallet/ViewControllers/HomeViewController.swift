//
//  HomeViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 19/09/2019.
//  Copyright © 2019 Safwan Saigh. All rights reserved.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore
import UICircularProgressRing

class HomeViewController: UITableViewController{
    
    
    
    //MARK: -Main Storyboard vars
    //Bottom View
    @IBOutlet weak var myTableView: UITableView!
    
    //MARK: -Instance vars
    var unpaidPaymentsList = [Payment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeKeyboard()
        //Seting up the delegate
        let dataSourceDelivery = DataSource(type: "uppayment")
        dataSourceDelivery.dataSourceDelegate = self
    }
    
    //MARK:- TableView Configuraion
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Confgiuer Cells
        if(indexPath.section == 0){
            let cell = Bundle.main.loadNibNamed("HomeCell", owner: self, options: nil)?.first as! HomeCell
            cell.delegate = self
            return cell
        }else{
            //Take the payments one by one from the array
            let payment = self.unpaidPaymentsList[indexPath.row]
            let cost = payment.cost
            let title = payment.title
            let ats = payment.at
            let type = payment.type
            let day = payment.day
            if(type == "فواتير"){
                let cell1 = Bundle.main.loadNibNamed("BillCell2", owner: self, options: nil)?.first as! BillCell2
                cell1.lbl_cost.text = "SAR "+String(cost)
                cell1.lbl_title.text = title
                cell1.paymentType = type
                cell1.paymentDate = ats
                cell1.lbl_day.text = day
                return cell1
            }else{
                let cell1 = Bundle.main.loadNibNamed("UnpaidCell", owner: self, options: nil)?.first as! UnpaidCell
                cell1.lbl_cost.text = "SAR "+String(cost)
                cell1.lbl_title.text = title
                cell1.paymentType = type
                cell1.paymentDate = ats
                return cell1
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.section == 0){return false} else{return true}
    }
    
    func isBill(index: Int) -> Bool {
        return self.unpaidPaymentsList[index].type == "فواتير"
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
           let index = indexPath.row
           let payButton = UITableViewRowAction(style: .normal, title: "ادفع") { (rowAction, ibdexPath) in
            if(self.isBill(index: index)){
                    let bill = self.unpaidPaymentsList[index] as! Bill
                    let cost = bill.cost
                    //Add the bill in the paidList
                    bill.addBillToPaidList()
                    //Update the "last update" for a bill
                    bill.updateBillLastUpdate(id: bill.at ,lastUpdate: Calendar.getFullDate())
                    //Subtract the cost from the budget
                    bill.payPayment(cost: cost)
                }else{
                    let p = self.unpaidPaymentsList[index]
                    //Delete the payment from unpaid list
                    p.deletePayment(id: p.at)
                    let payment = Payment(p.title,p.cost,p.type,true, "auto")
                    let cost = payment.cost
                    //Subtract the cost from the budget
                    payment.payPayment(cost: cost)
                    //Add the payment in the paid list
                    payment.addPayemnt()
                }
            self.unpaidPaymentsList.remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .automatic)
               }
        
           let deleteButton = UITableViewRowAction(style: .destructive, title: "احذف") { (rowAction, indexPath) in
            if(self.isBill(index: index)){
                    let bill = self.unpaidPaymentsList[index] as! Bill
                    bill.updateBillLastUpdate(id: bill.at ,lastUpdate: Calendar.getFullDate())
                }else{
                    let payment = self.unpaidPaymentsList[index]
                    payment.deletePayment(id: payment.at)
                }
            self.unpaidPaymentsList.remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .automatic)
               }
            setUpActionsButtons(delete: deleteButton, pay: payButton)
            return [deleteButton, payButton]
       }
    
    func setUpActionsButtons(delete: UITableViewRowAction, pay: UITableViewRowAction){
        pay.backgroundColor = UIColor.darkGray
        //Here set up tha imgaes, remove the titles
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Styling the Title of the Table
        let label = UILabel()
        let str = " لديك " + String(self.unpaidPaymentsList.count) + " من المصروفات غير مدفوعة"
        let sectionsNames = ["",str]
        label.text = sectionsNames[section]
        label.font = UIFont.init(name: "JF Flat", size: 18)
        label.textAlignment = NSTextAlignment.center
        label.textColor = .gray
        label.alpha = 0.7
        return label
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }else{
            return unpaidPaymentsList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 356
        }else{
            return 121
        }
    }
    
    //MARK:- Kb closing
    func closeKeyboard(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func isValidBill(day: String,lastUpdate: String)->Bool{
        let billDay = Int(day)!//26
        let currentDay = Int(Calendar.getFormatedDate(by: "day", date: Calendar.getDate()))!//25
        let currentMonth = Int(Calendar.getFormatedDate(by: "month", date: Calendar.getDate()))!//03
        var lastUpdateMonth = 0
        var showBill = false
        var validUpdate = false
        
        if lastUpdate == ""{
            if(currentDay >= billDay){return true}
        }else{
            lastUpdateMonth = Int(Calendar.getFormatedDate(by: "month", date: lastUpdate))!
            if lastUpdateMonth != currentMonth{
                validUpdate = true
            }
        }
        if validUpdate{
            if currentDay >= billDay{
                showBill = true
            }else if(currentDay < billDay){
                if(currentMonth - lastUpdateMonth) > 1{
                    showBill = true
                }
            }
        }
        
        return showBill
    }
    
}
//MARK:- Delegate and protocol overriding
extension HomeViewController: DataSourceProtocol{
    func getCosts(costs: [Float]) {}
    func getMonths(months: [String]) {}
    func paidDataUpdated(data: [[Payment]]) {} // Nothing happens here
    func userDataUpdated(data: [String : Any], which: String) {}
    
    //This method will be excuted when any updates happens to "uppayments"
    func unpaidDataUpdated(data: [Payment]) {
        unpaidPaymentsList = data
        //Remove the bills that is not on its time
        unpaidPaymentsList.removeAll { (payment) -> Bool in
            var remove = false
            if(payment.type == "فواتير"){
                let bill = payment as! Bill
                remove = !isValidBill(day: bill.day, lastUpdate: bill.lastUpdate)
            }
            return remove
        }
        self.myTableView.reloadData()
    }
}
extension HomeViewController: HomeCellProtocol{
    func transitions() {
        self.performSegue(withIdentifier: "moveToAddPayment", sender: self)
    }
    
    
    
}

