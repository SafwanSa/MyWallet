//
//  ViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 19/09/2019.
//  Copyright © 2019 Safwan Saigh. All rights reserved.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try! Auth.auth().signOut()
        checkAccount()
    }
    
    
    func run(){
        if Calendar.getFormatedDate(by: "day", date: Calendar.getFullDate()) == "01"{
            DataBank.shared.addPreviuosInfo()
            performSegue(withIdentifier: "goToNewMonth", sender: self)
        }else{
            performSegue(withIdentifier: "logedIn", sender: self)
        }
    }
    
    func deleteUser(){
        Auth.auth().currentUser!.delete { (error) in
            print("User deleted...")
        }
        try! Auth.auth().signOut()
    }
    
    
    func checkAccount(){
        let user = Auth.auth().currentUser
        if user != nil{
            //There is a user signed in
                if user!.isEmailVerified{
                    print("Verified user")
                    self.run()
                }else{
                    print("Not verified user")
                    self.deleteUser()
                }
        }else{
            print("No user signing in....")
        }
    }
    
    

}

//This will allow us to close the keybaord when touching the screen
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}


