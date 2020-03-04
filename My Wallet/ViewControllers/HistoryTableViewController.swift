//
//  HistoryTableViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 29/09/2019.
//  Copyright © 2019 Safwan Saigh. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import BetterSegmentedControl

class HistoryTableViewController: UITableViewController {
    

    @IBOutlet weak var sgmntd_oa: BetterSegmentedControl!
    
    @IBOutlet weak var sgmnt_types2: BetterSegmentedControl!
    
    var db = Firestore.firestore()
    var allPayments = [
        [String](),
        [String](),
        [String](),
        [String](),
        [String](),
        [String](),
        [String]()
    ]

    
    
    
    
    
    
    var displayed = "ppayment"
    var typesIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "مشترياتك"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "JF Flat", size: 19)!]
            
        sgmntd_oa.segments = LabelSegment.segments(withTitles: ["المصاريف المدفوعة","المصاريف غير المدفوعة"],normalFont: UIFont(name: "JF Flat", size: 13), normalTextColor: UIColor.darkGray,selectedFont: UIFont(name: "JF Flat", size: 14))
        
        sgmnt_types2.segments = LabelSegment.segments(withTitles: ["أخرى","صحة","ترفيه","مواصلات","طعام","تسوق","وقود"] ,normalFont: UIFont(name: "JF Flat", size: 11), normalTextColor: UIColor.darkGray,selectedFont: UIFont(name: "JF Flat", size: 12),selectedTextColor: UIColor.darkText)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load1"), object: nil)

        


        
        
    }
    
    @objc func loadList(notification: NSNotification){
        //load data here
        clearArray()
        self.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearArray()
        getData()
    }

    func getID()->String{
        return Auth.auth().currentUser!.uid
    }
    

    @IBAction func sgmnt_types(_ sender: BetterSegmentedControl) {
        getData()
        if(sender.index == 0){
            typesIndex = 0
        }else if(sender.index == 1){
            typesIndex = 1
        }else if(sender.index == 2){
            typesIndex = 2
        }else if(sender.index == 3){
            typesIndex = 3
        }else if(sender.index == 4){
            typesIndex = 4
        }else if(sender.index == 5){
            typesIndex = 5
        }else if(sender.index == 6){
            typesIndex = 6
        }else if(sender.index == 7){
            typesIndex = 7
        }
        self.tableView.reloadData()
    }
    
    @IBAction func sgmnt_paid(_ sender: BetterSegmentedControl) {
        //We are set the variable that responses of displaying paid or unpaid payments
        if (sender.index == 0){
            displayed = "ppayment"
        }else{
            displayed = "uppayment"
        }
            print(displayed)
            clearArray()
            getData()
            self.tableView.reloadData()
    }
    

    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Styling the sections
        let sectionsNames = ["أخرى","صحة","ترفيه","مواصلات","طعام","تسوق","وقود"]
        let label = UILabel()
        label.text = sectionsNames[typesIndex]
        label.font = UIFont.init(name: "JF Flat", size: 19)
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    func getData(){
        db.collection(displayed).whereField("uid", isEqualTo: getID())
              .getDocuments() { (querySnapshot, err) in
                  if let err = err {
                      print("Error getting documents: \(err)")
                  } else {
                    self.clearArray()
                      for document in querySnapshot!.documents {
                        self.allPayments = self.toArray(array: document.data())
                        self.tableView.reloadData()
                      }
                  }
          }
      }
    
    

    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79.5
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 49
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPayments[typesIndex].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Take the payments one by one from the array
        let payment = self.allPayments[typesIndex][indexPath.row]
        //Split it into cost, title, and paid
        let splitedString = payment.components(separatedBy: ",")
        let cost = splitedString[0]
        let title = splitedString[1]
        let paid = Bool(splitedString[2])!
        let ats = splitedString[3]
        let type = splitedString[4]
        //Take the cell from TableViewCell1
        let cell = Bundle.main.loadNibNamed("TableViewCell1", owner: self, options: nil)?.first as! TableViewCell1
        
            //Giving each cell an id (the date the time)
            cell.setID(id: ats)
            cell.lbl_title.text = String(title)
            cell.type = type
            // Configure the cell...
        if(paid){
            cell.setPaidCell(cost: cost)
                    return cell
        }else{
            cell.setUnPaidCell(cost:cost)
                    return cell
        }


    }
 
    func toArray(array:[String:Any])->[[String]]{
        //This method convert a Dictionary to array
        var costs = [String]()
        var titles = [String]()
        var ats = [String]()
        var types = [String]()
        var paid = [String]()
        
        for i in array{
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
                    }else if key == "Paid"{
                        paid.append("\((value as? Bool)!)")
                    }
        }
        
        for i in 0...costs.count-1{
            if types[i] == "أخرى"{
                allPayments[0].append(""+costs[i] + ","+titles[i]+","+paid[i]+","+ats[i]+","+types[i])
            }else if types[i] == "صحة"{
                allPayments[1].append(""+costs[i] + ","+titles[i]+","+paid[i]+","+ats[i]+","+types[i])
            }else if types[i] == "ترفيه"{
                allPayments[2].append(""+costs[i] + ","+titles[i]+","+paid[i]+","+ats[i]+","+types[i])
            }else if types[i] == "مواصلات"{
                allPayments[3].append(""+costs[i] + ","+titles[i]+","+paid[i]+","+ats[i]+","+types[i])
            }else if types[i] == "طعام"{
                allPayments[4].append(""+costs[i] + ","+titles[i]+","+paid[i]+","+ats[i]+","+types[i])
            }else if types[i] == "تسوق"{
                allPayments[5].append(""+costs[i] + ","+titles[i]+","+paid[i]+","+ats[i]+","+types[i])
            }else if types[i] == "وقود"{
                allPayments[6].append(""+costs[i] + ","+titles[i]+","+paid[i]+","+ats[i]+","+types[i])
            }
        }
        return allPayments
    }


    func clearArray(){
        for i in 0 ... allPayments.count - 1{
            allPayments[i].removeAll()
        }

        
    }

}
