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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DataBank.shared.getUserInfo { (user) in
            self.setupInfo(user: user)
        }
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        //Move the user
    }
    
    func setupInfo(user: UserInfo){
        lbl_name.text = user.first_name
        lbl_month.text = Calendar.getMonthInAr(m: Calendar.getCurrentMonth())
    }
    
}
