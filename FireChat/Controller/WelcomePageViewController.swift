//
//  ViewController.swift
//  FireChat
//
//  Created by Khairul Bashar on 27/6/19.
//  Copyright © 2019 Khairul Bashar. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = appName
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: backButtonTitle, style: .plain, target: self, action: nil)
    }

    @IBAction func signInButtonPressed(_ sender: UIButton) {
        
        let destinationVC: SignInViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "storyboardSignInView") as! SignInViewController
        destinationVC.signInType = SignInCategory(rawValue: sender.tag)!
        
        self.navigationController?.show(destinationVC, sender: self)
    }
    
}

