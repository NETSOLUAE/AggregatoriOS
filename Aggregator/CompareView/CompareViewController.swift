//
//  CompareViewController.swift
//  Aggregator
//
//  Created by Mac Mini on 9/5/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class CompareViewController: UIViewController {
    
    var selectedCompanyProductID = [String]()
    var coverSelected = false
    var selectedCovers = [String]()
    var checkedCovers = [String]()
    var coverPremiumTextArray = [String]()
    var covertext = ""
    var attributeHeight = 0
    var feeHeight = 0
    var coverPremiumHeight = 0
    var finalHeight = 0
    let constants = Constants()
    let webserviceManager = WebserviceManager();
    var selectedCompanyDetails = [COMPANY_DETAILS]()
    var stackView = [UIStackView]()
    let sharedInstance = CoreDataManager.sharedInstance;
    let managedContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
    let persistentContainer = NSPersistentContainer.init(name: "Aggregator")
    
    lazy var coverController: NSFetchedResultsController<COMPANY_COVER> = {
        let fetchRequest: NSFetchRequest<COMPANY_COVER> = COMPANY_COVER.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "coverName", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    lazy var companyController: NSFetchedResultsController<COMPANY_DETAILS> = {
        let fetchRequest: NSFetchRequest<COMPANY_DETAILS> = COMPANY_DETAILS.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "totalPremium", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    lazy var userInfoController: NSFetchedResultsController<USER_INFO> = {
        let fetchRequest: NSFetchRequest<USER_INFO> = USER_INFO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Compare and Apply"
        load()
        let company = companyController.fetchedObjects
        var i = 0;
        for company in company! {
            if (selectedCompanyProductID.contains(company.productID!)) {
                selectedCompanyDetails.append(company)
                
                let coverDictionary: NSMutableDictionary = NSMutableDictionary()
                let coverPremiumText = company.coverPremium
                let coverArray =  coverPremiumText?.components(separatedBy: .newlines)
                for cover in coverArray! {
                    let key = cover.components(separatedBy: " :")
                    if let range = cover.range(of: ": ") {
                        let value = cover.substring(from: range.upperBound)
                        print(value)
                        coverDictionary.setValue(value, forKey: key[0].uppercased())
                    }
                    print(key)
                }
                var selectedCoverPremiumText = ""
                if let odValue = coverDictionary["OD"] {
                    i = i + 1
                    selectedCoverPremiumText = "\("OD : ")\(odValue)\("\n")"
                    print("Result error: \(odValue)")
                }
                if let tpValue = coverDictionary["TP"] {
                    i = i + 1
                    selectedCoverPremiumText = "\("TP : ")\(tpValue)\("\n")"
                    print("Result error: \(tpValue)")
                }
                for checkedCover in checkedCovers {
                    let coverID = self.getCoverIdByCoverName(coverName: checkedCover)
                    if (coverID != "OD" && coverID != "TP") {
                        if let coverValue = coverDictionary[coverID] {
                            i = i + 1
                            selectedCoverPremiumText = selectedCoverPremiumText + "\(coverID)\(" : ")\(coverValue)\("\n")"
                            print("Result error: \(coverValue)")
                        }
                    }
                }
                coverPremiumTextArray.append(selectedCoverPremiumText)
                
                let str = company.attribute!
                let count = str.characters.filter{$0 == "\n"}.count
                if (count > attributeHeight) {
                    attributeHeight = count
                }
                print("\("attributeHeight:")\(attributeHeight)") // 4
                let feestr = company.fees!
                let feecount = feestr.characters.filter{$0 == "\n"}.count
                if (feecount > feeHeight) {
                    feeHeight = feecount
                }
                print("\("feeHeight:")\(feeHeight)") // 4
//                let coverstr = company.coverPremium!
                let covercount = selectedCoverPremiumText.characters.filter{$0 == "\n"}.count
                if (covercount > coverPremiumHeight) {
                    if (covercount == 1) {
                        coverPremiumHeight = covercount + covercount
                    } else {
                        coverPremiumHeight = covercount
                    }
                }
                print("\("coverPremiumHeight:")\(coverPremiumHeight)") // 4
            }
        }
        for company in selectedCompanyDetails {
            self.getCoverNames(productID: company.productID!)
            let covers = coverController.fetchedObjects
            for cover in covers! {
                if (!selectedCovers.contains(cover.coverName!)) {
                    selectedCovers.append(cover.coverName!)
                    covertext = covertext + cover.coverName! + "\r"
                }
            }
        }
        finalHeight = 315+(attributeHeight*18)+(coverPremiumHeight*18)+(feeHeight*18)+((selectedCovers.count * 15) + (selectedCovers.count * 5))
//        loadStackView()
//        collectionView!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    
    func load(){
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            } else {
                do {
                    try self.coverController.performFetch()
                    try self.companyController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
                
            }
        }
    }
    
    func getCoverNames(productID: String) {
        let predicate = NSPredicate(format: "productID == %@", productID)
        self.coverController.fetchRequest.predicate = predicate
        do {
            try self.coverController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    func getUserId(nationalID: String) -> String {
        let predicate = NSPredicate(format: "nationalID == %@", nationalID)
        self.userInfoController.fetchRequest.predicate = predicate
        do {
            try self.userInfoController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        let userInfo = userInfoController.fetchedObjects
        let id = (userInfo?.first?.id) ?? ""
        return id
    }
    
    func getCoverIdByCoverName(coverName: String) -> String {
        let predicate = NSPredicate(format: "coverName == %@", coverName)
        self.coverController.fetchRequest.predicate = predicate
        do {
            try self.coverController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        let coverInfo = coverController.fetchedObjects
        let coverId = (coverInfo?.first?.coverID) ?? ""
        return coverId
    }
    
    func sendPolicyDetails(params: String) -> Void {
        self.webserviceManager.login(type: "double", endPoint: params) { (result) in
            LoadingIndicatorView.hideInMain()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let ownerDetailsController = storyboard.instantiateViewController(withIdentifier: "OwnerDetailsController") as! OwnerDetailsController
            ownerDetailsController.fromInsurer = true
            self.show(ownerDetailsController, sender: self)
        }
    }
    
    func loadStackView() -> Void {
        var i = 0
        for company in selectedCompanyDetails {
            self.getCoverNames(productID: company.productID!)
            let covers = self.coverController.fetchedObjects

            //Stack View Vertical
            let stackViewV   = UIStackView()
            stackViewV.tag = i
            stackViewV.axis  = UILayoutConstraintAxis.vertical
            stackViewV.distribution  = UIStackViewDistribution.equalSpacing
            stackViewV.alignment = UIStackViewAlignment.center
            stackViewV.spacing   = 5.0
            stackViewV.translatesAutoresizingMaskIntoConstraints = false

            for selectedCover in selectedCovers {
                let coverName = selectedCover
                var exist = false

                //Image View
                let imageView = UIImageView()
                imageView.backgroundColor = UIColor.clear
                imageView.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
                imageView.widthAnchor.constraint(equalToConstant: 12.0).isActive = true

                if (selectedCovers.count == covers?.count){
                    imageView.image = UIImage(named: "right")
                } else {
                    for cover in covers! {
                        let covername = cover.coverName
                        if (covername == coverName) {
                            exist = true
                            break
                        }
                    }
                    if (exist) {
                        imageView.image = UIImage(named: "right")
                    } else {
                        imageView.image = UIImage(named: "wrong")
                    }
                }

                //Text Label
                let textLabel = UILabel()
                textLabel.backgroundColor = UIColor.clear
                textLabel.font = UIFont.systemFont(ofSize: 12.0)
                textLabel.widthAnchor.constraint(equalToConstant: stackViewV.frame.width).isActive = true
                textLabel.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
                textLabel.text  = coverName
                textLabel.textAlignment = .left

                //Stack View Horizontal
                let stackView   = UIStackView()
                stackView.axis  = UILayoutConstraintAxis.horizontal
                stackView.distribution  = UIStackViewDistribution.equalSpacing
                stackView.alignment = UIStackViewAlignment.center
                stackView.spacing   = 8.0

                stackView.addArrangedSubview(imageView)
                stackView.addArrangedSubview(textLabel)
                stackView.translatesAutoresizingMaskIntoConstraints = false

                stackViewV.addArrangedSubview(stackView)
                stackViewV.translatesAutoresizingMaskIntoConstraints = false

                stackViewV.addSubview(stackView)
                self.stackView.append(stackViewV)
                i = i + 1
            }
        }
    }
}

extension CompareViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(finalHeight)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CompareTableViewCell
        cell.attributeHeight = attributeHeight
        cell.coverPremiumHeight = coverPremiumHeight
        cell.covertext = covertext
        cell.coverSelected = coverSelected
        cell.feeHeight = feeHeight
        cell.selectedCompanyProductID = selectedCompanyProductID
        cell.selectedCompanyDetails = selectedCompanyDetails
//        cell.stackView = stackView
        cell.selectedCovers = selectedCovers
        cell.coverPremiumTextArray = coverPremiumTextArray
        cell.buyDelegate = self
        return cell
    }
}

extension CompareViewController: BuyDelegate {
    func didBuyButtonPrssed(params: String) {
        self.sendPolicyDetails(params: params)
    }
}

extension CompareViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            break;
        case .delete:
            break;
        case .update:
            break;
        case .move:
            break;
        }
    }
}

extension UILabel {
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
}
