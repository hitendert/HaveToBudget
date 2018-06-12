//
//  EnterBudgetViewController.swift
//  HaveToBudget
//
//  Created by Hitender Thejaswi on 5/28/18.
//  Copyright © 2018 Hitender Thejaswi. All rights reserved.
//

import UIKit
import CoreData

class EnterBudgetViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var addMoneyTextField: UITextField!
    @IBOutlet weak var sourceOfMoneyTextField: UITextField!
    @IBOutlet weak var enterCategoryPickerView: UIPickerView!
    var selectedCategory : String = ""
    
    let categoryArray : [String] = ["Charity","Savings","Housing","Utilities","Groceries","Restaurant","Clothing","Petrol","Vehichle Maintencance", "Medical", "Insurance", "Pocket Money", "Entertainment", "Vacation"]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryFound : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMoneyTextField.delegate = self
        addMoneyTextField.keyboardType = .decimalPad
        sourceOfMoneyTextField.delegate = self
        
        enterCategoryPickerView.delegate = self
        enterCategoryPickerView.dataSource = self
       
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearAll))
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
        
        createNewEntry()
        
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
    
    
    
    func getDate() -> String {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        
        return result
        
    }
    
    func createNewEntry() {
        
        let newEntry = DetailMoneyTransactions(context: context)
        newEntry.money = (addMoneyTextField.text! as NSString).doubleValue
        newEntry.forOrFrom = sourceOfMoneyTextField.text!
        newEntry.category = selectedCategory
        newEntry.date = getDate()
        newEntry.income = true
        
        
    }
    
    @objc func clearAll() {
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Clear all data", message: "Are you sure you want to clear all the data ? This can't be Undone", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Yes, I'm sure", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            let fetchRequest : NSFetchRequest<DetailMoneyTransactions> = DetailMoneyTransactions.fetchRequest()
            
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try self.context.fetch(fetchRequest)
                for items in results {
                    self.context.delete(items)
                }
            } catch {
                print("error while deleting all")
            }
            
            self.saveIncome()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        // Add the actions
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }

    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}


















