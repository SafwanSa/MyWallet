//
//  LoginViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 19/09/2019.
//  Copyright © 2019 Safwan Saigh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SVProgressHUD

class LoginViewController: UIViewController {


    
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var lbl_error: UILabel!
    @IBOutlet weak var btn_sign: RoundButton!
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var btn_resend: RoundButton!
    @IBOutlet weak var btn_forgotPassword: UIButton!
    
    let db = Firestore.firestore()
    var email: String = ""
    var msg: String = ""
    var name: String = ""
    var allowBack = true
    var resendCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeKeyboard()
        txt_email.text = email
        showPrompt(msg)
        
        if !allowBack{
            btn_back.isHidden = true
            btn_forgotPassword.isHidden = true
            btn_resend.isHidden = false
        }else{
            btn_back.isHidden = false
            btn_forgotPassword.isHidden = false
            btn_resend.isHidden = true
        }
    }
    
    let em = "s@s.com"
    let ps = "@s1111111"
    
    
    func showProgress(){
        btn_sign.isEnabled = false
        btn_sign.alpha = 0.7
        SVProgressHUD.show()
    }
    
    func stopProgress(){
        btn_sign.isEnabled = true
        btn_sign.alpha = 1
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
    
    
    func validation(email: String, password: String)->Bool{
        if email.count == 0 || password.count == 0{
            showError("بعض الحقول فارغة")
            return false
        }
        return true
    }
    
    @IBAction func btn_login(_ sender: Any) {
        lbl_error.alpha = 0
        //Taking inputs
        let email = txt_email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = txt_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        showProgress()
        if validation(email: email, password: password){
            let user = Auth.auth().currentUser
                if user != nil{
                    user?.reload(completion: { (error) in
                        if user!.isEmailVerified{
                            self.loging(email: email, password:password, name: self.name)
                        }else{
                            self.showPrompt("يجب عليك تفعيل حسابك عبر الرسالة المرسلة إلى البريد الألكتروني")
                        }
                    })
                }else{
                    //Existent account
                    self.loging(email: email, password: password, name: self.name)
                }
        }       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SignupViewController{
            let dest = segue.destination as! SignupViewController
            dest.email = txt_email.text!
            dest.msg = "أنشئ حسابك"
        }
    }

    
    
      func loging(email: String, password: String, name: String){
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if err != nil{
                //Couldn't sign in
                self.handleError(error: err!)
                self.stopProgress()
            }else{
                self.isNewAccount(complete: { (newAcc) in
                    if newAcc{
                        self.setupUser(name: self.name, id: (result?.user.uid)!, email: (result?.user.email!)!)
                    }else{
                        self.stopProgress()
                        self.performSegue(withIdentifier: "goToHomeVC", sender: self)
                    }
                }, id: (result?.user.uid)!)
            }
        }
    }
    
    
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        showProgress()
        if resendCounter > 2{
            showError("لقد تعديت عدد المحاولات في إرسال رسالة التفعيل")
            self.btn_resend.isHidden = true
        }else{
            let user = Auth.auth().currentUser
            if user != nil{
                user!.reload { (error) in
                    if user!.isEmailVerified{
                        self.showPrompt("تم تفعيل البريد الإلكتروني، يمكنك الدخول")
                    }else{
                        user!.sendEmailVerification { (error) in
                            if error != nil{
                                self.handleError(error: error!)
                            }else{
                                self.resendCounter += 1
                                self.showPrompt("تم إسال رسالة التفعيل مرة أخرة")
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    func isNewAccount(complete: @escaping (Bool)->Void, id: String){
        db.collection("user").document(id).getDocument { (documentSnapshot, error) in
            let userData = documentSnapshot?.data()
            if userData == nil{
                print("New User")
                complete(true)
            }else{
                print("Not a new user")
                complete(false)
            }
           
        }
    }
    
    
    func setupUser(name: String, id: String, email: String){
        //The user has been created successfuly, now store his data in firestore.
        let user = UserInfo(name: self.name, email: email, id: id)
        let budget = user.createBudget(amount: 0.0, savings: 0.0)
        db.collection("user").document(user.id).setData(user.setUserInfoData())
        budget.setBudgetData()
        stopProgress()
        //Transition to the home screen
        self.performSegue(withIdentifier: "goToHomeVC", sender: self)
    }
    
    
    
    func handleError(error: Error) {
        let errorAuthStatus = AuthErrorCode.init(rawValue: error._code)!
        switch errorAuthStatus {
        case .wrongPassword:
            showError("كلمة المرور غير صحيحة")
        case .invalidEmail:
            showError("أدخل البريد الاإلكتروني بشكل صحيح")
        case .operationNotAllowed:
            showError("operationNotAllowed")
        case .userDisabled:
            showError("userDisabled")
        case .tooManyRequests:
            showError("انتظر قليلاً، ثم حاول مرة أخرة")
        case .missingEmail:
            showError("أدخل البريد الإلكتروني")
        case .userNotFound:
            showError("الحساب غير موجود")
            performSegue(withIdentifier: "goToSignUp", sender: self)
        default: showError("حدث خطأ، حاول مرة أخرة")
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func closeKeyboard(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
}
