//
//  UserAuthController.swift
//  neighborhood watch
//
//  Created by Eli Berger on 5/20/17.
//
//

import UIKit

class UserAuthController: UIViewController {
    
    
    @IBOutlet var emailText: UITextField!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var actionButton: UIButton!
    
    
    @IBAction func action(_ sender: Any) {
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
