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
        SuperNavigationController.setTitle(title: "الرئيسية", nv: self)
        myTableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        myTableView.register(UINib(nibName: "BillCell2", bundle: nil), forCellReuseIdentifier: "BillCell2")
        myTableView.register(UINib(nibName: "UnpaidCell", bundle: nil), forCellReuseIdentifier: "UnpaidCell")
        myTableView.register(UINib(nibName: "TableViewCell1", bundle: nil), forCellReuseIdentifier: "TableViewCell1")
        DataBank.shared.getUnpaidPayemnts { (unpaidList) in
            self.unpaidPaymentsList.removeAll()
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
            self.paidPaymentsList.removeAll()
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
            let cell = myTableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
            cell.delegate = self
            return cell
        }else if indexPath.section == 1{
            let payment = self.unpaidPaymentsList[indexPath.row]
            if(payment.type == "فواتير"){
                let bill = payment as! Bill
                let cell = myTableView.dequeueReusableCell(withIdentifier: "BillCell2") as! BillCell2
                cell.lbl_cost.text = "SAR "+String(bill.cost)
                cell.lbl_title.text = bill.title
                cell.paymentType = bill.type
                cell.paymentDate = bill.at
                cell.lbl_day.text = bill.day
                return cell
            }else{
                let cell = myTableView.dequeueReusableCell(withIdentifier: "UnpaidCell") as! UnpaidCell
                cell.lbl_cost.text = "SAR "+String(payment.cost)
                cell.lbl_title.text = payment.title
                cell.paymentType = payment.type
                cell.paymentDate = payment.at
                return cell
            }
        }else{
            let payment = self.paidPaymentsList[indexPath.row]
            let cell = myTableView.dequeueReusableCell(withIdentifier: "TableViewCell1") as! TableViewCell1
            let day = Calendar.getFormatedDate(by: "day", date: payment.at)
            let time = Calendar.getFormatedDate(by: "time", date: payment.at)
            cell.lbl_type.text = payment.type
            cell.lbl_day.text = "يوم: "+day
            cell.lbl_time.text = "الوقت: "+time
            cell.lbl_title.text = String(payment.title)
            cell.setPaidCell(cost: String(payment.cost))
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
                bill.updateBillLastUpdate(id: bill.at, lastUpdate: Calendar.getFullDate())
                bill.at = Calendar.getFullDate()
                bill.addBillToPaidList()
                bill.payPayment(cost: bill.cost)
            }else{
                let payment = self.unpaidPaymentsList[index]
                payment.deletePayment(id: payment.at)
                let newPayment = Payment(payment.title, payment.cost,payment.type, true, "auto")
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
        let sectionsNames = ["أهلا safwan",str,"اخر المدفوعات"]
        if section == 1 && paidPaymentsList.count == 0{
            label.text = ""
        }else {label.text = sectionsNames[section]}
        if section == 0{
            label.font = UIFont.init(name: "JF Flat", size: 19)
            label.textAlignment = NSTextAlignment.center
            label.textColor = .white
            label.alpha = 0.8
        }else{
            label.font = UIFont.init(name: "JF Flat", size: 16)
            label.textAlignment = NSTextAlignment.center
            label.textColor = .white
            label.alpha = 0.8
        }
        return label
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 50
        }else{
            return 25
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){return 1}else if section == 1{return unpaidPaymentsList.count}
        else{return paidPaymentsList.count}
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){return 248}else if indexPath.section == 1{return 121}else{return 118}
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

