//
//  HistoryTableViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 29/09/2019.
//  Copyright © 2019 Safwan Saigh. All rights reserved.
//

import UIKit


class HistoryTableViewController: UITableViewController {
    @IBOutlet weak var sgmnt_types: UISegmentedControl!
    @IBOutlet weak var sgmnt_sp: UISegmentedControl!
    
    var allPayments = [[Payment]]()
    var paidPaymentsList = [Payment]()
    var typesIndex = 0
    var category = ""
    var showAll = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SuperNavigationController.setTitle(title: "مشترياتك", nv: self)
            
        let font = UIFont.init(name: "JF Flat", size: 11)
        sgmnt_types.setTitleTextAttributes([NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 11)], for: .normal)
        sgmnt_sp.setTitleTextAttributes([NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 11)], for: .normal)
        sgmnt_types.alpha = 0
        
        
        self.tableView.register(UINib(nibName: "TableViewCell1", bundle: nil), forCellReuseIdentifier: "TableViewCell1")
        
        DataBank.shared.getPaidPayemnts(all: false) { (paidList) in
            self.allPayments = paidList
            for i in 0..<paidList.count{
                for j in 0..<paidList[i].count{
                    self.paidPaymentsList.append(paidList[i][j])
                }
            }
            self.paidPaymentsList.sort(by: { $0.at.compare($1.at) == .orderedDescending })
            self.tableView.reloadData()
        }
    }
    
    @IBAction func sgmn_sp(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            UIView.animate(withDuration: 0.4) {
                self.sgmnt_types.alpha = 0
            }
            showAll = 0
        }else{
            //Show sgmnt_types
            UIView.animate(withDuration: 0.4) {
                self.sgmnt_types.alpha = 1
            }
            showAll = 1
            typesIndex = 0
        }
        tableView.reloadData()
    }
    
    @IBAction func sgmnt_types(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0){
            typesIndex = 0
        }else if(sender.selectedSegmentIndex == 1){
            typesIndex = 1
        }else if(sender.selectedSegmentIndex == 2){
            typesIndex = 2
        }else if(sender.selectedSegmentIndex == 3){
            typesIndex = 3
        }else if(sender.selectedSegmentIndex == 4){
            typesIndex = 4
        }else if(sender.selectedSegmentIndex == 5){
            typesIndex = 5
        }else if(sender.selectedSegmentIndex == 6){
            typesIndex = 6
        }else if(sender.selectedSegmentIndex == 7){
            typesIndex = 7
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Styling the sections
        let sectionsNames = ["أخرى","صحة","ترفيه","مواصلات","طعام","تسوق","فواتير"]
        let label = UILabel()
        if showAll == 1{
            label.text = String(self.allPayments[typesIndex].count)+" "+sectionsNames[typesIndex]
        }else{
            label.text = String(self.paidPaymentsList.count)+" من المدفوعات"
        }
        label.font = UIFont.init(name: "JF Flat", size: 19)
        label.textAlignment = NSTextAlignment.center
        return label
    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 49
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showAll == 0{
            return paidPaymentsList.count
        }
        return allPayments[typesIndex].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var payment: Payment?
        if showAll == 0{
            payment = self.paidPaymentsList[indexPath.row]
        }else{
            payment = self.allPayments[typesIndex][indexPath.row]
        }
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell1") as! TableViewCell1
        let day = Calendar.getFormatedDate(by: "day", date: payment!.at)
        let time = Calendar.getFormatedDate(by: "time", date: payment!.at)
        cell.lbl_type.text = payment!.type
        cell.lbl_day.text = "يوم: "+day
        cell.lbl_time.text = "الوقت: "+time
        cell.lbl_title.text = String(payment!.title)
        cell.setPaidCell(cost: String(payment!.cost))
        if showAll == 1{
            cell.typeView.alpha = 0
        }else{
            cell.typeView.alpha = 1
        }
        return cell
    }
}
