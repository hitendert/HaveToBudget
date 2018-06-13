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
    @IBOutlet weak var incomeLabel: UILabel!
    
    let categoryArray : [String] = ["Charity","Savings","Housing","Utilities","Select a category","Groceries","Restaurant","Clothing","Petrol","Vehichle Maintencance", "Medical", "Insurance", "Pocket Money", "Entertainment", "Vacation"]
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryFound : Bool = false
    
    var incomeArray :[Income] = []
    
    var incomeBalance : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMoneyTextField.delegate = self
        addMoneyTextField.keyboardType = .decimalPad
        sourceOfMoneyTextField.delegate = self
        
        enterCategoryPickerView.delegate = self
        enterCategoryPickerView.dataSource = self
       
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearAll))
   
        enterCategoryPickerView.selectRow(4, inComponent: 0, animated: true)
        
       incomeArray.removeAll()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        incomeBalance = 0.0
        loadIncomeLabel()
        calculateIncome()
        incomeLabel.text = "Income to be budgeted : ₹\(incomeBalance)"
        
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
        
        if (addMoneyTextField.text! != "" && sourceOfMoneyTextField.text! != "" && selectedCategory != "" && selectedCategory != "Select a category") {
            
            let addMoney = (addMoneyTextField.text! as NSString).doubleValue
            
            let addMoneyCheck = incomeBalance - addMoney
            
            if (incomeBalance > 0 && addMoneyCheck >= 0 ){
                
            
        createNewEntry()
        
        saveIncome()
        
        ProgressHUD.showSuccess()
        
        addMoneyTextField.text = ""
        sourceOfMoneyTextField.text = ""
                
                incomeBalance = 0.0
                loadIncomeLabel()
                calculateIncome()
                incomeLabel.text = "\(incomeBalance)"
                
            } else {
                // Create the alert controller
                let alertController = UIAlertController(title: "Not enough funds", message: "You have run out of your income", preferredStyle: .alert)
                
                alertController.setValue(NSAttributedString(string: "Not enough funds!", attributes: [NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    
                    alertController.dismiss(animated: true, completion: nil)
                }
                
                // Add the actions
                alertController.addAction(okAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
            
        } else {
            
            // Create the alert controller
            let alertController = UIAlertController(title: "Oops", message: "Looks like you missed to enter some values there", preferredStyle: .alert)
            
            alertController.setValue(NSAttributedString(string: "Oops!", attributes: [NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
                alertController.dismiss(animated: true, completion: nil)
            }
            
            // Add the actions
            alertController.addAction(okAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    
    func saveIncome() {
        
        
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
        
        let newIncome = Income(context: context)
        newIncome.income = -(addMoneyTextField.text! as NSString).doubleValue
        
        
    }
    
    @objc func clearAll() {
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Clear all data", message: "Are you sure you want to clear all the data ? This can't be undone", preferredStyle: .alert)
        
        alertController.setValue(NSAttributedString(string: "Clear all data", attributes: [NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
        
        
        // Create the actions
        let okAction = UIAlertAction(title: "Yes, I'm sure", style: UIAlertActionStyle.destructive) {
            UIAlertAction in
            NSLog("OK Pressed")
            let fetchRequest : NSFetchRequest<DetailMoneyTransactions> = DetailMoneyTransactions.fetchRequest()
            let incomeFetchRequest : NSFetchRequest<Income> = Income.fetchRequest()
            
            fetchRequest.returnsObjectsAsFaults = false
            incomeFetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try self.context.fetch(fetchRequest)
                for items in results {
                    self.context.delete(items)
                }
                
                let results2 = try self.context.fetch(incomeFetchRequest)
                for items in results2{
                    self.context.delete(items)
                }
            } catch {
                print("error while deleting all")
            }
            
            self.saveIncome()
            
            self.incomeLabel.text = "Income to be budgeted : ₹0.0"
            
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
    
    func loadIncomeLabel() {
        
        let request : NSFetchRequest<Income> = Income.fetchRequest()
        
        do {
            incomeArray = try context.fetch(request)
        } catch {
            print("Error while loading income")
        }
        
        
        
        
    }
    
    func calculateIncome() {
        
        for items in incomeArray {
            incomeBalance += items.income
        }
        
    }
}


















