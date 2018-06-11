//
//  CustomeCell.swift
//  HaveToBudget
//
//  Created by Hitender Thejaswi on 6/3/18.
//  Copyright © 2018 Hitender Thejaswi. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {


    @IBOutlet weak var cellDateLabel: UILabel!
    @IBOutlet weak var cellForOrFromLabel: UILabel!
    @IBOutlet weak var cellMoneyLabel: UILabel!
    
    var date : String = ""
    var forWhat : String = ""
    var howMuch : Int = 0
    
}
