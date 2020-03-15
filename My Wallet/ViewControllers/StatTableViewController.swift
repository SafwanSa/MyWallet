//
//  StatTableViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 14/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import SwiftCharts
class StatTableViewController: UITableViewController{
    @IBOutlet var myTableView: UITableView!
    

    var costs = [Float]()
    var chart: BarsChart?
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
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
        }else if(indexPath.section == 1){
            let cell = Bundle.main.loadNibNamed("MaxTypeCell", owner: self, options: nil)?.first as! MaxTypeCell
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("StatTypeCell", owner: self, options: nil)?.first as! StatTypeCell
            let eachCost = Calculations.getCostForEachType(payments: self.allPayments)
            let maxValue = Calculations.getMaxCostForType(typesAndCost: eachCost)
            //Setting up the bar chart
            let chartConfig = BarsChartConfig(
                valsAxisConfig: ChartAxisConfig(from: 0, to: 1000, by: 150)
                )
//            chartConfig.xAxisLabelSettings.font = UIFont(name: "JF Flat", size: 9)

            let frame = CGRect(x: 0, y: 20, width: cell.view.frame.width-60, height:  136)
            let typesNames = ["أخرى","صحة","ترفيه","مواصلات","طعام","تسوق","وقود"]
                  let chart = BarsChart(
                      frame: frame,
                      chartConfig: chartConfig,
                      xTitle: "التصنيفات",
                      yTitle: "قيمة الصرف",
                      bars: [
                        (typesNames[0], eachCost[0]!),
                          (typesNames[1], eachCost[1]!),
                          (typesNames[2], eachCost[2]!),
                          (typesNames[3], eachCost[3]!),
                          (typesNames[4], eachCost[4]!),
                          (typesNames[5], eachCost[5]!),
                          (typesNames[6], eachCost[6]!)
                      ],
                      color: UIColor.gray,
                      barWidth: 10
                  )
            
            cell.view.addSubview(chart.view)
                  self.chart = chart
            return cell
        }
    }
    
}
extension StatTableViewController: DataSourceProtocol{
    func paidDataUpdated(data: [[Payment]]) {
        print(data)
        self.allPayments = data
        self.myTableView.reloadData()
    }
    
    func unpaidDataUpdated(data: [Payment]) {}
    
    func userDataUpdated(data: [String : Any], which: String) {}
    
    func getMonths(months: [String]) {}
    
    func getCosts(costs: [Float]) {
        self.costs = costs
        self.myTableView.reloadData()
    }
    
    
}
