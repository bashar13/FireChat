//
//  Connectivity.swift
//  FireChat
//
//  Created by Khairul Bashar on 28/6/19.
//  Copyright © 2019 Jahid Bashar. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
}
