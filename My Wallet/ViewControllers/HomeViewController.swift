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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                //Take the payments one by one from the array
        let payment = self.unpaidList[indexPath.row]
        //Split it into cost, title, and paid
        let splitedString = payment.components(separatedBy: ",")
        let cost = splitedString[1]
        let title = splitedString[0]
        let ats = splitedString[3]
        let type = splitedString[2]
        //Confgiuer Cell
         let cell = Bundle.main.loadNibNamed("StatByCategory", owner: self, options: nil)?.first as! StatByCategory
        cell.lbl_cost.text = "SAR "+cost
        cell.lbl_title.text = title
        return cell
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Styling the Title of the Table
        let label = UILabel()
        let str = " لديك " + String(self.unpaidList.count) + " من المصروفات غير مدفوعة"
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
        return unpaidList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    var unpaidList = [String]()

    
    @IBOutlet weak var prog_view: UICircularProgressRing!
    @IBOutlet weak var bottom_view: GradientView!
    
    
    //Top View
    @IBOutlet weak var btn_add: RoundButton!
    @IBOutlet weak var lbl_budget: UILabel!
    
    //Bottom View
    @IBOutlet weak var myTableView: UITableView!
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        closeKeyboard()

        bottom_view.layer.shadowOffset = .zero
        bottom_view.layer.shadowRadius = 5
        bottom_view.layer.shadowOpacity = 0.6
        bottom_view.layer.masksToBounds = false
        
        btn_add.layer.shadowOffset = .zero
        btn_add.layer.shadowRadius = 5
        btn_add.layer.shadowOpacity = 0.8
        btn_add.layer.masksToBounds = false
        
        
        prog_view.style = .dashed(pattern: [7.0, 7.0])
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        updateData()
        
        
        myTableView.dataSource = self
        myTableView.delegate = self
    }



    func getData(){
      db.collection("uppayment").whereField("uid", isEqualTo: getID())
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                  self.clearArray()
                    for document in querySnapshot!.documents {
                        self.unpaidList = (self.toArray(data: document.data()))
                      self.myTableView.reloadData()
                    }
                }
        }
    }
    
    
    func toArray(data:[String:Any])->[String]{
        //This method convert a Dictionary from the DataBase to array
        var costs = [String]()
        var titles = [String]()
        var ats = [String]()
        var types = [String]()
        
        for i in data{
            let key = i.key
            let value = i.value
                    if key == "Cost"{
                        let q = value as? NSNumber
                        costs.append("\(q!.stringValue)")
                    }else if key == "Title"{
                        titles.append("\((value as? String)!)")
                    }else if key == "At"{
                        ats.append("\((value as? String)!)")
                    }else if key == "Type"{
                        types.append("\((value as? String)!)")
                    }else if key == "Paid"{}
        }
        for i in 0...costs.count-1{
            unpaidList.append(titles[i]+","+costs[i]+","+types[i]+","+ats[i])
        }
        return unpaidList
    }
    
    
    
    @objc func loadList(notification: NSNotification){
        //load data here after adding payment
        updateData()
        clearArray()
        getData()
    }
    
    
     override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           updateData()
            clearArray()
            getData()
       }
    
    func updateData(){
        db.collection("user").document(getID()).getDocument { (DocumentSnapshot, Error) in
           let data =  DocumentSnapshot!.data()
            self.lbl_budget.text = String(data!["Budget"] as! Float)
//            self.lbl_savings.text = String("مدخراتك: "+String(data!["Savings"] as! Float))
            let budget = data!["Budget"] as! Float
            print(budget)
            let savings = data!["Savings"] as! Float
            let percent = (100 * budget)/5000
            self.prog_view.startProgress(to: CGFloat(percent), duration: 3.0) {
              print("Done animating!")
              // Do anything your heart desires...
            }
            
        }
        
        
        
    }
    
    func clearArray(){
        unpaidList.removeAll()
    }
    

    func getID()->String{
        return Auth.auth().currentUser!.uid
    }
    
   
    
    func closeKeyboard(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    
   
    

    

}


