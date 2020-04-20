//
//  ChangePasswordViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 20/04/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD
class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var txt_currentPass: UITextField!
    @IBOutlet weak var txt_newPass: UITextField!
    
    @IBOutlet weak var btn_change: UIButton!
    @IBOutlet weak var lbl_msg: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    func reAuthinticate(complete: @escaping (Bool)->Void){
        let user = Auth.auth().currentUser
        let credential: AuthCredential
        credential = FirebaseAuth.EmailAuthProvider.credential(withEmail: (user?.email)!, password: txt_currentPass.text!)
        // Prompt the user to re-provide their sign-in credentials
        user?.reauthenticate(with: credential, completion: { (authDataResult, error) in
            if error != nil{
                self.handleError(error: error!)
                complete(false)
            }else{
                self.showPrompt("User re-authinticated")
                print(authDataResult!)
                complete(true)
            }
            
        })
    }
    
    func updatePassword(){
        Auth.auth().currentUser?.updatePassword(to: txt_newPass.text!, completion: { (error) in
            if error != nil{
                self.handleError(error: error!)
            }else{
                self.showPrompt("Password changed")
            }
        })
    }
    
    @IBAction func chnagePressed(_ sender: Any) {
        if validation(){
            reAuthinticate { (result) in
                if result{
                    self.updatePassword()
                }else{
                    print("Cannot chnage password")
                }
            }
        }
    }
    
    func validation()->Bool{
        if txt_currentPass.text?.count == 0 || txt_newPass.text?.count == 0{
            showError("بعض الحقول فارغة")
            return false
        }
        return true
    }
    
    func showProgress(){
         btn_change.isEnabled = false
         btn_change.alpha = 0.7
         SVProgressHUD.show()
     }
     
     func stopProgress(){
         btn_change.isEnabled = true
         btn_change.alpha = 1
         SVProgressHUD.dismiss()
     }
     
      func showError(_ message:String){
         stopProgress()
         lbl_msg.textColor = .red
         lbl_msg.text = message + " ...!"
         lbl_msg.alpha = 1
        }
     
     func showPrompt(_ message:String){
         stopProgress()
         lbl_msg.textColor = .systemGreen
         lbl_msg.text = message
         lbl_msg.alpha = 1
     }
    
    func handleError(error: Error) {
        let errorAuthStatus = AuthErrorCode.init(rawValue: error._code)!
        switch errorAuthStatus {
        case .wrongPassword:
            showError("كلمة المرور غير صحيحة")
        case .operationNotAllowed:
            showError("operationNotAllowed")
        case .userDisabled:
            showError("userDisabled")
        case .tooManyRequests:
            showError("تجاوزت عدد المحاولات، حاول لاحقاً")
        case .weakPassword:
            showError("يجب أن تكون كلمة المرور مكونة من ٦ خانات على الأقل")
        default: showError("حدث خطأ، حاول مرة أخرة")
        }
    }
    

}
