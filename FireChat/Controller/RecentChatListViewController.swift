//
//  RecentChatListViewController.swift
//  FireChat
//
//  Created by Khairul Bashar on 28/6/19.
//  Copyright © 2019 Jahid Bashar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class RecentChatListViewController: UITableViewController {
    
    var messageList = [Message] ()
    var messageDict = [String: Message] ()
    
    var noRecentChatLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib.init(nibName:"ContactListViewController", bundle: nil), forCellReuseIdentifier: "customUserCell")
        configureTableView()
        retriveMessage()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: contactsButtonTitle, style: .plain, target: self, action: #selector(navigationBarRightButtonTapped))
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customUserCell", for: indexPath) as! ContactListViewController
        
        var toUserEmail: String?
        var toUserName: String?
        if(messageList[indexPath.row].fromUser == Auth.auth().currentUser?.email) {
            toUserEmail = messageList[indexPath.row].toUser
        } else {
            toUserEmail = messageList[indexPath.row].fromUser
        }
        let userDB = Database.database().reference().child("users")
        userDB.observe(.childAdded) {
            (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            if(toUserEmail == snapshotValue["email"]) {
                toUserName = snapshotValue["name"]
            }
            cell.avatarNameLabel.text = toUserName
        }
        
        cell.avatarEmailLabel.text = messageList[indexPath.row].textMessage
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ContactListViewController

        let userName = cell.avatarNameLabel.text
        
        let userDB = Database.database().reference().child("users")
        userDB.observe(.childAdded) {
            (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let name = snapshotValue["name"]
            let email = snapshotValue["email"]
            if(userName == name) {
                DispatchQueue.main.async {[weak self] in
                    let user = User(user: name!, email: email!)
                    let chatLogViewController = ChatLogViewController(nibName: "ChatLogViewController", bundle: nil)
                    chatLogViewController.userInfo = user
                    self?.navigationController?.pushViewController(chatLogViewController, animated: true)
                }
                
            }
        }
        
    }
    
    func retriveMessage() {
        
        //messageList.removeAll()
        let messageDB = Database.database().reference().child("Message")
        messageDB.observe(.childAdded) { (snapshot) in
            
            //print(snapshot)
            let snapshotValue = snapshot.value as! Dictionary<String, AnyObject>
            
            let from: String = snapshotValue["fromUser"] as! String
            let to: String = snapshotValue["toUser"] as! String
            let currentUser: String = (Auth.auth().currentUser?.email)!
            
            if(from == currentUser || to == currentUser) {
                let message = Message()
                message.fromUser = from
                message.toUser = to
                message.textMessage = (snapshotValue["messageBody"] as! String)
                let timeValue: Int = (snapshotValue["timestamp"] as! Int)
                message.timestamp = NSNumber(value: timeValue)
                
                print("Inside condition")
                //self.messageList.append(message)
                if(from == currentUser) {
                    self.messageDict[to] = message
                } else {
                    self.messageDict[from] = message
                }
                
            }
            self.messageList = Array(self.messageDict.values)
            self.messageList.sort(by: { (message1, message2) -> Bool in
                if let time1 = message1.timestamp?.intValue, let time2 = message2.timestamp?.intValue {
                    return time1 > time2
                } else {
                    return false
                }
                
            })
            self.updateUI()
        }
        
    }
    
    @objc func navigationBarRightButtonTapped () {
        removeSubView()
        self.performSegue(withIdentifier: "goToContactList", sender: self)
    }
    
    func updateUI() {
        if(messageList.count == 0) {
            showNoRecentChatText(displayText: "No Recent Chat History!")
        } else {
            removeSubView()
            tableView.reloadData()
        }
    }
    
    func showNoRecentChatText(displayText: String) {
        noRecentChatLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width - 20, height: view.frame.size.height/2))
        tableView.addSubview(noRecentChatLabel)
        noRecentChatLabel.center = tableView.center
        noRecentChatLabel.textColor = UIColor .black
        noRecentChatLabel.font = UIFont.systemFont(ofSize: 14.0)
        noRecentChatLabel.textAlignment = .center
        noRecentChatLabel.lineBreakMode = .byWordWrapping
        noRecentChatLabel.numberOfLines = 0
        noRecentChatLabel.text = displayText
    }
    
    func removeSubView() {
        for view in tableView.subviews {
            view.removeFromSuperview()
        }
    }
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
    }


}
