//
//  CoverTable.swift
//  Aggregator
//
//  Created by Mac Mini on 8/30/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit

protocol CoverDelegate : class {
    func didPressCoverCheckBox(sender: UIButton)
}

class CoverTable : UITableViewCell {
    weak var cellDelegate: CoverDelegate?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var checkBox: UIButton!
    
    @IBAction func didPressCheckBox(_ sender: UIButton) {
        cellDelegate?.didPressCoverCheckBox(sender: sender)
    }
}
