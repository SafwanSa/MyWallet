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
        // Do any additional setup after loading the view.
        if Auth.auth().currentUser != nil {
            // User is signed in.
            if Calendar.getFormatedDate(by: "day", date: Calendar.getFullDate()) == "01"{
                let dataSource = DataSource()
                dataSource.addPreviuosInfo()
                performSegue(withIdentifier: "goToNewMonth", sender: self)
            }else{
                performSegue(withIdentifier: "logedIn", sender: self)
            }
           } else {
               // No user is signed in.
               // ...
               print("is not in")
           }
    }

    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
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

