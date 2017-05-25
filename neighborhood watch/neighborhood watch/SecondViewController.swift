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
        @IBOutlet weak var gradientView: UIView!
    
        var gradientLayer: CAGradientLayer!
        private var _navigationController: UINavigationController?
        override var navigationController: UINavigationController? {
        get {
            return _navigationController
        } set {
            _navigationController = newValue
        }
        }
    
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
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: {
                                    let pinVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PinVC") as! CreatePinViewController
                                    self._navigationController?.pushViewController(pinVC, animated: true)
                                })
                            }
                        }
                        else
                        {
                            if let myError = error?.localizedDescription
                            {
                                print(myError)
                                let alert = UIAlertController(title: "Invalid Email or Password", message: myError, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                               
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
//                            self.performSegue(withIdentifier: "segue", sender: self)

                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: {
                                    let pinVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PinVC") as! CreatePinViewController
                                    self._navigationController?.pushViewController(pinVC, animated: true)
                                })
                            }
                        }
                        else
                        {
                            if let myError = error?.localizedDescription
                            {
                                print(myError)
                                let alert = UIAlertController(title: "Invalid Email or Password", message: myError, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
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
            emailText.layer.cornerRadius = 8
            passwordText.layer.cornerRadius = 8
            // Do any additional setup after loading the view, typically from a nib.
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            createGradientLayer()
         }
    
       func createGradientLayer() {
            gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.gradientView.bounds
        let firstColor = UIColor(red: 20/255, green: 105/255, blue: 155/255, alpha:1.0)
        let secondColor = UIColor(red: 132/255, green: 146/255, blue: 155/255, alpha:1.0)
            gradientLayer.colors = [secondColor.cgColor, firstColor.cgColor]
            gradientView.layer.addSublayer(gradientLayer)
         }
    
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        }
}

