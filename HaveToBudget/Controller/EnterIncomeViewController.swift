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
