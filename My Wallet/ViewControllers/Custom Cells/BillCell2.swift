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
    @IBOutlet weak var lbl_remain: UILabel!
    
    var paymentDate = ""
    var paymentType = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbl_remain.isHidden = true
        backGroundView.layer.shadowOpacity = 0.6
        backGroundView.layer.shadowRadius = 2
        backGroundView.layer.shadowOffset = .zero
        backGroundView.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupInfo(){
        lbl_remain.isHidden = false
        let currentDay = Int(Calendar.getFormatedDate(by: "day", date: Calendar.getFullDate()))!
        let billDay = Int(lbl_day.text!)!
        var days = 0
        if billDay > currentDay{
            if billDay - currentDay == 1{
                //Tommorow
                lbl_remain.text = "تصدر الفاتورة غداً"
            }else if billDay - currentDay > 1{
                //After billday - currentDay
                days = billDay - currentDay
                lbl_remain.text = " تصدر الفاتورة بعد "+String(days)+" يوم "
            }
        }else if billDay < currentDay{
            //20    //26        -> after 26 - 20 + max day in a month
            var month = 0
            if Int(Calendar.getCurrentMonth()) == 12{
                month = 1
            }else{
                month = Int(Calendar.getCurrentMonth())! + 1
            }
            let maxDay = Calendar.getMaxDayInCurrentMonth()
            days =  maxDay - currentDay + billDay
            //23 - 2 + 30
            lbl_remain.text = " تصدر بعد "+String(days)+" يوم "
        }else{
            //Today
            lbl_remain.text = "صدرت الفاتورة اليوم"
        }
    }
    
}

