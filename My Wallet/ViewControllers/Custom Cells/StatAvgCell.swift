//
//  StatCell.swift
//  My Wallet
//
//  Created by Safwan Saigh on 14/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class StatAvgCell: UITableViewCell {

    
    @IBOutlet weak var lbl_cost_byDay: UILabel!
    @IBOutlet weak var lbl_count_byDay: UILabel!
    @IBOutlet weak var lbl_cost_byWeek: UILabel!
    @IBOutlet weak var lbl_count_byWeek: UILabel!
    
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
    
    func setupAverage(costs:[Float]){
        let avgCostByDay = String(Calculations.getAverageCosts(costs: costs, by: "day"))
        let avgCountByDay = String(Calculations.getAverageCounts(costs: costs, by: "day"))
        let avgCostByWeek = String(Calculations.getAverageCosts(costs: costs, by: "week"))
        let avgCountByWeek = String(Calculations.getAverageCounts(costs: costs, by: "week"))
        lbl_cost_byDay.text = "SAR "+avgCostByDay
        lbl_count_byDay.text = avgCountByDay+" مصروفات"
        lbl_cost_byWeek.text = "SAR "+avgCostByWeek
        lbl_count_byWeek.text = avgCountByWeek+" مصروفات"
    }

}
extension StatAvgCell: DataSourceProtocol{
        func getCosts(costs: [Float]) {
            setupAverage(costs: costs)
    }
}
