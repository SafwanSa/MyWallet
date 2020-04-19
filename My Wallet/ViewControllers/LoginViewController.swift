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
    let db = Firestore.firestore()
    var email: String = ""
    var msg: String = ""
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeKeyboard()
        print(msg)
        txt_email.text = email
        showPrompt(msg)
    }
    
    let em = "s@s.com"
    let ps = "@s1111111"
    
    
    
    func showError(_ message:String){
        lbl_error.textColor = .red
        lbl_error.text = message
        lbl_error.alpha = 1
    }
    
    func showPrompt(_ message:String){
        lbl_error.textColor = .green
        lbl_error.text = message
        lbl_error.alpha = 1
    }
    
    
    
    
    @IBAction func btn_login(_ sender: Any) {
        lbl_error.alpha = 0
        //Taking inputs
        let email = txt_email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = txt_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        SVProgressHUD.show()
        let user = Auth.auth().currentUser
        if user != nil{
            user?.reload(completion: { (error) in
                if user!.isEmailVerified{
                    self.loging(email: email, password: password, name: self.name)
                }else{
                    self.showPrompt("يجب عليك تفعيل حسابك عبر الرسالة المرسلة إلى البريد الألكتروني")
                }
            })
        }else{
            //Existent account
            self.loging(email: email, password: password, name: self.name)
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
                SVProgressHUD.dismiss()
            }else{
                self.isNewAccount(complete: { (newAcc) in
                    if newAcc{
                       self.setupUser(name: self.name, id: (result?.user.uid)!, email: (result?.user.email!)!)
                    }
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "goToHomeVC", sender: self)
                }, id: (result?.user.uid)!)
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
        let user = UserInfo(first_name: self.name, last_name: "", email: email, id: id)
        let budget = user.createBudget(amount: 0.0, savings: 0.0)
        db.collection("user").document(user.id).setData(user.setUserInfoData())
        budget.setBudgetData()
        SVProgressHUD.dismiss()
        //Transition to the home screen
        self.performSegue(withIdentifier: "goToHomeVC", sender: self)
    }
    
    
    
    func handleError(error: Error) {
        let errorAuthStatus = AuthErrorCode.init(rawValue: error._code)!
        switch errorAuthStatus {
        case .wrongPassword:
            showError("Wrong password")
        case .invalidEmail:
            showError("invalidEmail")
        case .operationNotAllowed:
            showError("operationNotAllowed")
        case .userDisabled:
            showError("userDisabled")
        case .tooManyRequests:
            showError("tooManyRequests, oooops")
        case .missingEmail:
            showError("Missigng email")
        case .userNotFound:
            showError("User not found")
            performSegue(withIdentifier: "goToSignUp", sender: self)
        case .missingOrInvalidNonce:
            showError("Missing")
        default: fatalError("error not supported here")
        }
    }
    
    func closeKeyboard(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
}
