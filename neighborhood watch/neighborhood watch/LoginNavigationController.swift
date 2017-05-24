//
//  LoginNavigationController.swift
//  neighborhood watch
//
//  Created by Brian Wong on 5/24/17.
//
//

import Foundation
import UIKit


class LoginNavigationController: UINavigationController {
    
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
}
