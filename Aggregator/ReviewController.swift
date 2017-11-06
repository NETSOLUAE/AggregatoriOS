//
//  ReviewController.swift
//  Aggregator
//
//  Created by Mac Mini on 9/7/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ReviewController: UIViewController {
    
    var finalphotos = [UIImage]()
    var addressOwner = ""
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var policyStart: UILabel!
    @IBOutlet weak var policyEnd: UILabel!
    @IBOutlet weak var coverAmount: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var mobile: UILabel!
    @IBOutlet weak var nationalID: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var usage: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var make: UILabel!
    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var variant: UILabel!
    @IBOutlet weak var placeOfReg: UILabel!
    @IBOutlet weak var dateOfReg: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var thumbNailCollection: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addressHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Review"
        self.companyName.text = "\(currentCompanySelected.companyName)"
        self.policyStart.text = "\("Policy Start: ")\(currentCompanySelected.policyStart)"
        self.policyEnd.text = "\("Policy End: ")\(currentCompanySelected.policyEnd)"
        self.coverAmount.text = "\(currentCompanySelected.totalPremium)\(" OMR")"
        self.name.text = "\(currentSelection.name)"
        self.age.text = "\(currentSelection.age)"
        self.mobile.text = "\(currentSelection.mobileNumber)"
        self.nationalID.text = "\(currentSelection.nationalID)"
        self.email.text = "\(currentSelection.email)"
        self.usage.text = "\(currentSelection.usageName)"
        self.type.text = "\(currentSelection.typeName)"
        self.make.text = "\(currentSelection.makeName)"
        self.model.text = "\(currentSelection.modelName)"
        self.variant.text = "\(currentSelection.variantName)"
        self.placeOfReg.text = "\(currentSelection.rtoName)"
        self.dateOfReg.text = "\(currentSelection.vehicleRegDate)"
        self.price.text = "\(currentSelection.price)\(" OMR")"
        
        if (self.addressOwner == "") {
            self.address.isHidden = true
            self.addressHeightConstraint.constant = 0
            self.addressTopConstraint.constant = 0
        } else {
            self.address.text = self.addressOwner
            let addressHeightCount = self.addressOwner.characters.filter{$0 == "\n"}.count
            if (addressHeightCount != 0) {
                addressHeightConstraint.constant = CGFloat(addressHeightCount*15)
            }
            print("\("coverPremiumHeight:")\(addressHeightCount)")
        }
        scrollHeightConstraint.constant = scrollHeightConstraint.constant + addressHeightConstraint.constant
        self.scrollView.contentInset.bottom = scrollHeightConstraint.constant/3
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    override func awakeFromNib() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func buttonMakePayment(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let compareController = storyboard.instantiateViewController(withIdentifier: "PaymentOptionController") as! PaymentOptionController
        self.show(compareController, sender: self)
    }
}

extension ReviewController : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.finalphotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCell", for: indexPath) as! ReviewCollection
        let result = self.finalphotos[indexPath.row]
        cell.image.image = result
        return cell;
    }
}
