//
//  MonthsTableViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 12/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class MonthsTableViewController: UITableViewController{
    

    
    @IBOutlet var myTableView: UITableView!
    var months = [String]()
    
    
    override func loadView() {
        super.loadView()
        let dataSourceDelivery = DataSource(type: "months")
        dataSourceDelivery.dataSourceDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SuperNavigationController.setTitle(title: "الشهور الماضية", nv: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "monthCell", for: indexPath)
        let month = Calendar.getMonthInAr(m:String(self.months[indexPath.row].split(separator: "/")[0]))
        let year = self.months[indexPath.row].split(separator: "/")[1]
        cell.textLabel?.text = month + "    " + year
        cell.textLabel?.textAlignment = NSTextAlignment.right
        cell.textLabel?.font = UIFont(name: "JF Flat", size: 13)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return months.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Calendar.categ = self.months[indexPath.row]
        if(Calendar.side == 0){
            self.performSegue(withIdentifier: "goToCurrentMonthHistory", sender: self)
        }else if(Calendar.side == 1){
            self.performSegue(withIdentifier: "goToStatClass", sender: self)
        }

    }
    
    
}
extension MonthsTableViewController: DataSourceProtocol{
    func getMonths(months: [String]) {
        self.months = months
        self.myTableView.reloadData()
    }
}
