//
//  StatTableViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 14/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class StatTableViewController: UITableViewController{
    @IBOutlet var myTableView: UITableView!
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if(indexPath.section == 0){
             cell = Bundle.main.loadNibNamed("StatAvgCell", owner: self, options: nil)?.first as! StatAvgCell
        }else{
             cell = Bundle.main.loadNibNamed("MaxTypeCell", owner: self, options: nil)?.first as! MaxTypeCell
        }
        return cell
    }
    
}
