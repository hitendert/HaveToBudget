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
    
    let categoryArray : [String] = ["Charity","Savings","Housing","Utilities","Groceries","Restaurant","Clothing","Petrol","Vehichle Maintencance", "Medical", "Insurance", "Pocket Money", "Entertainment", "Vacation"]
    
    var expenseArray : [AddMoney] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        loadBudget()
        
        
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
        
        print("Cursor here Hitu02")
        loadBudget()
        
       let selectedCategoy = categoryArray[row]
        
        for item in expenseArray {
            
            if selectedCategoy == item.category {
                balanceLabel.text = "\(item.addHowMuch)"
            }
            
        }
        
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func detailsButtonTapped(_ sender: Any) {
        
    }
    
    func loadBudget() {
        
        let request : NSFetchRequest<AddMoney> = AddMoney.fetchRequest()
        do {
            expenseArray = try context.fetch(request)
        } catch {
            print("Error in retrieving data")
        }
     
    }
    
}

