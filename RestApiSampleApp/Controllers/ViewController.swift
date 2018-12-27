//
//  ViewController.swift
//  RestApiSampleApp
//
//  Created by Karthik on 27/12/18.
//  Copyright © 2018 k4. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailIdTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "img1.jpg")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        backgroundImage.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(backgroundImage, at: 0)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func goBtnClicked(_ sender: Any) {
        // Check for valid email id and present the list view controller
        
        if let emailid = emailIdTxtField.text{
            if( isValidEmail(testStr: emailid) ){
                // valid email id
                // Do post request and save to persistence storage
                let listvc = self.storyboard?.instantiateViewController(withIdentifier: "listviewid") as! ListTableViewController
                listvc.emailid = emailIdTxtField.text
                self.present(listvc, animated: true, completion: nil)
                
            }else{
                // Invalid Email id
                AlertController.showAlertToUser(messageTitle: "Invalid Email id", message: "Enter valid email address", controller: self)
            }
        }
    }
    
    
    // validate the email id input 
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
   


}

