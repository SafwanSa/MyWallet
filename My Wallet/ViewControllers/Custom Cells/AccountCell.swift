//
//  AccountCell.swift
//  My Wallet
//
//  Created by Safwan Saigh on 25/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {
    
    @IBOutlet weak var txt_fname: UITextField!
    @IBOutlet weak var txt_email: UITextField!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DataBank.shared.getUserInfo { (user) in
            self.setupInfo(user: user)
        }
    }
    
    func setupInfo(user: UserInfo){
        txt_email.text = user.email
        txt_fname.text = user.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
