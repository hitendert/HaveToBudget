//
//  DetailViewController.swift
//  HaveToBudget
//
//  Created by Hitender Thejaswi on 5/28/18.
//  Copyright © 2018 Hitender Thejaswi. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var detailCategoryPickerView: UIPickerView!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
     let categoryArray : [String] = ["Select a Category", "All","Charity","Savings","Housing","Utilities","Groceries","Restaurant","Clothing","Petrol","Vehichle Maintencance", "Medical", "Insurance", "Pocket Money", "Entertainment", "Vacation"]
    
    var detailExpenseArray : [DetailMoneyTransactions] = []
    
    var filteredArray : [DetailMoneyTransactions] = []
    
    var selectedCategory : String = ""
    
    var entryToBeDeleted = DetailMoneyTransactions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailCategoryPickerView.delegate = self
        detailCategoryPickerView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        detailTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCellIdentifier")
        
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
        
        filteredArray = []
        
        selectedCategory = categoryArray[row]
        
        filteredArray =  detailExpenseArray.filter({$0.category == selectedCategory})
        
        detailTableView.reloadData()
        
        if selectedCategory == "All" {
            self.editButtonItem.isEnabled = true
        } else {
            self.editButtonItem.isEnabled = false
        }
        
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (selectedCategory == "All") {
            return detailExpenseArray.count
        } else {
            return filteredArray.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCellIdentifier", for: indexPath) as! CustomCell
        
        if (selectedCategory == "All") {
        
        cell.cellDateLabel.text = detailExpenseArray[indexPath.row].date
        cell.cellForOrFromLabel.text = detailExpenseArray[indexPath.row].forOrFrom
        cell.cellMoneyLabel.text = "\(detailExpenseArray[indexPath.row].money)"
            if (detailExpenseArray[indexPath.row].income == true){
                cell.cellMoneyLabel.textColor = UIColor.green
            } else {
                cell.cellMoneyLabel.textColor = UIColor.red
            }
        print("Cursor here hitu07")
        
        } else {
            print("Cursoe here hitu08")
            cell.cellDateLabel.text = filteredArray[indexPath.row].date
            cell.cellForOrFromLabel.text = filteredArray[indexPath.row].forOrFrom
            cell.cellMoneyLabel.text = "\(filteredArray[indexPath.row].money)"
            if (filteredArray[indexPath.row].income == true){
                cell.cellMoneyLabel.textColor = UIColor.green
            } else {
                cell.cellMoneyLabel.textColor = UIColor.red
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    
    // Without adding the below code, the red-minus sign was not coming up at all after pressing the Edit button.
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        detailTableView.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Delete pressed")
            
            entryToBeDeleted = detailExpenseArray[indexPath.row]
            detailExpenseArray.remove(at: indexPath.row)
            detailTableView.reloadData()
            
            deleteEntries()
            
            saveTheEntries()
            
        }
    }
    
    func loadBudget() {
        
        let request : NSFetchRequest<DetailMoneyTransactions> = DetailMoneyTransactions.fetchRequest()
        
        do {
            detailExpenseArray = try context.fetch(request)
           
        } catch {
            print("Error while loading data in Details VC")
        }
        
    }
    
   
    func deleteEntries() {
        
        context.delete(entryToBeDeleted)
        
    }
    
    func saveTheEntries() {
        
        do {
            try context.save()
        } catch {
            print("Error while saving data in DetailVC")
        }
    }
    
    
}
