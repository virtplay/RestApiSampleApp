//
//  AlertController.swift
//  RestApiSampleApp
//
//  Created by Karthik on 27/12/18.
//  Copyright © 2018 k4. All rights reserved.
//

import Foundation
import UIKit

class AlertController: NSObject {
    
    //Call this function to show any alert message to user
    class func showAlertToUser(messageTitle:String, message: String, controller:UIViewController){
        
        let alertController = UIAlertController(title: messageTitle,
                                                message: message,
                                                preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        controller.present(alertController, animated: true, completion: nil)
        
    }
}
