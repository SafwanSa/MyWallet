//
//  BillCell2.swift
//  My Wallet
//
//  Created by Safwan Saigh on 25/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class BillCell2: UITableViewCell {

    @IBOutlet weak var backGroundView: GradientView!
    @IBOutlet weak var insideBackground: GradientView!
    
    @IBOutlet weak var lbl_cost: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_day: UILabel!
    
    var paymentDate = ""
    var paymentType = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backGroundView.layer.shadowOpacity = 0.6
        backGroundView.layer.shadowRadius = 2
        backGroundView.layer.shadowOffset = .zero
        backGroundView.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

