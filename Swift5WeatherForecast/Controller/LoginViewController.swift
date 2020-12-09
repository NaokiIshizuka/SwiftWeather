//
//  LoginViewController.swift
//  Swift5WeatherForecast
//
//  Created by 石塚直樹 on 2020/10/18.
//  Copyright © 2020 Naoki Ishizuka. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func login(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                
                print(error as Any)
                
            }else{
                
                self.performSegue(withIdentifier: "tenki", sender: nil)
                
            }
            
        }
        
    }
    
    
    
}
