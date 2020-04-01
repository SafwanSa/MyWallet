//
//  ProTableViewController.swift
//  My Wallet
//
//  Created by Safwan Saigh on 25/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SuperNavigationController.setTitle(title: "الحساب", nv: self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
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
            let cell = Bundle.main.loadNibNamed("AccountCell", owner: self, options: nil)?.first as! AccountCell
            return cell
        }else if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "financeInfo", for: indexPath)
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "billMng", for: indexPath)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "logout", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1){
            self.performSegue(withIdentifier: "goToFinance", sender: self)
        }else if(indexPath.section == 2){
            self.performSegue(withIdentifier: "goToBillMng", sender: self)
        }else if indexPath.section == 3{
            //Logout
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
            //Sucssefuly loged out, now segue to base view
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let centerVC = mainStoryBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            appDel.window!.rootViewController = centerVC
            appDel.window!.makeKeyAndVisible()
        }
    }

   
  

    

}
