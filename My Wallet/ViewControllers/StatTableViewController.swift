//
//  StatTableViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 14/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class StatTableViewController: UITableViewController{
    @IBOutlet var myTableView: UITableView!
    

    var costs = [Float]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataSourceDelivery = DataSource(type: "ppayment")
        dataSourceDelivery.dataSourceDelegate = self
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = Bundle.main.loadNibNamed("StatAvgCell", owner: self, options: nil)?.first as! StatAvgCell
            cell.setUpAverage(costs: self.costs)
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("MaxTypeCell", owner: self, options: nil)?.first as! MaxTypeCell
            return cell
        }
    }
    
}
extension StatTableViewController: DataSourceProtocol{
    func paidDataUpdated(data: [[Payment]]) {}
    
    func unpaidDataUpdated(data: [Payment]) {}
    
    func userDataUpdated(data: [String : Any], which: String) {}
    
    func getMonths(months: [String]) {}
    
    func getCosts(costs: [Float]) {
        self.costs = costs
        self.myTableView.reloadData()
    }
    
    
}
