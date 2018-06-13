//
//  SummaryViewController.swift
//  HaveToBudget
//
//  Created by Hitender Thejaswi on 6/11/18.
//  Copyright © 2018 Hitender Thejaswi. All rights reserved.
//

import UIKit
import CoreData

class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var summaryTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var detailExpenseArray : [DetailMoneyTransactions] = []
    
    //var groupedArray : [DetailMoneyTransactions] = []
    
    var groupedArray : [SummaryModel] = []
    
    var sortedArray : [SummaryModel] = []
    
    var count = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        detailExpenseArray.removeAll()
        
        groupedArray.removeAll()
        
        sortedArray.removeAll()
        
        loadBudget()
        
        
        
        count = 0
        
        groupTheExpenses()
        
        
        summaryTableView.delegate = self
        summaryTableView.dataSource = self
        
        summaryTableView.register(UINib(nibName: "SummaryCell", bundle: nil), forCellReuseIdentifier: "summaryCellIdentifier")
        
        print("Hitu01 here")
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // groupedArray.removeAll()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCellIdentifier", for: indexPath) as! SummaryCell
        
        cell.forWhatLabel.text = sortedArray[indexPath.row].name
        cell.howMuchLabel.text = "\(sortedArray[indexPath.row].money)"
        
        if sortedArray[indexPath.row].income == true {
            cell.howMuchLabel.textColor = UIColor(red:0.44, green:0.71, blue:0.28, alpha:1.0)
        } else {
            cell.howMuchLabel.textColor = UIColor(red:1.00, green:0.40, blue:0.40, alpha:1.0)
        }
        
        return cell
    }

   
    func loadBudget() {
        let request : NSFetchRequest<DetailMoneyTransactions> = DetailMoneyTransactions.fetchRequest()
        
        do {
            detailExpenseArray = try context.fetch(request)
        } catch {
            print("Error while retrieving data")
        }
    }
    
    func groupTheExpenses() {
        
         groupedArray.removeAll()
        
        for items in detailExpenseArray {
            
            var itemFound : Bool = false
            
            if count == 0 {
                
                groupedArray.append(SummaryModel(name: items.forOrFrom!, money: items.money, income: items.income))
                
            } else {
                
                for group in groupedArray {
                    
                    
                    if group.name.uppercased() == items.forOrFrom?.uppercased() {
                        
                        group.money += items.money
                       
                        print("Hitu100 cursor here")
                        
                        itemFound = true
                        
                    }
                    
                }
                
                if itemFound == false {
                    
                   groupedArray.append(SummaryModel(name: items.forOrFrom!, money: items.money, income: items.income))
                }
            }
            count = 1;
        }
        
       sortedArray = groupedArray.sorted(by: {$0.money > $1.money})
        
    }

    
//    func saveExpenses() {
//        do {
//            try context.save()
//        } catch {
//            print("Error while saving data in Summary")
//        }
//    }
    
    
    
    
    
    
}
