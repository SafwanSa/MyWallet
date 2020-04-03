//
//  NewMonthViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 03/04/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class NewMonthViewController: UIViewController {

    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_month: UILabel!
    
    var dataSourceDelivery: DataSource?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.dataSourceDelivery = DataSource()
        self.dataSourceDelivery?.dataSourceDelegate = self
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        //Move the user
    }
    
}
extension NewMonthViewController: DataSourceProtocol{
    func userDataUpdated(data: [String : Any], which: String) {
        if which == "user"{
            lbl_name.text = data["First Name"] as? String
            lbl_month.text = Calendar.getMonthInAr(m: Calendar.getCurrentMonth())
        }
    }
}
