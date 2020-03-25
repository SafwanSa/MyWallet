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
    var chart: PieChartView!
    var userData = [String:Any]()
    var allPayments = [
        [Payment](),
        [Payment](),
        [Payment](),
        [Payment](),
        [Payment](),
        [Payment](),
        [Payment]()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataSourceDelivery = DataSource(type: "ppayment")
        dataSourceDelivery.dataSourceDelegate = self
    }
    
    //MARK:- TableView Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //If it is the first section, then display the (StatAvgCell)
        if(indexPath.section == 0){
            let cell = Bundle.main.loadNibNamed("StatAvgCell", owner: self, options: nil)?.first as! StatAvgCell
            //Cell configuration
            cell.setUpAverage(costs: self.costs)
            return cell
        //If it is the second section, then display the (MaxTypeCell)
        }else if(indexPath.section == 1){
            let cell = Bundle.main.loadNibNamed("MaxTypeCell", owner: self, options: nil)?.first as! MaxTypeCell
            return cell
        //If it is the third section, then display the (StatTypeCell)
        }else if(indexPath.section == 2){
            let cell = Bundle.main.loadNibNamed("StatTypeCell", owner: self, options: nil)?.first as! StatTypeCell
            cell.updateChartData(payments: self.allPayments, userData: self.userData, type: "cost")
            cell.lbl_cellTitle.text = "قيمة كل تصنيف من مجموع المصاريف"
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("StatTypeCell", owner: self, options: nil)?.first as! StatTypeCell
            cell.updateChartData(payments: self.allPayments, userData: self.userData, type: "percent")
            cell.lbl_cellTitle.text = "نسبة كل تصنيف من الميزانية"
            return cell
        }
    }
}
//MARK:- Delegate and protocol overriding
extension StatTableViewController: DataSourceProtocol{
    func paidDataUpdated(data: [[Payment]]) {
        self.allPayments = data
        self.myTableView.reloadData()
    }
    func unpaidDataUpdated(data: [Payment]) {}
    func userDataUpdated(data: [String : Any], which: String) {
        if(which == "budgets"){
            self.userData = data
            self.myTableView.reloadData()
        }
    }
    func getMonths(months: [String]) {}
    func getCosts(costs: [Float]) {
        self.costs = costs
        self.myTableView.reloadData()
    }
    
    
}
