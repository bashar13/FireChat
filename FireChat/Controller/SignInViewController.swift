//
//  SignInViewController.swift
//  FireChat
//
//  Created by Khairul Bashar on 27/6/19.
//  Copyright © 2019 Jahid Bashar. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignInViewController: UIViewController {

    var signInType = SignInCategory.login
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //constants related to signIn Box
    @IBOutlet weak var topMargEmailTextField: NSLayoutConstraint!
    @IBOutlet weak var heightSignInContainerView: NSLayoutConstraint!
    @IBOutlet weak var singInBoxYMargin: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sign In"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: backButtonTitle, style: .plain, target: self, action: nil)
        
        setSignInContainerView()
    }
    
    private func setSignInContainerView() {
        
        switch signInType {
        case .login:
            signInButton.setTitle(buttonStringConstants.login.rawValue, for: .normal)
            heightSignInContainerView.constant = SignInContainerViewHeight.loginView.rawValue
            topMargEmailTextField.constant = EmailTextFieldTopMargin.loginView.rawValue
            nameTextField.isHidden = true
            break;
        case .register:
            signInButton.setTitle(buttonStringConstants.register.rawValue, for: .normal)
            heightSignInContainerView.constant = SignInContainerViewHeight.registerView.rawValue
            topMargEmailTextField.constant = EmailTextFieldTopMargin.registerView.rawValue
            nameTextField.isHidden = false
            break;
        }
    }

    @IBAction func signInButtonPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        if Connectivity.isConnectedToInternet {
            
            let name = nameTextField.text ?? "no name"
            switch signInType {
            case .login:
                Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    if( error != nil) {
                        print(error!)
                        let titleString: String = "Error to " + sender.title(for: .normal)!
                        AlertDialog.createSignInErrorAlert(title: titleString, controllerVC: self)
                    } else {
                        print("Succefull login")
                        
                        self.performSegue(withIdentifier: "goToRecentChatList", sender: self)
                    }
                    SVProgressHUD.dismiss()
                }
                break;
            case .register:
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    if(error != nil) {
                        print(error!)
                        let titleString: String = "Error to " + sender.title(for: .normal)!
                        
                        AlertDialog.createSignInErrorAlert(title: titleString, controllerVC: self)
                        
                    } else {
                        //success
                        print("registration success")
                        self.createUserInDB(userID: Auth.auth().currentUser?.uid, userName: name)
                        self.performSegue(withIdentifier: "goToContactList", sender: self)
                    }
                    SVProgressHUD.dismiss()
                }
                break;
            }
            
        } else {
            SVProgressHUD.dismiss()
            AlertDialog.createNoInternetAlert(controllerVC: self)
        }
    }
    
    func createUserInDB(userID: String?, userName: String) {
        
        if let user = userID {
            let userDB = Database.database().reference().child("users").child(user)
            let userDict = ["name": userName, "email": String(self.emailTextField.text!)]
            
            userDB.setValue(userDict) {
                (error, reference) in
                if(error != nil) {
                    print(error!)
                } else {
                    print("user added succesfully")
                }
            }
        }
        
    }
}
