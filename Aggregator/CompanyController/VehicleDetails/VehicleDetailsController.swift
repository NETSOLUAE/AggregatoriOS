//
//  VehicleDetailsController.swift
//  Aggregator
//
//  Created by Mac Mini on 8/30/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class VehicleDetailsController: UIViewController, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = IndicatorInfo(title: "PersonalDetails")
    let constants = Constants()
    let webserviceManager = WebserviceManager();
    let sharedInstance = CoreDataManager.sharedInstance;
    let managedContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
    
    @IBOutlet weak var usage: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var make: UILabel!
    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var variant: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var policyType: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        usage.text = "\("Vehicle Usage: ")\(currentSelection.usageName)"
        type.text = "\("Vehicle Type: ")\(currentSelection.typeName)"
        make.text = "\("Vehicle Make: ")\(currentSelection.makeName)"
        model.text = "\("Vehicle Model: ")\(currentSelection.modelName)"
        variant.text = "\("Vehicle Variant: ")\(currentSelection.variantName)"
        place.text = "\("Place of Registration: ")\(currentSelection.rtoName)"
        date.text = "\("Date of Registration: ")\(currentSelection.date)"
        price.text = "\("Price: ")\(currentSelection.price)"
        policyType.text = "\("Policy Type: ")\(currentSelection.Policy)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
