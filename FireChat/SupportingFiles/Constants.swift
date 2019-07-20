//
//  Constants.swift
//  FireChat
//
//  Created by Khairul Bashar on 27/6/19.
//  Copyright © 2019 Khairul Bashar. All rights reserved.
//

import UIKit

enum SignInCategory: Int {
    
    case login = 0
    case register = 1
}

enum buttonStringConstants: String {
    
    case login = "Log In"
    case register = "Register"
}

enum NoInternetConstants: String {
    
    case noInternetText = "No Internet Connection"
    case connectInternetText = "Please connect to internet by WiFi or mobile data"
}

enum AlertActionConstants: String {
    case buttonOk = "OK"
    case buttonCancel = "Cancel"
    case buttonOpenSettings = "Open Settings"
}
