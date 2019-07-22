//
//  User.swift
//  FireChat
//
//  Created by Khairul Bashar on 2019-07-20.
//  Copyright © 2019 Jahid Bashar. All rights reserved.
//

import Foundation

class User {
    
    var userName: String
    var userEmail: String
    
    init(user: String, email: String) {
        userName = user
        userEmail = email
    }
}
