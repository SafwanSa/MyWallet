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
        month = Calendar.getMonthInAr(m: "auto")
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
        if(indexPath == IndexPath.init(item: 0, section: 0)){
            cell.category = "Current Month"
        }else{
            cell.category = "Other Months"
        }
            cell.delegate = self
            return cell
    }
    
    
    
}
extension HistoryViewController: HistoryCellProtocol{
    func transitions(category: String) {
        //Get the category to display before transition
        if(category == "Current Month"){
            Calendar.categ = Calendar.getCurrentMonth()
            self.performSegue(withIdentifier: "goToCurrentMonthHistory", sender: self)
        }else{
            self.performSegue(withIdentifier: "goToMonthsClass", sender: self)
            Calendar.categ = ""
        }

    }
    
    
}
