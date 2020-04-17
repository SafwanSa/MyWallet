//
//  StatTableViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 14/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import Charts

class StatTableViewController: UITableViewController{
    @IBOutlet var myTableView: UITableView!
    
    //MARK:- Vars Declaration
    var costs = [Float]()
    let cells = ["StatusCell","BillInfoCell","StatGoalCell","StatAvgCell","BarChartCell","StatTypeCell"]
    override func viewDidLoad() {
        super.viewDidLoad()
        SuperNavigationController.setTitle(title: "إحصائيات", nv: self)
        for cellName in cells{
            myTableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        }
    }
    
    //MARK:- TableView Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 || indexPath.section == 5{
            return 247
        }else{
            return 168
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Styling the Title of the Table
        let label = UILabel()
        let sectionNames = ["","فواتيرك","هدفك لمقدار الصرف","متوسط الصرف","قيمة كل تصنيف من مجموع المصاريف","نسبة كل تصنيف من الميزانية"]
        label.text = sectionNames[section]
        label.font = UIFont.init(name: "JF Flat", size: 16)
        label.textAlignment = NSTextAlignment.right
        label.textColor = .gray
        label.alpha = 0.6
        return label
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return myTableView.dequeueReusableCell(withIdentifier: cells[indexPath.section])!
    }
}
