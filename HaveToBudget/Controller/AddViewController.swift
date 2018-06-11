//
//  AddViewController.swift
//  HaveToBudget
//
//  Created by Hitender Thejaswi on 5/28/18.
//  Copyright © 2018 Hitender Thejaswi. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    @IBOutlet weak var addMoneyButton: UIButton!
    @IBOutlet weak var forWhatTextField: UITextField!
    @IBOutlet weak var howMuchTextField: UITextField!
    @IBOutlet weak var addCategoryPickerView: UIPickerView!
    
    let categoryArray : [String] = ["Charity","Savings","Housing","Utilities","Groceries","Restaurant","Clothing","Petrol","Vehichle Maintencance", "Medical", "Insurance", "Pocket Money", "Entertainment", "Vacation"]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var expenseArray : [MoneyTransactions] = []
    
    var selectedCategory : String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCategoryPickerView.dataSource = self
        addCategoryPickerView.delegate = self

        loadBudget()

    }

    override func viewWillAppear(_ animated: Bool) {


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

        if expenseArray.count > 0 {

            for items in 0..<expenseArray.count {

                if (expenseArray[items].category == selectedCategory) {

                    expenseArray[items].money -= (howMuchTextField.text! as NSString).doubleValue
                    expenseArray[items].forOrFrom = forWhatTextField.text!
                    expenseArray[items].category = selectedCategory
                    expenseArray[items].date = getDate()

                    createNewEntry()
                    
                    saveExpense()

                } else {
                   // Add an alert here telling the user that budget has not been entered yet for this category.
                }

            }


        }

    }


    func loadBudget() {

        let request : NSFetchRequest<MoneyTransactions> = MoneyTransactions.fetchRequest()

        do {
            expenseArray = try context.fetch(request)

        } catch {
            print ("Error while fetching data in AddViewController")
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
        
        let newEntry = DetailMoneyTransactions(context: context)
        newEntry.money = (howMuchTextField.text! as NSString).doubleValue
        newEntry.forOrFrom = forWhatTextField.text!
        newEntry.category = selectedCategory
        newEntry.date = getDate()
        
        
    }




}
