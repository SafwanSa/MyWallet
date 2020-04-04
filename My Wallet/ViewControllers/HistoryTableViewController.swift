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
    
    var allPayments = [
        [Payment](),
        [Payment](),
        [Payment](),
        [Payment](),
        [Payment](),
        [Payment](),
        [Payment]()
    ]
    var typesIndex = 0
    var category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SuperNavigationController.setTitle(title: "مشترياتك", nv: self)
            
        let font = UIFont.init(name: "JF Flat", size: 11)
        sgmnt_types.setTitleTextAttributes([NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 11)], for: .normal)
        
        let dataSourceDelivery = DataSource(type: "ppayment")
        dataSourceDelivery.dataSourceDelegate = self
    }
    
    @objc func loadList(notification: NSNotification){
        //load data here
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        label.text = sectionsNames[typesIndex]
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
        return allPayments[typesIndex].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Take the payments one by one from the array
        let payment = self.allPayments[typesIndex][indexPath.row]
        let cost = payment.cost
        let title = payment.title
        let ats = payment.at
        //Take the cell from TableViewCell1
        let cell = Bundle.main.loadNibNamed("TableViewCell1", owner: self, options: nil)?.first as! TableViewCell1
            //Giving each cell an id (the date the time) Configure the cell...
        let day = Calendar.getFormatedDate(by: "day", date: ats)
        let time = Calendar.getFormatedDate(by: "time", date: ats)
            cell.lbl_day.text = "يوم: "+day
            cell.lbl_time.text = "الوقت: "+time
            cell.lbl_title.text = String(title)
            cell.setPaidCell(cost: String(cost))
            return cell
    }
}

extension HistoryTableViewController: DataSourceProtocol{
    
    func paidDataUpdated(data: [[Payment]]) {
        allPayments = data
        self.tableView.reloadData()
    }
}
