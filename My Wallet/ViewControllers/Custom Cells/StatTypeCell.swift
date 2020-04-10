//
//  StatTypeCell.swift
//  My Wallet
//
//  Created by Safwan Saigh on 15/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import Charts

class StatTypeCell: UITableViewCell {
    
    
    @IBOutlet weak var lbl_cellTitle: UILabel!
    @IBOutlet weak var pieView: PieChartView!

    var allPayments = [[Payment]]()

    
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
    
    func updateChartData(payments: [[Payment]], userData: [String:Any])  {
        var values = [Double]()
        values = Calculations.getCostPercentageForTypes(payments: payments, userData: userData)
        let labels = ["أخرى","صحة","ترفيه","مواصلات","طعام","تسوق","فواتير"]
        var entries = [PieChartDataEntry]()
        for (index, value) in values.enumerated() {
            if(value != 0){
                let entry = PieChartDataEntry()
                entry.y = value
                entry.label = labels[index]
                entries.append(entry)
            }
        }

        // 3. chart setup
        let set = PieChartDataSet(entries: entries, label: "")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []

        for _ in 0..<values.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        set.entryLabelFont = UIFont(name: "JF Flat", size: 10)
        set.valueFont = UIFont(name: "JF Flat", size: 13)!
        set.entryLabelColor = .black
        set.valueLineColor = .black
        set.xValuePosition = .outsideSlice
        let data = PieChartData(dataSet: set)

        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        formatter.zeroSymbol = ""
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        pieView.data = data
        pieView.legend.enabled = false
        pieView.noDataText = "No data available"
        // user interaction
        pieView.isUserInteractionEnabled = true

//        let d = Description()
//        d.text = "iOSCharts.io"
//        pieView.chartDescription = d
//        pieView.centerText = ""
        pieView.holeRadiusPercent = 0.5
        pieView.transparentCircleColor = UIColor.clear
    }
    
    
}
//MARK:- Delegate and protocol overriding
extension StatTypeCell: DataSourceProtocol{
    func paidDataUpdated(data: [[Payment]]) {
        self.allPayments = data
    }
    func userDataUpdated(data: [String : Any], which: String) {
        if(which == "budgets"){
            updateChartData(payments: self.allPayments, userData: data)
        }
    }

}
