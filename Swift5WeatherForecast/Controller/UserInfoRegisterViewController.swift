//
//  UserInfoRegisterViewController.swift
//  Swift5WeatherForecast
//
//  Created by 石塚直樹 on 2020/10/21.
//  Copyright © 2020 Naoki Ishizuka. All rights reserved.
//

import UIKit
import FirebaseCore
import Firebase
import FirebaseFirestore

class UserInfoRegisterViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var liveTownTextField: UITextField!
    
    @IBOutlet weak var goTownTextField: UITextField!
    
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    @IBAction func userInfoRegisterButton(_ sender: Any) {
        
        let userID = Auth.auth().currentUser!.uid
        db.collection("users").document(String(userID)).setData([
            "userName": userNameTextField.text!,
            "liveTown": liveTownTextField.text!,
            "goTown": goTownTextField.text!
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }

        self.performSegue(withIdentifier: "tenki", sender: nil)
        
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextVC = segue.destination as! TenkiViewController
        nextVC.userLabel = userNameTextField.text!
        
    }*/
    

}
