//
//  EnterIncomeViewController.swift
//  HaveToBudget
//
//  Created by Hitender Thejaswi on 6/13/18.
//  Copyright © 2018 Hitender Thejaswi. All rights reserved.
//

import UIKit
import CoreData

class EnterIncomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var incomeTextField: UITextField!
    
    var incomeArray : [Income] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incomeTextField.delegate = self
        incomeTextField.keyboardType = .decimalPad
        
        incomeTextField.addDoneButtonToKeyboard(myAction:  #selector(self.incomeTextField.resignFirstResponder))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        createIncome()
        
        ProgressHUD.showSuccess()
        
        incomeTextField.text = ""
        
        for vc in (self.navigationController?.viewControllers ?? []) {
            if vc is EnterBudgetViewController {
                _ = self.navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
    }
    
    func createIncome() {
        
        let newIncome = Income(context: context)
        newIncome.income = (incomeTextField.text! as NSString).doubleValue
        
        incomeArray.append(newIncome)
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
 

}

extension UITextField{
    
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}


