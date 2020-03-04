//
//  SignupViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 19/09/2019.
//  Copyright © 2019 Safwan Saigh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SVProgressHUD
class SignupViewController: UIViewController {

    @IBOutlet weak var lbl_error: UILabel!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_last_name: UITextField!
    @IBOutlet weak var txt_first_name: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        closeKeyboard()
        // Do any additional setup after loading the view.
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func validation()->String?{
        //Check if there any textFields empty
        if txt_first_name.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""||txt_last_name.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""||txt_email.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""||txt_password.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""{
            return "يجب تعبئة جميع الحقول ..! "
        }
        //Check if the password is secure
        let cleanPassword = txt_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(cleanPassword) == false{
            return "يجب أن تكون كلمة السر مكونة من ٨ خانات على الأقل، وتضمن رقم و رمز (!@#$٪^&..) ... ! "
        }
        //Check if the email is valid
        let cleanEmail = txt_email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isValidEmail(testStr: cleanEmail) == false{
            return "أدخل البريد الإلكتروني بشكل صحيح ... !"
        }
        return nil
    }
    
    func showError(_ message:String){
        lbl_error.text = message
        lbl_error.alpha = 1
    }
    
    @IBAction func btn_signup(_ sender: Any) {
        //Adjusting the error label
        lbl_error.alpha = 0
        //Validate the textfields
        let error = validation()
        //Show loading
        SVProgressHUD.show()
        if error != nil{
          showError(error!)
            SVProgressHUD.dismiss()
        }else{
            //Create the user.
            let db = Firestore.firestore()
            let first_name = self.txt_first_name.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let last_name = self.txt_last_name.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = self.txt_email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = self.txt_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil{
                    //There is an error in creating the user.
                    self.showError("البريد الإلكتروني مستخدم ... !")
                    SVProgressHUD.dismiss()
                }else{
                    //The user has been created successfuly, now store his data in firestore.
                    let user = UserInfo(first_name: first_name, last_name: last_name, email: email, id: result!.user.uid, income: 0, budget: 0, savings: 0)
                    db.collection("user").document(user.id).setData(user.setToDic())
                    SVProgressHUD.dismiss()
                    //Transition to the home screen
                    self.performSegue(withIdentifier: "goToHomeVC", sender: self)
                }
            }
        }
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
    //Going back to base screen
        dismiss(animated: true, completion: nil)
    }
    
    func closeKeyboard(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
}
