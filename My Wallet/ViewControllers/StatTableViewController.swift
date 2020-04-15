//
//  StatTableViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 14/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import Charts

class StatTableViewController: UITableViewController{
    @IBOutlet var myTableView: UITableView!
    
    //MARK:- Vars Declaration
    var costs = [Float]()
    var budgets = [Budget]()
    var totalCost: Double = 0.0
    let dataSourceDelivery = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SuperNavigationController.setTitle(title: "إحصائيات", nv: self)
        

        dataSourceDelivery.dataSourceDelegate = self
        self.dataSourceDelivery.getPreviuosBudgets()
    }
    
    //MARK:- TableView Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 || indexPath.section == 4{
            return 247
        }else{
            return 168
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Styling the Title of the Table
        let label = UILabel()
        let title1 = ""
        let title2 = "متوسط الصرف"
        let title3 = "هدفك لمقدار الصرف"
        let title4 = "قيمة كل تصنيف من مجموع المصاريف"
        let title5 = "نسبة كل تصنيف من الميزانية"
        let sectionsNames = [title1,title2,title3,title4,title5]
        label.text = sectionsNames[section]
        label.font = UIFont.init(name: "JF Flat", size: 16)
        label.textAlignment = NSTextAlignment.right
        label.textColor = .gray
        label.alpha = 0.6
        return label
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            let cell = Bundle.main.loadNibNamed("StatusCell", owner: self, options: nil)?.first as! StatusCell
            cell.budgets = budgets
            cell.totalCost = totalCost
            cell.setupViews()
            return cell
        }
        if(indexPath.section == 1){
            let cell = Bundle.main.loadNibNamed("StatAvgCell", owner: self, options: nil)?.first as! StatAvgCell
            return cell
        }else if(indexPath.section == 2){
            let cell = Bundle.main.loadNibNamed("StatGoalCell", owner: self, options: nil)?.first as! StatGoalCell
            return cell
        }else if(indexPath.section == 3){
            let cell = Bundle.main.loadNibNamed("BarChartCell", owner: self, options: nil)?.first as! BarChartCell
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("StatTypeCell", owner: self, options: nil)?.first as! StatTypeCell
            return cell
        }
    }
}
extension StatTableViewController: DataSourceProtocol{
    func getPrevBudgets(budgets: [Budget]) {
        print("dddddddddd\n\n\n\n\n")
         self.budgets = budgets
         let requiredMonth = Calendar.categ.split(separator: "/")[0]
         let requiredYear = Calendar.categ.split(separator: "/")[1]
         let requiredBudgetId = Calendar.getID()+"_Budget_"+requiredMonth+"_"+requiredYear
         self.budgets.removeAll { (bdg) -> Bool in
             if bdg.bid != requiredBudgetId{
                 return true
             }else{
                 return false
             }
         }
        myTableView.reloadData()
     }
     func paidDataUpdated(data: [[Payment]]) {
         self.totalCost = Calculations.getTotalCost(paymnets: data)
     }
}
