//
//  ForgotPasswordViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 17/04/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var email: HSUnderLineTextField!
    @IBOutlet weak var btn_send: RoundButton!
    
    @IBOutlet weak var lbl_error: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeKeyboard()
    }
    
    func validation(email: String)->Bool{
        if email.count == 0{
            showError("بعض الحقول فارغة")
            return false
        }
        return true
    }
    
    func showProgress(){
        btn_send.isEnabled = false
        btn_send.alpha = 0.7
        SVProgressHUD.show()
    }
    
    func stopProgress(){
        btn_send.isEnabled = true
        btn_send.alpha = 1
        SVProgressHUD.dismiss()
    }
    
    func showError(_ message:String){
        stopProgress()
        lbl_error.textColor = .red
        lbl_error.text = message + " ...!"
        lbl_error.alpha = 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LoginViewController{
            let dest = segue.destination as! LoginViewController
            dest.email = email.text!
            dest.msg = "تفقد بريدك الإلكتروني لتغيير كلمة المرور"
        }
    }
    
    @IBAction func changePasswordRequestPressed(_ sender: Any) {
        showProgress()
        if validation(email: email.text!){
            Auth.auth().sendPasswordReset(withEmail: email.text!) { error in
                if error != nil{
                    self.handleError(error: error!)
                }else{
                    self.stopProgress()
                    self.performSegue(withIdentifier: "goToLogin", sender: self)
                }
            }
        }

        
    }
    
    func handleError(error: Error) {
        let errorAuthStatus = AuthErrorCode.init(rawValue: error._code)!
        switch errorAuthStatus {
        case .invalidRecipientEmail:
            showError("الحساب غير موجود")
        case .operationNotAllowed:
            showError("operationNotAllowed")
        case .userDisabled:
            showError("userDisabled")
        case .tooManyRequests:
            showError("tooManyRequests, oooops")
        case .missingEmail:
            showError("أدخل البريد الإلكتروني")
        case .userNotFound:
            showError("الحساب غير موجود")
        case .invalidEmail:
            showError("أدخل البريد الاإلكتروني بشكل صحيح")
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
