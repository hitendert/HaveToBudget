//
//  SummaryModel.swift
//  HaveToBudget
//
//  Created by Hitender Thejaswi on 6/13/18.
//  Copyright © 2018 Hitender Thejaswi. All rights reserved.
//

import Foundation

class SummaryModel {
    
    var name : String = ""
    var money : Double = 0.0
    var income : Bool = true
    
    
    init(name : String, money : Double, income : Bool) {
        
        self.name = name
        self.money = money
        self.income = income
    }
    
}
