//
//  BarChartCell.swift
//  My Wallet
//
//  Created by Safwan Saigh on 08/04/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import Charts

class BarChartCell: UITableViewCell {

    
    @IBOutlet weak var barChartView: HorizontalBarChartView!
    
    var allPayments = [[Payment]]()
    var types: [String]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let dataSourceDelivery = DataSource(type: "ppayment")
        dataSourceDelivery.dataSourceDelegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
    
        var dataEntries: [BarChartDataEntry] = []
                
        for i in 0..<values.count {
            let j = Double(i)
            let dataEntry = BarChartDataEntry(x: j, y: values[i])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries)
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:types)
        chartData.barWidth = 0.5
        barChartView.legend.enabled = false
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.drawValueAboveBarEnabled = true
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.drawGridBackgroundEnabled = false
        barChartView.clipValuesToContentEnabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelFont = UIFont(name: "JF Flat", size: 8)!
        barChartView.xAxis.labelTextColor = .black
        barChartView.extraBottomOffset = 10
        barChartView.extraTopOffset = 10
        barChartView.extraLeftOffset = 15
        barChartView.extraRightOffset = 10
    }

    
    
}
//MARK:- Delegate and protocol overriding
extension BarChartCell: DataSourceProtocol{
    func paidDataUpdated(data: [[Payment]]) {
        self.allPayments = data
        self.types = ["أخرى","صحة","ترفيه","مواصلات","طعام","تسوق","فواتير"]
        let costs = Calculations.getCostForEachType(payments: data)
        setChart(dataPoints: types, values: costs)
    }
}
