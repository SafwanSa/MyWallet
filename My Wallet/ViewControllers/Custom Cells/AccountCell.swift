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
    @IBOutlet weak var txt_lname: UITextField!
    @IBOutlet weak var txt_email: UITextField!

    //MARK:- Intsance Vars
    var dataSourceDelivery : DataSource?
    
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
    
}
extension AccountCell: DataSourceProtocol{

    func userDataUpdated(data: [String : Any], which:String) {
        if(which == "user"){
            txt_email.text = data["Email"] as? String
            txt_fname.text = data["First Name"] as? String
            txt_lname.text = data["Last Name"] as? String
        }
    }
    
    
}
