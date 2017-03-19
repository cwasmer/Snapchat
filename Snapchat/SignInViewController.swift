//
//  SignInViewController.swift
//  Snapchat
//
//  Created by Christian Wasmer on 19/03/2017.
//  Copyright © 2017 Christian Wasmer. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func turnUpTapped(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            print ("we tried to sign in")
            if error != nil {
                print ("ERRORRRR \(error)")
                FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    print ("Tried to create user")
                    if error != nil {
                        print ("ERRORRRR \(error)")
                    } else {
                        print ("Created user")
                        self.performSegue(withIdentifier: "signinsegue", sender: nil)

                    }
                })
            } else {
                print ("Sign in success!!")
                self.performSegue(withIdentifier: "signinsegue", sender: nil)
            }
        })
        
    }
    
    
}

