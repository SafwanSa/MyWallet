//
//  HistoryViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 09/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController{
    
    
    
    @IBOutlet weak var lbl_month: UILabel!
    var month = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        month = Calendar.getCurrentMonthInAr()
        lbl_month.text =  " الشهر الحالي : " + month
    }
    
   
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 181
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont.init(name: "JF Flat", size: 14)
        label.textColor = .black
        label.textAlignment = NSTextAlignment.center
        let names = ["إحصائيات الشهر الحالي", "إحصائيات الشهور الماضية"]
        label.text = names[section]
        return label
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Take the cell from HistoryCell
        let cell = Bundle.main.loadNibNamed("HistoryCell", owner: self, options: nil)?.first as! HistoryCell
            //Giving each cell an id (the date the time) Configure the cell...
            return cell
    }
    
    
    
}
