//
//  CompanyTable.swift
//  Aggregator
//
//  Created by Mac Mini on 8/30/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit

protocol CompanyDelegate : class {
    func didPressButton(sender: UIButton)
}

class CompanyTable : UITableViewCell {
    weak var cellDelegate: CompanyDelegate?
    
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var premium: UILabel!
    @IBOutlet weak var checkBoxSelected: UIButton!
    @IBOutlet weak var view: UIButton!
    @IBOutlet weak var companyView: UIView!
    
//  connect the button from your cell with this method
    @IBAction func buttonPressed(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender: sender)
    }
}
