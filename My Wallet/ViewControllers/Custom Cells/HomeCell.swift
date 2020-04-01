//
//  HomeCell.swift
//  My Wallet
//
//  Created by Safwan Saigh on 15/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import UICircularProgressRing

protocol HomeCellProtocol {
    func transitions()
}

class HomeCell: UITableViewCell {

    //Top View
    @IBOutlet weak var prog_view: UICircularProgressRing!
    @IBOutlet weak var btn_add: RoundButton!
    @IBOutlet weak var lbl_budget: UILabel!
    @IBOutlet weak var lbl_savings: UILabel!
    @IBOutlet weak var lbl_totalPaymentsCost: UILabel!
    //Bottom View
    
    var userData = [String:Any]()
    var delegate: HomeCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btn_add.layer.shadowOffset = .zero
        btn_add.layer.shadowRadius = 5
        btn_add.layer.shadowOpacity = 0.8
        btn_add.layer.masksToBounds = false
        //Styling the progress bar
        prog_view.style = .dashed(pattern: [7.0, 7.0])
        let dataSourceDelivery = DataSource()
        dataSourceDelivery.dataSourceDelegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btn_addPressed(_ sender: RoundButton) {
        if(self.delegate != nil){ //Just to be safe.
            self.delegate?.transitions()
        }
    }
    
    func setUserData(data: [String:Any]){
        let budget = data["Current Amount"] as! Float
        let savings = data["Savings"] as! Float
        let startBudget = data["Start Amount"] as! Float
        var percent: Float = 0.0
        if startBudget != 0{percent = (100 * budget)/startBudget}
        let totalCosts = startBudget - budget
        
        self.lbl_totalPaymentsCost.text = "مصروفات "+String(totalCosts)+" SAR "
        self.lbl_savings.text = "مدخرات "+String(savings)+" SAR "
        self.lbl_budget.text = String(budget)+" SAR "
        self.prog_view.startProgress(to: CGFloat(percent), duration: 3.0) {}
    }
}
extension HomeCell: DataSourceProtocol{

    //This will be excuted when any updates happens to userInfo
    func userDataUpdated(data: [String : Any], which: String) {
        if(which == "budgets"){
            self.userData = data
            setUserData(data: self.userData)
        }
    }
}
