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
    
    var addMoneyArray : [MoneyTransactions] = []
    
    
    
    var categoryFound : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMoneyTextField.delegate = self
        addMoneyTextField.keyboardType = .decimalPad
        enterCategoryPickerView.delegate = self
        enterCategoryPickerView.dataSource = self
       
        loadTheArray()
        print("Hitu count = \(addMoneyArray.count)")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTheArray()
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
        
        
        if addMoneyArray.count > 0 {
            
            print("Hitu001 Cursor here")
            for index in 0..<addMoneyArray.count {
                
                if addMoneyArray[index].category == selectedCategory {
                    
                    print("Hitu002 Cursor here")
                    addMoneyArray[index].money += (addMoneyTextField.text! as NSString).doubleValue
                    addMoneyArray[index].forOrFrom = sourceOfMoneyTextField.text!
                    addMoneyArray[index].category = selectedCategory
                    addMoneyArray[index].date = getDate()
                    categoryFound = true
                    
                    saveIncome()
                    
                }
                
            }
                if categoryFound == false {
                    
                    print("Hitu003 Cursor here")
                    let newMoney = MoneyTransactions(context: context)
                    newMoney.money = (addMoneyTextField.text! as NSString).doubleValue
                    newMoney.forOrFrom = sourceOfMoneyTextField.text!
                    newMoney.category = selectedCategory
                    newMoney.date = getDate()
                    
                    saveIncome()
                    
                }
                
        } else {
            print("Hitu004 Cursor here")
            let newMoney = MoneyTransactions(context: context)
            newMoney.money = (addMoneyTextField.text! as NSString).doubleValue
            newMoney.forOrFrom = sourceOfMoneyTextField.text!
            newMoney.category = selectedCategory
            newMoney.date = getDate()
            
            saveIncome()
        }
        
        
        
    }
    
    
    func saveIncome() {
        
        print("Cursor here Hitu01")
        
        do {
            try context.save()
        } catch {
            print("Error while saving")
        }
        
    }
    
    func loadTheArray() {
        
        let request : NSFetchRequest<MoneyTransactions> = MoneyTransactions.fetchRequest()
        do {
            addMoneyArray = try context.fetch(request)
        } catch {
            print("Error while fetching in Enter Budget VC")
        }
        
    }
    
    func getDate() -> String {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        
        return result
        
    }
    

}
