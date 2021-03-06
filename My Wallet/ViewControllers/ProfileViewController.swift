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

    
    var income: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SuperNavigationController.setTitle(title: "الحساب", nv: self)
        self.tableView.register(UINib(nibName: "AccountCell", bundle: nil), forCellReuseIdentifier: "AccountCell")
        setupNavigationRightButton()
    }
    
    func setupNavigationRightButton(){
        let saveButton = UIBarButtonItem(title: "حفظ", style: .plain, target: self, action: #selector(save))
        navigationItem.rightBarButtonItems = [saveButton]
    }

    func validatedIncome()->Bool{
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! AccountCell
        let numbers:[Character] = ["1","2","3","4","5","6","7","8","9","0","."]
        if cell.txt_income.text == ""{
            showPromptAndError( "ادخل الدخل..")
            return false
        }
        for char in cell.txt_income.text!{
            if(!numbers.contains(char)){
                print(char)
                showPromptAndError( "أدخل الدخل بشكل صحيح...")
                return false
            }
        }
        if cell.txt_income.text?.last == "." || cell.txt_income.text?.first == "."{
            showPromptAndError( "أدخل الدخل بشكل صحيح...")
            return false
        }
        if(Float(cell.txt_income.text!)! <= 0){
            showPromptAndError( "يجب أن يكون الدخل أكبر من ٠...")
            return false
        }
        self.income = Float(cell.txt_income.text!)!
        return true
    }
    
    func round(_ num: Float)->Float{
        return (num*100).rounded()/100
    }
    
    @objc func save(){
        showProgress()
        if validatedIncome(){
            DataBank.shared.updateUserData(data: ["Income": round(self.income)])
            stopProgress()
            //Dismiss
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        } else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "changePass", for: indexPath)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "deleteAcc", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            //Chnage password
            self.performSegue(withIdentifier: "goToChangePass", sender: self)
        }else if indexPath.section == 2{
            //Delete Account
            self.deleteAccount()
        }
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
        alert.addAction(UIAlertAction(title: "إلغاء", style: .default, handler: nil))
        alert.addTextField(configurationHandler: { textField in
//            textField.placeholder = "Input your name here..."
            textField.textAlignment = .right
            textField.textContentType = .password
            textField.isSecureTextEntry = true
        })
        
        alert.addAction(UIAlertAction(title: "أحذف", style: .cancel, handler: { action in
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
