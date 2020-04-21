//
//  TestAuthVC.swift
//  My Wallet
//
//  Created by Safwan Saigh on 18/04/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import FirebaseAuth

class TestAuthVC: UIViewController {

    
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var lbl_result: UILabel!
    
   
    let actionCodeSettings = ActionCodeSettings()
    override func viewDidLoad() {
        super.viewDidLoad()
        var em = UserDefaults.standard.string(forKey: "Email")
        if em != nil{
            email.text = em
        }
             try! Auth.auth().signOut()
        print(Auth.auth().currentUser?.email!)
    }
    
    
    @IBAction func signButttonPressed(_ sender: Any) {
        
        //Validate first
        //Register the user if there are no violoations
        register(auth: Auth.auth())
                   
    }
    
         
         func handleError(error: Error) {
             let errorAuthStatus = AuthErrorCode.init(rawValue: error._code)!
             switch errorAuthStatus {
             case .wrongPassword:
                 print("wrongPassword")
             case .invalidEmail:
                 print("invalidEmail")
             case .operationNotAllowed:
                 print("operationNotAllowed")
             case .userDisabled:
                 print("userDisabled")
             case .userNotFound:
                 print("userNotFound")
                 self.register(auth: Auth.auth())
             case .tooManyRequests:
                 print("tooManyRequests, oooops")
             default: fatalError("error not supported here")
             }
         }
                  
         func register(auth: Auth) {
             auth.createUser(withEmail: email.text!, password: password.text!) { (result, error) in
                 guard error == nil else {
                     return self.handleError(error: error!)
                 }
                 
                 guard let user = result?.user else {
                     fatalError("Do not know why this would happen")
                 }
                 
                user.reload { (error) in
                    switch user.isEmailVerified {
                        case true:
                            print("users email is verified")
                        case false:
                            user.sendEmailVerification { (error) in
                                guard let error = error else {
                                    return print("user email verification sent")
                                }
                                self.handleError(error: error)
                            }
                            self.lbl_result.text = "Verify your email"
                            UserDefaults.standard.set(self.email.text, forKey: "Email")
                            self.email.text = ""
                            self.password.text = ""
                    }
                }
                 print("registered user: \(user.email)")
             }
             
         }
        
     }


    
