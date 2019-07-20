//
//  SignInViewController.swift
//  FireChat
//
//  Created by Khairul Bashar on 27/6/19.
//  Copyright © 2019 Jahid Bashar. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    var signInType = SignInCategory.login
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSignInButtonText()
    }
    
    func setSignInButtonText() {
        
        switch signInType {
        case .login:
            signInButton.setTitle(buttonStringConstants.login.rawValue, for: .normal)
            break;
        case .register:
            signInButton.setTitle(buttonStringConstants.register.rawValue, for: .normal)
            break;
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func signInButtonPressed(_ sender: UIButton) {
        
        if Connectivity.isConnectedToInternet {
            
            switch signInType {
            case .login:
                Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    if( error != nil) {
                        print(error!)
                        let titleString: String = "Error to " + sender.title(for: .normal)!
                        self.createSignInErrorAlert(title: titleString)
                    } else {
                        print("Succefull login")
                        //SVProgressHUD.dismiss()
                        self.performSegue(withIdentifier: "goToRecentChatList", sender: self)
                    }
                }
                break;
            case .register:
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    if(error != nil) {
                        print(error!)
                        let titleString: String = "Error to " + sender.title(for: .normal)!
                        
                        self.createSignInErrorAlert(title: titleString)
                        
                    } else {
                        //success
                        print("registration success")
                        //SVProgressHUD.dismiss()
                        self.createUserInDB()
                        self.performSegue(withIdentifier: "goToContactList", sender: self)
                    }
                }
                break;
            }
            
        } else {
            AlertDialog.createNoInternetAlert(controllerVC: self)
        }
    }
    
    func createSignInErrorAlert(title: String) {
        
        let message: String = "Invalid email address or password!"
        let alertAction = UIAlertAction(title: AlertActionConstants.buttonOk.rawValue, style: .default, handler: nil)
        
        AlertDialog.showAlert(title: title, message: message, controllerVC: self, actionPositive: alertAction)
    }
    
    func createUserInDB(user: FIRUser?) {
        guard let uid = User?.UID else {
            return
        }
        let userDB = Database.database().reference().child("users").child(uid)
    }
}
