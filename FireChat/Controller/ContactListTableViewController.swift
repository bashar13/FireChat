//
//  ContactListTableViewController.swift
//  FireChat
//
//  Created by Khairul Bashar on 28/6/19.
//  Copyright © 2019 Jahid Bashar. All rights reserved.
//

import UIKit
import Firebase

class ContactListTableViewController: UITableViewController {

    var userList = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib.init(nibName:"ContactListViewController", bundle: nil), forCellReuseIdentifier: "customUserCell")

        retriveUsers()
        configureTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: logoutButtonTitle, style: .plain, target: self, action: #selector(navigationBarRightButtonTapped))
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customUserCell", for: indexPath) as! ContactListViewController
        
        cell.avatarNameLabel.text = userList[indexPath.row].userName
        cell.avatarEmailLabel.text = userList[indexPath.row].userEmail
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatLogViewController = ChatLogViewController(nibName: "ChatLogViewController", bundle: nil)
        chatLogViewController.userInfo = userList[indexPath.row]
        navigationController?.pushViewController(chatLogViewController, animated: true)
        
    }
    
    func retriveUsers() {
        
        let userDB = Database.database().reference().child("users")
        userDB.observe(.childAdded) {
            (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let name = snapshotValue["name"]
            let email = snapshotValue["email"]
            
            
            if !(Auth.auth().currentUser?.email == email) {
                let user = User(user: name!, email: email!)
                self.userList.append(user)
            }
            
            DispatchQueue.main.async{[weak self] in
                self?.tableView.reloadData()
            }
            
            print("retriving \(name!)")
            print(email!)
        }
        
    }
    
    @objc func navigationBarRightButtonTapped () {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print(EXCEPTION_STATE)
        }
        
        guard (navigationController?.popToRootViewController(animated: true)) != nil
            else {
                return
        }
    }
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
    }

}
