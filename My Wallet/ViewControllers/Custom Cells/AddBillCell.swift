//
//  AddBillTableViewCell.swift
//  My Wallet
//
//  Created by Safwan Saigh on 25/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import SVProgressHUD
class AddBillCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var txt_title: UITextField!
    @IBOutlet weak var txt_cost: UITextField!
    @IBOutlet weak var txt_date: UITextField!
    
    @IBOutlet weak var btn_add: RoundButton!
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
    
    var delegate: UITableViewController?
    
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
    
    func validation()->Bool{
        let numbers:[Character] = ["1","2","3","4","5","6","7","8","9","0"]
        if txt_date.text == "" || txt_title.text == "" || txt_cost.text == ""{
            showError( "املأ الحقول الفارغة..")
            return false
        }
        for char in txt_cost.text!{
            if(!numbers.contains(char)){
                showError( "أدخل التكلفة بشكل صحيح...")
                return false
            }
        }
        if(Int(txt_cost.text!)! <= 0){
            showError( "يجب أن تكون التكلفة أكبر من ٠...")
            return false
        }
        return true
    }
    
    func showProgress(){
           btn_add.isEnabled = false
           btn_add.alpha = 0.7
           SVProgressHUD.show()
       }
       
       func stopProgress(){
           btn_add.isEnabled = true
           btn_add.alpha = 1
           SVProgressHUD.dismiss()
       }
       
        func showError(_ message:String){
            stopProgress()
            let msg = message + " ...!"
            let alert = UIAlertController(title: "حدث خطأ", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: .default, handler: nil))
            delegate?.present(alert, animated: true, completion: nil)
          }
    
    @IBAction func btnAddPressed(_ sender: Any) {
        showProgress()
        //Initilizing default
        var title = "No Title"
        var cost = Float(0.0)
        var day = ""
        if(validation()){
            //No errors
            title = txt_title.text!
            cost = Float(txt_cost.text!)!
            day = txt_date.text!
            //Create a bill obj
            let bill = Bill(title, cost, day, "auto",lastUpd: "")
            //Add the bill in the data base (as unpaid payment)
            bill.addPayemnt()
            //Readjust the fields of adding payments
            txt_cost.text = ""
            txt_title.text = ""
            txt_date.text = ""
            stopProgress()
          }
          
      }
    
}
extension UIView {
var parentViewController: UIViewController? {
    var parentResponder: UIResponder? = self
    while parentResponder != nil {
        parentResponder = parentResponder!.next
        if parentResponder is UIViewController {
            return parentResponder as! UIViewController?
        }
    }
    return nil
}
}
