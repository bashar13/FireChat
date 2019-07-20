//
//  AlertDialog.swift
//  FireChat
//
//  Created by Khairul Bashar on 28/6/19.
//  Copyright © 2019 Jahid Bashar. All rights reserved.
//

import UIKit

class AlertDialog {
    
    static func showAlert(title: String, message: String, controllerVC: UIViewController, actionPositive: UIAlertAction, actionNegative: UIAlertAction? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(actionPositive)
        if let action = actionNegative {
            alert.addAction(action)
        }
        
        controllerVC.present(alert, animated: true, completion: nil)
        
    }
    
    static func createNoInternetAlert(controllerVC: UIViewController) {
        let alertTitle = NoInternetConstants.noInternetText.rawValue
        let alertMessage = NoInternetConstants.connectInternetText.rawValue
        let positiveAction = UIAlertAction(title: AlertActionConstants.buttonOpenSettings.rawValue,
                                           style: UIAlertAction.Style.default,
                                           handler: openSettings)
        let negativeAction = UIAlertAction(title: AlertActionConstants.buttonCancel.rawValue,
                                           style: UIAlertAction.Style.default,
                                           handler: nil)
        
        showAlert(title: alertTitle, message: alertMessage, controllerVC: controllerVC, actionPositive: positiveAction, actionNegative: negativeAction)
    }
    
    static func openSettings(alert: UIAlertAction!) {
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}
