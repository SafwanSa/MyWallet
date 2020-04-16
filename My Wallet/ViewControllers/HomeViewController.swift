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
    var paidPaymentsList = [Payment]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeKeyboard()
        
        DataBank.shared.getUnpaidPayemnts { (unpaidList) in
            self.unpaidPaymentsList = unpaidList
            self.unpaidPaymentsList.removeAll { (payment) -> Bool in
                var remove = false
                if(payment.type == "فواتير"){
                    let bill = payment as! Bill
                    remove = !Calendar.isValidBill(day: bill.day, lastUpdate: bill.lastUpdate, billAt: bill.at)
                }
                return remove
            }
            self.myTableView.reloadData()
        }
        DataBank.shared.getPaidPayemnts(all: false) { (paidList) in
            for list in paidList{
                for payemnt in list{
                    self.paidPaymentsList.append(payemnt)
                }
            }
            self.paidPaymentsList.sort(by: { $0.at.compare($1.at) == .orderedDescending })
            if self.paidPaymentsList.count>3{
                self.paidPaymentsList = [self.paidPaymentsList[0], self.paidPaymentsList[1], self.paidPaymentsList[2]]
            }
            self.myTableView.reloadData()
        }
    }
    
    //MARK:- TableView Configuraion
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Confgiuer Cells
        if(indexPath.section == 0){
            let cell = Bundle.main.loadNibNamed("HomeCell", owner: self, options: nil)?.first as! HomeCell
            cell.delegate = self
            return cell
        }else if indexPath.section == 1{
            //Take the payments one by one from the array
            let payment = self.unpaidPaymentsList[indexPath.row]
            let cost = payment.cost
            let title = payment.title
            let ats = payment.at
            let type = payment.type

            if(type == "فواتير"){
                let bill = payment as! Bill
                let cell1 = Bundle.main.loadNibNamed("BillCell2", owner: self, options: nil)?.first as! BillCell2
                cell1.lbl_cost.text = "SAR "+String(cost)
                cell1.lbl_title.text = title
                cell1.paymentType = type
                cell1.paymentDate = ats
                cell1.lbl_day.text = bill.day
                return cell1
            }else{
                let cell1 = Bundle.main.loadNibNamed("UnpaidCell", owner: self, options: nil)?.first as! UnpaidCell
                cell1.lbl_cost.text = "SAR "+String(cost)
                cell1.lbl_title.text = title
                cell1.paymentType = type
                cell1.paymentDate = ats
                return cell1
            }
        }else{
            //Take the payments one by one from the array
            let payment = self.paidPaymentsList[indexPath.row]
            let cost = payment.cost
            let title = payment.title
            let ats = payment.at
            let type = payment.type
            //Take the cell from TableViewCell1
            let cell = Bundle.main.loadNibNamed("TableViewCell1", owner: self, options: nil)?.first as! TableViewCell1
            //Giving each cell an id (the date the time) Configure the cell...
            let day = Calendar.getFormatedDate(by: "day", date: ats)
            let time = Calendar.getFormatedDate(by: "time", date: ats)
            cell.lbl_type.text = type
            cell.lbl_day.text = "يوم: "+day
            cell.lbl_time.text = "الوقت: "+time
            cell.lbl_title.text = String(title)
            cell.setPaidCell(cost: String(cost))
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.section == 0 || indexPath.section == 2){return false} else{return true}
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
                    bill.addBillToPaidList()
                    bill.updateBillLastUpdate(id: bill.at ,lastUpdate: Calendar.getFullDate())
                    bill.payPayment(cost: cost)
                }else{
                    let payment = self.unpaidPaymentsList[index]
                    payment.deletePayment(id: payment.at)
                    let newPayment = Payment(payment.title,payment.cost,payment.type,true, "auto")
                    let cost = newPayment.cost
                    newPayment.payPayment(cost: cost)
                    newPayment.addPayemnt()
                }
            self.unpaidPaymentsList.remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .top)
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
            tableView.deleteRows(at: [indexPath], with: .top)
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
        let sectionsNames = ["",str,"اخر المدفوعات"]
        if section == 1 && paidPaymentsList.count == 0{
            label.text = ""
        }else {label.text = sectionsNames[section]}
        label.font = UIFont.init(name: "JF Flat", size: 16)
        label.textAlignment = NSTextAlignment.center
        label.textColor = .gray
        label.alpha = 0.6
        return label
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){return 1}else if section == 1{return unpaidPaymentsList.count}
        else{return paidPaymentsList.count}
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){return 356}else if indexPath.section == 1{return 121}else{return 118}
    }
    
    //MARK:- Kb closing
    func closeKeyboard(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
}
extension HomeViewController: HomeCellProtocol{
    func transitions() {
        self.performSegue(withIdentifier: "moveToAddPayment", sender: self)
    }
}

