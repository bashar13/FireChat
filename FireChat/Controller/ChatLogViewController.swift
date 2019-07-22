//
//  ChatLogViewController.swift
//  FireChat
//
//  Created by Khairul Bashar on 2019-07-20.
//  Copyright © 2019 Jahid Bashar. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class ChatLogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var userInfo: User?
    var messageList = [Message]()
    
    @IBOutlet weak var textFieldBottomMargin: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = userInfo?.userName
        tableView.dataSource = self
        tableView.delegate = self
        
        //print(userInfo?.userEmail as Any)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configureTableView()
        
        tableView.register(UINib.init(nibName:"ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "customChatCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: logoutButtonTitle, style: .plain, target: self, action: #selector(navigationBarRightButtonTapped))
        retriveMessage()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(messageList.count)
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customChatCell", for: indexPath) as! ChatTableViewCell
        
        cell.messageLabel.text = messageList[indexPath.row].textMessage
        
        
        if(messageList[indexPath.row].fromUser == Auth.auth().currentUser?.email) {
            cell.messageLabel.textAlignment = .right
            
            cell.messageLabel.textColor = .black
        } else {
            cell.messageLabel.textAlignment = .left
            
            cell.messageLabel.textColor = .blue
        }
        
        return cell
    }

    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        storeMessages()
        messageTextField.text = ""
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//        UIView.animate(withDuration: 0.5) {
//            self.textFieldBottomMargin.constant = 350
//            print(self.textFieldBottomMargin.constant)
//            self.view.layoutIfNeeded()
//        }
//    }
//
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        UIView.animate(withDuration: 0.5) {
//            self.textFieldBottomMargin.constant = 0
//            print(self.textFieldBottomMargin.constant)
//            self.view.layoutIfNeeded()
//        }
//    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            print(keyboardHeight)
            UIView.animate(withDuration: 0.5) {
                self.textFieldBottomMargin.constant = keyboardHeight
                print(self.textFieldBottomMargin.constant)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.5) {
            self.textFieldBottomMargin.constant = 0
            print(self.textFieldBottomMargin.constant)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func didViewTapped() {
        messageTextField.endEditing(true)
    }
    
    func storeMessages() {
        
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let user: String = String((Auth.auth().currentUser?.email)!)
        let recUser: String = userInfo!.userEmail
        let messageDB = Database.database().reference().child("Message")
        
        let messageDict = ["fromUser": user, "toUser": recUser, "messageBody": String(messageTextField.text!), "timestamp": timestamp] as [String : AnyObject]
        
        messageDB.childByAutoId().setValue(messageDict) {
            (error, reference) in
            if (error != nil) {
                print(error!)
            } else {
                
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

            if((from == self.userInfo?.userEmail && to == Auth.auth().currentUser?.email) || (from == Auth.auth().currentUser?.email && to == self.userInfo?.userEmail)) {
                let message = Message()
                message.fromUser = from
                message.toUser = to
                message.textMessage = (snapshotValue["messageBody"] as! String)
                let timeValue: Int = (snapshotValue["timestamp"] as! Int)
                message.timestamp = NSNumber(value: timeValue)

                self.messageList.append(message)
                print(self.messageList.count)
                DispatchQueue.main.async{[weak self] in
                    self?.tableView.reloadData()
                }
            }
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didViewTapped))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
        tableView.separatorStyle = .none
    }
}
