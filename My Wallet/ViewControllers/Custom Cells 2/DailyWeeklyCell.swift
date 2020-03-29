//
//  DailyWeeklyCell.swift
//  My Wallet
//
//  Created by Safwan Saigh on 29/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class DailyWeeklyCell: UITableViewCell {

    @IBOutlet weak var txt_weeklyCost: UITextField!
    @IBOutlet weak var txt_dailyCost: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
