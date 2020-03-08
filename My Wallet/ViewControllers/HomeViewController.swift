//
//  HomeViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 19/09/2019.
//  Copyright © 2019 Safwan Saigh. All rights reserved.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore
import UICircularProgressRing
import Charts
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    
    
    //MARK: -Main Storyboard vars
    @IBOutlet weak var prog_view: UICircularProgressRing!
    @IBOutlet weak var bottom_view: GradientView!
    
    
    //Top View
    @IBOutlet weak var btn_add: RoundButton!
    @IBOutlet weak var lbl_budget: UILabel!
    
    //Bottom View
    @IBOutlet weak var myTableView: UITableView!
    
    //MARK: -Instance vars
    var unpaidPaymentsList = [Payment]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeKeyboard()
        myTableView.dataSource = self
        myTableView.delegate = self
        
        //Customize the View's
        bottom_view.layer.shadowOffset = .zero
        bottom_view.layer.shadowRadius = 5
        bottom_view.layer.shadowOpacity = 0.6
        bottom_view.layer.masksToBounds = false
        btn_add.layer.shadowOffset = .zero
        btn_add.layer.shadowRadius = 5
        btn_add.layer.shadowOpacity = 0.8
        btn_add.layer.masksToBounds = false
        
        //Styling the progress bar
        prog_view.style = .dashed(pattern: [7.0, 7.0])

        //Seting up the delegate
        let dataSourceDelivery = DataSource(type: "uppayment")
        dataSourceDelivery.dataSourceDelegate = self
    }
    
    //MARK:- TableView Configuraion
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Take the payments one by one from the array
        let payment = self.unpaidPaymentsList[indexPath.row]
        let cost = payment.cost
        let title = payment.title
        let ats = payment.at
        let type = payment.type
        //Confgiuer Cell
        let cell = Bundle.main.loadNibNamed("UnpaidCell", owner: self, options: nil)?.first as! UnpaidCell
        cell.lbl_cost.text = "SAR "+String(cost)
        cell.lbl_title.text = title
        cell.paymentType = type
        cell.paymentDate = ats
        return cell
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Styling the Title of the Table
        let label = UILabel()
        let str = " لديك " + String(self.unpaidPaymentsList.count) + " من المصروفات غير مدفوعة"
        label.text = str
        label.font = UIFont.init(name: "JF Flat", size: 18)
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unpaidPaymentsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK:- Kb closing
    func closeKeyboard(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
}
//MARK:- Delegate and protocol overriding
extension HomeViewController: DataSourceProtocol{
    func paidDataUpdated(data: [[Payment]]) {} // Nothing happens here
    
    //This will be excuted when any updates happens to userInfo
    func userDataUpdated(data: [String : Any]) {
        self.lbl_budget.text = String(data["Budget"] as! Float)
        let budget = data["Budget"] as! Float
        let savings = data["Savings"] as! Float
//        let startBudget = data["Starting Budget"] as! Float
        let startBudget = Float(5000)
        let percent = (100 * budget)/startBudget
        self.prog_view.startProgress(to: CGFloat(percent), duration: 3.0) {}
    }
    //This method will be excuted when any updates happens to "uppayments"
    func unpaidDataUpdated(data: [Payment]) {
        unpaidPaymentsList = data
        self.myTableView.reloadData()
    }
    
    
}

