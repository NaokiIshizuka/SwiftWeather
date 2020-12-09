//
//  RegisterViewController.swift
//  Swift5WeatherForecast
//
//  Created by 石塚直樹 on 2020/10/18.
//  Copyright © 2020 Naoki Ishizuka. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func registerButtom(_ sender: Any) {
        
        //新規登録
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                
                print(error as Any)
                
            } else {
                
                print("新規登録");
                print("id")
                print(Auth.auth().currentUser?.uid)
                print("stringid")
                print(String(Auth.auth().currentUser!.uid))
                print("ユーザーの作成が成功しました！")
                
            }
            
        }
        
        self.performSegue(withIdentifier: "shinki", sender: nil)
        
    }

}
