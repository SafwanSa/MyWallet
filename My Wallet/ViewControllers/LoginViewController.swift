//
//  LoginViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 19/09/2019.
//  Copyright © 2019 Safwan Saigh. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {


    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var lbl_error: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        closeKeyboard()
       loginView.layer.shadowOpacity = 0.6
       loginView.layer.shadowRadius = 5
       loginView.layer.shadowOffset = .zero
       loginView.layer.masksToBounds = false
    }
    
    let em = "s@s.com"
    let ps = "@s1111111"
    
    
    func validation()->String?{
        
        //Check if there any textFields empty
        if txt_email.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""||txt_password.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""{
            return "يجب تعبئة جميع الحقول ..! "
        }
        return nil
    }
    
    func showError(_ message:String){
        lbl_error.text = message
        lbl_error.alpha = 1
    }
    
    
    @IBAction func btn_login(_ sender: Any) {
        //Adjusting the error label
        lbl_error.alpha = 0
        //Validate the textFields
        let error = validation()
        SVProgressHUD.show()
        if error != nil{
            //There is an error
            showError(error!)
            SVProgressHUD.dismiss()
        }else{
            //Login the user.
//            let email = txt_email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//            let password = txt_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: em, password: ps) { (result, err) in
                if err != nil{
                    //Couldn't sign in
                    self.showError("البريد الإلكتروني أو كلمة السر غير صحيحة ... ! ")
                    SVProgressHUD.dismiss()
                }else{
                    SVProgressHUD.dismiss()
                    //Treansition to the home screen.
                    self.performSegue(withIdentifier: "goToHomeVC", sender: self)
                }
            }
        }
    }
    @IBAction func btnBackPressed(_ sender: Any) {
        //Going back to base screen
//        circular.value = circular.value - 5
//        dismiss(animated: true, completion: nil)
    }
    
    
    func closeKeyboard(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
}
