//
//  AddViewController.swift
//  HaveToBudget
//
//  Created by Hitender Thejaswi on 5/28/18.
//  Copyright © 2018 Hitender Thejaswi. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var addMoneyButton: UIButton!
    @IBOutlet weak var forWhatTextField: UITextField!
    @IBOutlet weak var howMuchTextField: UITextField!
    @IBOutlet weak var addCategoryPickerView: UIPickerView!
    
    let categoryArray : [String] = ["Charity","Savings","Housing","Utilities","Select a category","Groceries","Restaurant","Clothing","Petrol","Vehichle Maintencance", "Medical", "Insurance", "Pocket Money", "Entertainment", "Vacation"]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forWhatTextField.delegate = self
        howMuchTextField.delegate = self
        howMuchTextField.keyboardType = .decimalPad
        addCategoryPickerView.dataSource = self
        addCategoryPickerView.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBudget))

        addCategoryPickerView.selectRow(4, inComponent: 0, animated: true)
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
        
        if (howMuchTextField.text! != "" && forWhatTextField.text! != "" && selectedCategory != "" && selectedCategory != "Select a category") {
    
        
        createNewEntry()
        saveExpense()

        ProgressHUD.showSuccess()
        
        forWhatTextField.text = ""
        howMuchTextField.text = ""
            
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

    func saveExpense() {

        do {
            try context.save()
        } catch {
            print("Error while saving data")
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
        
        let forWhat = trimTrailingSpace(stringToBeTrimmed: forWhatTextField.text!)
        
        let newEntry = DetailMoneyTransactions(context: context)
        newEntry.money = (howMuchTextField.text! as NSString).doubleValue
        //newEntry.forOrFrom = forWhatTextField.text!
        newEntry.forOrFrom = forWhat
        newEntry.category = selectedCategory
        newEntry.date = getDate()
        newEntry.income = false
    }
    
    @objc func addBudget() {
        
        performSegue(withIdentifier: "goToBudgetVC", sender: self)
        
    }

    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func trimTrailingSpace(stringToBeTrimmed : String) -> String {
        
        var trimmedString = stringToBeTrimmed
        
        while trimmedString.hasSuffix(" ") {
            trimmedString = String(stringToBeTrimmed.dropLast())
        }
        
        return trimmedString
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
}















