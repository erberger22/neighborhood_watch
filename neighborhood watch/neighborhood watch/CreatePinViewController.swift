//
//  CreatePinViewController.swift
//  neighborhood watch
//
//  Created by Harini Balakrishnan on 5/21/17.
//
//

import UIKit
import FirebaseDatabase

class CreatePinViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var descriptionField: UITextView!
    var child = ""
    
    func checkChild()
    {
        print(child)
    }
    
    
    
    var ref:DatabaseReference?
    
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        child = categories[row]
    }
    
    @IBAction func submitButton(_ sender: Any) {
        ref = Database.database().reference()
        if descriptionField.text != ""
        {
            let pinInfo = ["Description": descriptionField.text!, "longitude": 123, "latitude": 321] as [String : Any]
            ref?.child("\(child)").childByAutoId().setValue(pinInfo)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
