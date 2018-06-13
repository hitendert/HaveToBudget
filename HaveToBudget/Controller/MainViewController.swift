//
//  ViewController.swift
//  HaveToBudget
//
//  Created by Hitender Thejaswi on 5/28/18.
//  Copyright © 2018 Hitender Thejaswi. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceLabel2: UILabel!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let categoryArray : [String] = ["Charity","Savings","Housing","Utilities","Select a category","Groceries","Restaurant","Clothing","Petrol","Vehichle Maintencance", "Medical", "Insurance", "Pocket Money", "Entertainment", "Vacation"]
    
    var detailExpenseArray : [DetailMoneyTransactions] = []
    
    var filteredArray : [DetailMoneyTransactions] = []
    
    var balance : Double = 0.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font : UIFont(name : "HelveticaNeue-Light", size : 20)]
        
        
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        loadBudget()
        
        categoryPickerView.reloadAllComponents()
        
        categoryPickerView.selectRow(4, inComponent: 0, animated: true)
        balanceLabel.text = "₹"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        categoryPickerView.selectRow(4, inComponent: 0, animated: true)
        balanceLabel.text = "₹"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       //categoryPickerView.selectRow(4, inComponent: 0, animated: true)
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
        
        loadBudget()
        
       let selectedCategoy = categoryArray[row]

        filteredArray = detailExpenseArray.filter({$0.category == selectedCategoy})
        
        let bal = calculateBalance()
        
        balanceLabel.text = "₹ \(bal)"
        
        if (balanceLabel.text?.contains("-"))! {
            balanceLabel.textColor = UIColor(red:1.00, green:0.40, blue:0.40, alpha:1.0)
        } else {
            balanceLabel.textColor = UIColor(red:0.07, green:0.51, blue:0.76, alpha:1.0)
        }
        
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func detailsButtonTapped(_ sender: Any) {
        
    }
    
    func loadBudget() {
        
        let request : NSFetchRequest<DetailMoneyTransactions> = DetailMoneyTransactions.fetchRequest()
        do {
            detailExpenseArray = try context.fetch(request)
        } catch {
            print("Error in retrieving data")
        }
     
    }
    
    func calculateBalance() -> Double {
        
        var income : Double = 0.0
        var expenses : Double = 0.0
        
        for items in filteredArray {
            
            if items.income == true {
                
                income += items.money
                
            } else {
                
                expenses += items.money
            }
            
        }
        
        balance = income - expenses
    
        return balance
    }
    
}

