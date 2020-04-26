//
//  SettingsTableViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 24/04/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SuperNavigationController.setTitle(title: "الإعدادات", nv: self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 3
        }else{
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "account", for: indexPath)
                return cell
            }
            if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "financeInfo", for: indexPath)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "billMng", for: indexPath)
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "logout", for: indexPath)
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if indexPath.row == 0{
                self.performSegue(withIdentifier: "goToAccount", sender: self)
            }else if indexPath.row == 1{
                self.performSegue(withIdentifier: "goToFinance", sender: self)
            }else{
                self.performSegue(withIdentifier: "goToBillMng", sender: self)
            }
        }else if indexPath.section == 1{
            //Logout
            self.signOut()
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
    
    func transateToStart(){
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let centerVC = mainStoryBoard.instantiateViewController(withIdentifier: "startViewController") as! UINavigationController
        appDel.window!.rootViewController = centerVC
        appDel.window!.makeKeyAndVisible()
    }
    

}
