//
//  BdgSavCell.swift
//  My Wallet
//
//  Created by Safwan Saigh on 28/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class BdgSavCell: UITableViewCell {

    @IBOutlet weak var lbl_budget: UILabel!
    @IBOutlet weak var lbl_savings: UILabel!
    @IBOutlet weak var sldr_budget: UISlider!
    @IBOutlet weak var sldr_savings: UISlider!
    
    var dataSourceDelivery: DataSource?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dataSourceDelivery = DataSource()
        dataSourceDelivery?.dataSourceDelegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
        //MARK:- Sliders actions
    @IBAction func slidersMove(_ sender: UISlider) {
        //Fix the incremen to be by 50
        let steps: Float = 50
        let roundedValue = round(sender.value / steps) * steps
        sender.value = roundedValue
        updateSliders()
    }
    
        //MARK:- Updating the sliders
    func updateSliders(){
          self.lbl_budget.text = String(Int(sldr_budget.value))+".0"
          self.lbl_savings.text = String(Int(sldr_savings.value))+".0"
          sldr_savings.maximumValue = Float(lbl_budget.text!)!
      }
    
    
}
extension BdgSavCell: DataSourceProtocol{

    func userDataUpdated(data: [String : Any], which:String) {
        if(which == "budgets"){
            sldr_budget.value = (data["Current Amount"] as? Float)!
            lbl_budget.text = String((data["Current Amount"] as? Float)!)
            sldr_savings.value = (data["Savings"] as? Float)!
            lbl_savings.text = String((data["Savings"] as? Float)!)
        }
    }
}
