//
//  HistoryViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 09/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
class HistoryViewController: UITableViewController{
    
    
    
    var month = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        SuperNavigationController.setTitle(title: "الملخص", nv: self)
    }
    
   
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Styling the sections
        let sectionsNames = ["إحصائيات الشهر الحالي", "إحصائيات الشهور الماضية"]
        let label = UILabel()
        label.text = sectionsNames[section]
        label.font = UIFont.init(name: "JF Flat", size: 19)
        label.textAlignment = NSTextAlignment.center
        label.textColor = .lightGray
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
    func transitions(category: String, side: Int) {
        //Get the category and the button's tag to display before transition
        if(side == 0){
            if(category == "Current Month"){
                Calendar.categ = Calendar.getCurrentMonth()+"/"+Calendar.getCurrentYear()
                Calendar.side = side
                self.performSegue(withIdentifier: "goToCurrentMonthHistory", sender: self)
            }else{
                self.performSegue(withIdentifier: "goToMonthsClass", sender: self)
                Calendar.side = side
                Calendar.categ = ""
            }
        }else{
            if(category == "Current Month"){
                Calendar.categ = Calendar.getCurrentMonth()+"/"+Calendar.getCurrentYear()
                Calendar.side = side
                self.performSegue(withIdentifier: "goToStatClass", sender: self)
            }else{
                self.performSegue(withIdentifier: "goToMonthsClass", sender: self)
                Calendar.side = side
                Calendar.categ = ""
            }
        }
        

    }
    
    
}
