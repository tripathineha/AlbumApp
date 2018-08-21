//
//  Utilities.swift
//  AlbumApp
//
//  Created by Neha Tripathi on 16/01/18.
//  Copyright © 2018 Neha Tripathi. All rights reserved.
//

import Foundation
import UIKit

/// Includes various utilities for the application

private let utility = Utilities()

class Utilities {
    
    class var sharedInstance : Utilities {
        return utility
    }
    
    fileprivate init(){
    }
    
    /// method to create an alert whenever any error occurs
    ///
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: Message of the alert
    ///   - hasCancelAction: true if the alert has a cancel action along with ok action, otherwise false
    /// - Returns: alert with the above properties
    func createAlert(title: String? , message: String?, hasCancelAction : Bool) -> UIAlertController{
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        if hasCancelAction {
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            errorAlert.addAction(cancelAction)
        }
        errorAlert.addAction(okAction)
        return errorAlert
    }
}
