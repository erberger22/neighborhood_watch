//
//  CreatePinViewController.swift
//  neighborhood watch
//
//  Created by Harini Balakrishnan on 5/21/17.
//
//

import UIKit

class CreatePinViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    
    let categories = ["Sanitation","Suspicious Activity","Infrastructure","Crowd","Blocked Roads"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  categories[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    //var child = ""
    
    //func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //child = categories[row]
    //}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
