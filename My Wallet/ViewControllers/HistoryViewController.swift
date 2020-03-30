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
        
        SuperNavigationController.setTitle(title: "ملخص المدفوعات", nv: self)
    }
    
   
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 242
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Take the cell from HistoryCell
        let cell = Bundle.main.loadNibNamed("HistoryCell", owner: self, options: nil)?.first as! HistoryCell
        if(indexPath == IndexPath.init(item: 0, section: 0)){
            cell.lbl_CellTitle.text = "إحصائيات الشهر الحالي"
            cell.category = "Current Month"
        }else{
            cell.lbl_CellTitle.text = "إحصائيات الشهور الماضية"
            cell.category = "Other Months"
        }
            cell.delegate = self
            return cell
    }
    
    
    
}
extension HistoryViewController: HistoryCellProtocol{
    func transitions(category: String, side: Int) {
        //Get the category and the button's tag to display before transition
        if(side == 0){
            if(category == "Current Month"){
                Calendar.categ = Calendar.getCurrentMonth()
                Calendar.side = side
                self.performSegue(withIdentifier: "goToCurrentMonthHistory", sender: self)
            }else{
                self.performSegue(withIdentifier: "goToMonthsClass", sender: self)
                Calendar.categ = ""
            }
        }else{
            if(category == "Current Month"){
                Calendar.categ = Calendar.getCurrentMonth()
                Calendar.side = side
                self.performSegue(withIdentifier: "goToStatClass", sender: self)
            }else{
                self.performSegue(withIdentifier: "goToMonthsClass", sender: self)
                Calendar.categ = ""
            }
        }
        

    }
    
    
}
