//
//  EnterBudgetViewController.swift
//  HaveToBudget
//
//  Created by Hitender Thejaswi on 5/28/18.
//  Copyright © 2018 Hitender Thejaswi. All rights reserved.
//

import UIKit
import CoreData

class EnterBudgetViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
 
    
    
    @IBOutlet weak var addMoneyTextField: UITextField!
    @IBOutlet weak var sourceOfMoneyTextField: UITextField!
    @IBOutlet weak var enterCategoryPickerView: UIPickerView!
    var selectedCategory : String = ""
    
    let categoryArray : [String] = ["Charity","Savings","Housing","Utilities","Groceries","Restaurant","Clothing","Petrol","Vehichle Maintencance", "Medical", "Insurance", "Pocket Money", "Entertainment", "Vacation"]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMoneyTextField.delegate = self
        addMoneyTextField.keyboardType = .decimalPad
        enterCategoryPickerView.delegate = self
        enterCategoryPickerView.dataSource = self
       
        
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(categoryArray[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedCategory = categoryArray[row]
    }
  
    @IBAction func bottomAddTapped(_ sender: Any) {
        
        let newMoney = AddMoney(context: context)
        
        if let addMoney = Double(addMoneyTextField.text!)
        {
        newMoney.addHowMuch = addMoney
        }
        
        newMoney.sourceOfMoney = sourceOfMoneyTextField.text
        newMoney.category = selectedCategory
       
        saveIncome()
        
    }
    
    func saveIncome() {
        
        print("Cursor here Hitu01")
        
        do {
            try context.save()
        } catch {
            print("Error while saving")
        }
        
    }
    

}
