//
//  PersonalDetailsController.swift
//  Aggregator
//
//  Created by Mac Mini on 8/30/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class PersonalDetailsController: UIViewController, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = IndicatorInfo(title: "Personal Details")
    let constants = Constants()
    let webserviceManager = WebserviceManager();
    let sharedInstance = CoreDataManager.sharedInstance;
    let managedContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var mobileNo: UILabel!
    @IBOutlet weak var nationalID: UILabel!
    @IBOutlet weak var email: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = "\("Name: ")\(currentSelection.name)"
        age.text = "\("Age: ")\(currentSelection.age)"
        mobileNo.text = "\("Name: ")\(currentSelection.mobileNumber)"
        nationalID.text = "\("Name: ")\(currentSelection.nationalID)"
        email.text = "\("Name: ")\(currentSelection.email)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
