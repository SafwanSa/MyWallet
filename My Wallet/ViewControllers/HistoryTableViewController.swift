//
//  HistoryTableViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 29/09/2019.
//  Copyright © 2019 Safwan Saigh. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import BetterSegmentedControl

class HistoryTableViewController: UITableViewController {
    

    
    @IBOutlet weak var sgmnt_types2: BetterSegmentedControl!
    

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "مشترياتك"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "JF Flat", size: 19)!]
            
        
        sgmnt_types2.segments = LabelSegment.segments(withTitles: ["أخرى","صحة","ترفيه","مواصلات","طعام","تسوق","وقود"] ,normalFont: UIFont(name: "JF Flat", size: 11), normalTextColor: UIColor.darkGray,selectedFont: UIFont(name: "JF Flat", size: 12),selectedTextColor: UIColor.darkText)
        
        let dataSourceDelivery = DataSource(type: "ppayment")
        dataSourceDelivery.dataSourceDelegate = self
    }
    
    @objc func loadList(notification: NSNotification){
        //load data here
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    @IBAction func sgmnt_types(_ sender: BetterSegmentedControl) {
        if(sender.index == 0){
            typesIndex = 0
        }else if(sender.index == 1){
            typesIndex = 1
        }else if(sender.index == 2){
            typesIndex = 2
        }else if(sender.index == 3){
            typesIndex = 3
        }else if(sender.index == 4){
            typesIndex = 4
        }else if(sender.index == 5){
            typesIndex = 5
        }else if(sender.index == 6){
            typesIndex = 6
        }else if(sender.index == 7){
            typesIndex = 7
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Styling the sections
        let sectionsNames = ["أخرى","صحة","ترفيه","مواصلات","طعام","تسوق","وقود"]
        let label = UILabel()
        label.text = sectionsNames[typesIndex]
        label.font = UIFont.init(name: "JF Flat", size: 19)
        label.textAlignment = NSTextAlignment.center
        return label
    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79.5
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
        let type = payment.type
        //Take the cell from TableViewCell1
        let cell = Bundle.main.loadNibNamed("TableViewCell1", owner: self, options: nil)?.first as! TableViewCell1
            //Giving each cell an id (the date the time) Configure the cell...
            cell.paymentDate = ats
            cell.lbl_title.text = String(title)
            cell.type = type
            cell.setPaidCell(cost: String(cost))
            return cell
    }
}

extension HistoryTableViewController: DataSourceProtocol{
    func paidDataUpdated(data: [[Payment]]) {
        print(data[0].count, "COooooooooooooo")
        allPayments = data
        self.tableView.reloadData()
    }
    func unpaidDataUpdated(data: [Payment]) {} //Nothing will happend here
    func userDataUpdated(data: [String : Any]) {} //Nothing will happend here
}
