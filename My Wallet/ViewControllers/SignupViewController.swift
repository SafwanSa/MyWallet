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
    @IBOutlet weak var txt_password: HSUnderLineTextField!
    @IBOutlet weak var txt_email: HSUnderLineTextField!
    @IBOutlet weak var txt_name: HSUnderLineTextField!
    @IBOutlet weak var btn_login: RoundButton!
    
    let db = Firestore.firestore()
    var email: String = ""
    var msg: String = ""
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeKeyboard()
//        try! Auth.auth().signOut()
        if self.msg != ""{
            //Coming from the log in VC
            self.showPrompt(msg)
            self.txt_email.text = email
        }else{
            //Coming from the base screen
            checkAccount()
        }

    }
    
    
    func checkAccount(){
        let user = Auth.auth().currentUser
        if user != nil{
            //There is a user signed in
            user!.reload { (error) in
                if user!.isEmailVerified{
                    self.showPrompt("تم تفعيل الحساب.. يمكنك الدخول الآن")
                }else{
                    self.deleteUser()
                }
            }
        }else{
            self.showError("No user")
        }
    }
    
    
    func deleteUser(){
        try! Auth.auth().signOut()
        Auth.auth().currentUser!.delete { (error) in
            self.showError("User deleted...")
        }
    }
    
    func showProgress(){
        btn_login.isEnabled = false
        btn_login.alpha = 0.7
        SVProgressHUD.show()
    }
    
    func stopProgress(){
        btn_login.isEnabled = true
        btn_login.alpha = 1
        SVProgressHUD.dismiss()
    }
    
    
    func showError(_ message:String){
        stopProgress()
        lbl_error.textColor = .red
        lbl_error.text = message + " ...!"
        lbl_error.alpha = 1
    }
    
    func showPrompt(_ message:String){
        stopProgress()
        lbl_error.textColor = .systemGreen
        lbl_error.text = message
        lbl_error.alpha = 1
    }
    
    func register(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if err != nil{
                self.handleError(error: err!)
            }else{
                //There is no error in the fields
                result?.user.reload(completion: { (error) in
                    //Send email verificaition
                    result?.user.sendEmailVerification(completion: { (error) in
                        if error != nil{
                            self.handleError(error: error!)
                        }
                        //Email sent
                        self.stopProgress()
                        print("user email verification sent")
                        self.txt_password.text = ""
                        self.showPrompt("تم إرسال رسالة تفعيل الحساب على البريد الإلكتروني")
                        print(Auth.auth().currentUser!.email)
                        self.performSegue(withIdentifier: "goToLogin", sender: self)
                    })
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LoginViewController{
            let dest = segue.destination as! LoginViewController
            dest.email = Auth.auth().currentUser!.email!
            dest.msg = "تم إرسال رسالة تفعيل الحساب على البريد الإلكتروني"
            dest.name = txt_name.text!
        }
    }
    
    
    @IBAction func btn_signup(_ sender: Any) {
        lbl_error.alpha = 0
        //Taking the inputs
        let name = self.txt_name.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = self.txt_email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = self.txt_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //Show loading
        showProgress()
        if validation(email: email, password: password, name: name){
            register(email: email, password: password)
        }
    }
    
    func validation(email: String, password: String, name: String)->Bool{
        var valid = true
        if email.count == 0 || password.count == 0 || name.count == 0{
            showError("بعض الحقول فارغة")
            valid = false
        }else{
            valid = validateName(name: name)
            if password.count < 8{
                showError("كلمة السر أقل من ٨ خانات")
                valid = false
            }
        }
        return valid
    }
    
    
    func validateName(name: String)->Bool{
        if name.count < 2 {
            showError("الاسم قصير ...")
            return false
        }else{
            if !isValidLetters(name: name) {
                showError("يجب أن يتكون الاسم من حروف فقط")
                return false
            }
            if name.count > 20{
                showError("يجب أن يكون الاسم أقصر من ٢٥ حرفاً")
                return false
            }
        }
        return true
    }
    
    
    
    func isValidLetters(name :String) -> Bool {
        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$")
        return predicateTest.evaluate(with: name)
    }
    
    func handleError(error: Error) {
        let errorAuthStatus = AuthErrorCode.init(rawValue: error._code)!
        switch errorAuthStatus {
        case .invalidEmail:
            showError("أدخل البريد الاإلكتروني بشكل صحيح")
        case .operationNotAllowed:
            showError("operationNotAllowed")
        case .userDisabled:
            showError("userDisabled")
        case .tooManyRequests:
            showError("تجاوزت عدد المحاولات، حاول لاحقاً")
        case .emailAlreadyInUse:
            showError("البريد الإلكتروني مستخدم")
        case .missingEmail:
            showError("أدخل البريد الإلكتروني")
        case .weakPassword:
            showError("كلمة المرور ضعيفة")
        default: showError("حدث خطأ، حاول مرة أخرة")
        }
    }
    
    
    
    
    
    
    func closeKeyboard(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
}


