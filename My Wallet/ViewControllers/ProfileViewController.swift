//
//  ProTableViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 25/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD
class ProfileViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SuperNavigationController.setTitle(title: "الحساب", nv: self)
        self.tableView.register(UINib(nibName: "AccountCell", bundle: nil), forCellReuseIdentifier: "AccountCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1{
            return 2
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 120
        }else{
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "AccountCell") as! AccountCell
            return cell
        }else if(indexPath.section == 1){
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "financeInfo", for: indexPath)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "billMng", for: indexPath)
                return cell
            }
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "logout", for: indexPath)
            return cell
        } else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "changePass", for: indexPath)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "deleteAcc", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            if indexPath.row == 0{
                self.performSegue(withIdentifier: "goToFinance", sender: self)
            }else{
                self.performSegue(withIdentifier: "goToBillMng", sender: self)
            }
        }else if indexPath.section == 2{
            //Logout
            self.signOut()
        }else if indexPath.section == 3{
            //Chnage password
            self.performSegue(withIdentifier: "goToChangePass", sender: self)
        }else{
            //Delete Account
            self.deleteAccount()
        }
    }
    
    func signOut(){
        let alert = UIAlertController(title: "هل تريد تسجيل الخروج؟", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "نعم", style: .cancel, handler: { action in
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
                self.transateToStart()
        }))
        alert.addAction(UIAlertAction(title: "لا", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func deleteUser(){
        Auth.auth().currentUser!.delete { (error) in
            print("User deleted...")
        }
        try! Auth.auth().signOut()
        stopProgress()
        self.transateToStart()
    }
    
    func deleteAccount(){
        let alert = UIAlertController(title: "أدخل كلمة المرور", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your name here..."
        })
        
        alert.addAction(UIAlertAction(title: "أحذف الحساب", style: .default, handler: { action in
            if let pass = alert.textFields?.first?.text {
                if self.validation(pass: pass){
                    self.showProgress()
                    //re-authinticate the user
                    self.reAuthinticate(complete: { (result) in
                        if result{
                            //Delete
                            self.deleteUser()
                        }
                    }, password: pass)
                }
            }
        }))
        self.present(alert, animated: true)
    }
    
    func transateToStart(){
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let centerVC = mainStoryBoard.instantiateViewController(withIdentifier: "startViewController") as! UINavigationController
        appDel.window!.rootViewController = centerVC
        appDel.window!.makeKeyAndVisible()
    }
    
    func reAuthinticate(complete: @escaping (Bool)->Void, password: String){
       let user = Auth.auth().currentUser
       let credential: AuthCredential
       credential = FirebaseAuth.EmailAuthProvider.credential(withEmail: (user?.email)!, password: password)
       // Prompt the user to re-provide their sign-in credentials
       user?.reauthenticate(with: credential, completion: { (authDataResult, error) in
           if error != nil{
               self.handleError(error: error!)
               complete(false)
           }else{
               print(authDataResult!)
               complete(true)
           }
           
       })
   }
    
    func showProgress(){
        SVProgressHUD.show()
    }
    
    func stopProgress(){
        SVProgressHUD.dismiss()
    }
    
    func showPromptAndError(_ message:String){
        stopProgress()
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "حسناً", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func validation(pass: String)->Bool{
        if pass.count == 0{
            self.showPromptAndError("أدخل كلمة المرور")
            return false
        }
    return true
    }
  
    func handleError(error: Error) {
           let errorAuthStatus = AuthErrorCode.init(rawValue: error._code)!
           switch errorAuthStatus {
           case .wrongPassword:
               showPromptAndError("كلمة المرور غير صحيحة")
           case .operationNotAllowed:
               showPromptAndError("operationNotAllowed")
           case .userDisabled:
               showPromptAndError("userDisabled")
           case .tooManyRequests:
               showPromptAndError("تجاوزت عدد المحاولات، حاول لاحقاً")
           default: showPromptAndError("حدث خطأ، حاول مرة أخرة")
           }
       }

    

}
