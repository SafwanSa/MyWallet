//
//  AddBillTableViewCell.swift
//  My Wallet
//
//  Created by Safwan Saigh on 25/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class AddBillCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var txt_title: UITextField!
    @IBOutlet weak var txt_cost: UITextField!
    @IBOutlet weak var txt_date: UITextField!
    
    private var date = UIPickerView()
    private var days = [String]()
    //Setting the picker view functions
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return days.count
       }
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           txt_date.text = days[row]
       }
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return days[row]
       }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        date.dataSource = self
        date.delegate = self
        txt_date.inputView = date
        self.days = Calendar.genetrateDays()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func validation()->String{
        let numbers:[Character] = ["1","2","3","4","5","6","7","8","9","0"]
        if txt_date.text == ""{
            return "املأ الحقول الفارغة.."
        }
        if txt_title.text == ""{
            return "املأ الحقول الفارغة.."
        }
        if txt_cost.text == ""{
            return "املأ الحقول الفارغة.."
        }
        for char in txt_cost.text!{
            if(!numbers.contains(char)){
                return "أدخل التكلفة بشكل صحيح..."
            }
        }
        if(Int(txt_cost.text!)! <= 0){
            return "يجب أن تكون التكلفة أكبر من ٠..."
        }
        return ""
    }
    
    @IBAction func btnAddPressed(_ sender: Any) {
          //Initilizing default
          var title = "No Title"
          var cost = Float(0.0)
          var day = ""
          if(validation() != ""){
              print(validation())
              //TODO show this in the error label
          }else{
              //No errors
              title = txt_title.text!
              cost = Float(txt_cost.text!)!
              day = txt_date.text!
              //Create a bill obj
              let bill = Bill(title, cost, day, "auto")
              //Add the bill in the data base (as unpaid payment)
              bill.addPayemnt()
              //Readjust the fields of adding payments
              txt_cost.text = ""
              txt_title.text = ""
              txt_date.text = ""
              //TODO use phdprogress
          }
          
      }
    
}
