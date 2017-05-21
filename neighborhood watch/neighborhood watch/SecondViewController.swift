//
//  SecondViewController.swift
//  neighborhood watch
//
//  Created by Eli Berger on 5/20/17.
//
//

import UIKit
import FirebaseAuth

class SecondViewController: UIViewController {
        
        @IBOutlet var emailText: UITextField!
        @IBOutlet var segmentControl: UISegmentedControl!
        @IBOutlet var passwordText: UITextField!
        @IBOutlet var actionButton: UIButton!
        
        
        @IBAction func action(_ sender: Any)
        {
            if emailText.text != "" && passwordText.text != ""
            {
                if segmentControl.selectedSegmentIndex == 0 //Login user
                {
                    Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
                        if user != nil
                        {
                            //Log in Successful
                            print("Success")
                            self.performSegue(withIdentifier: "segue", sender: self)
                        }
                        else
                        {
                            if let myError = error?.localizedDescription
                            {
                                print(myError)
                            }
                            else
                            {
                                print("ERROR")
                            }
                        }
                    })
                }
                else //Sign up user
                {
                    Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!, completion: {(user, error) in
                        if user != nil
                        {
                            self.performSegue(withIdentifier: "segue", sender: self)
                        }
                        else
                        {
                            if let myError = error?.localizedDescription
                            {
                                print(myError)
                            }
                            else
                            {
                                print("ERROR")
                            }
                        }
                    })
                }
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
}

