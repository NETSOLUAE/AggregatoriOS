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
    var selectedCovers = [String]()
    var covertext = ""
    var attributeHeight = 0
    var feeHeight = 0
    var coverPremiumHeight = 0
    let constants = Constants()
    let webserviceManager = WebserviceManager();
    var selectedCompanyDetails = [COMPANY_DETAILS]()
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
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Compare and Apply"
        load()
        let company = companyController.fetchedObjects
        for company in company! {
            if (selectedCompanyProductID.contains(company.productID!)) {
                selectedCompanyDetails.append(company)
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
                let coverstr = company.coverPremium!
                let covercount = coverstr.characters.filter{$0 == "\n"}.count
                if (covercount > coverPremiumHeight) {
                    coverPremiumHeight = covercount
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
    
    func sendPolicyDetails(params: String) -> Void {
        self.webserviceManager.login(type: "double", endPoint: params) { (result) in
            LoadingIndicatorView.hideInMain()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let compareController = storyboard.instantiateViewController(withIdentifier: "OwnerDetailsController") as! OwnerDetailsController
            compareController.fromInsurer = true
            self.show(compareController, sender: self)
        }
    }
}
extension CompareViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCompanyDetails.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompareCell", for: indexPath) as! CompareCellView
        cell.attributeHeightConstraint.constant = CGFloat(attributeHeight * 18)
        cell.feesHeightConstraint.constant = CGFloat(feeHeight * 18)
        cell.coverPremiumHeightConstraint.constant = CGFloat(coverPremiumHeight * 18)
        cell.coverHeightConstraint.constant = CGFloat((selectedCovers.count * 15) + (selectedCovers.count * 5))
        let indexCount = indexPath.row
        print(indexCount)
        if (indexPath.row == 0) {
            cell.companyName.font = UIFont.systemFont(ofSize: 15.0)
            cell.companyName.text = "Company Name"
            cell.productName.text = "Product Name"
            cell.primium.text = "Primium"
            cell.attributes.text = "Attributes"
            cell.fees.text = "Fees"
            cell.coverPremium.text = "Cover Premium"
            cell.coverHeading.text = "Covers"
            cell.coverHeading.isHidden = false
            cell.buyButton.isHidden = true
            cell.covers.isHidden = true
        } else {
            cell.coverHeading.isHidden = true
            cell.covers.isHidden = false
            cell.buyButton.isHidden = false
            cell.companyName.font = UIFont.boldSystemFont(ofSize: 15.0)
            let company = selectedCompanyDetails[indexPath.row-1 ] as COMPANY_DETAILS
            cell.companyName.text = company.insurerName
            cell.productName.text = company.productName
            cell.primium.text = company.totalPremium
            cell.attributes.text = company.attribute
            cell.fees.text = company.fees
            cell.coverPremium.text = company.coverPremium
            cell.cellDelegate = self
            cell.buyButton.tag = indexPath.row-1
            
            getCoverNames(productID: company.productID!)
            let covers = coverController.fetchedObjects
            
            for view in cell.covers.subviews {
                if (view is UIStackView) {
                    if view.tag != indexPath.row {
                        view.removeFromSuperview()
                    }
                }
            }
            
            //Stack View Vertical
            let stackViewV   = UIStackView()
            stackViewV.tag = indexPath.row
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
                textLabel.font = UIFont.systemFont(ofSize: 15.0)
                textLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
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
            }
            
            cell.covers.addSubview(stackViewV)
            stackViewV.topAnchor.constraint(equalTo: cell.covers.topAnchor,
                                            constant: 5).isActive=true
            stackViewV.leftAnchor.constraint(equalTo: cell.covers.leftAnchor, constant: -5).isActive = true
        }
        return cell;
    }
}

extension CompareViewController : CompanyDelegate {
    func didPressButton(sender: UIButton) {
        LoadingIndicatorView.show("Fetching...")
        let indexPath = IndexPath(item: sender.tag, section: 0)
        var company: COMPANY_DETAILS;
        company = selectedCompanyDetails[indexPath.row] as COMPANY_DETAILS
        print("I have pressed a button with a tag: \(sender.tag)")
        
        currentCompanySelected.companyName = company.insurerName!
        currentCompanySelected.totalPremium = company.totalPremium!
        
        let date = Date.init(timeIntervalSinceNow: 1)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let startPolicy = dateFormatter.string(from: date)
        currentCompanySelected.policyStart = startPolicy
        
        let currentDate = startPolicy.substring(to: startPolicy.index(startPolicy.startIndex, offsetBy: 2))
        
        let start = startPolicy.index(startPolicy.startIndex, offsetBy: 3)
        let end = startPolicy.index(startPolicy.endIndex, offsetBy: -5)
        let range = start..<end
        
        let currentMonth = startPolicy.substring(with: range)  // play
        
        let index = startPolicy.index(startPolicy.startIndex, offsetBy: 6)
        let currentYear = startPolicy.substring(from: index)  // playground
        var previousdate = "\(Int(currentDate)!-1)"
        var previousmonth = "\(Int(currentMonth)!)"
        if (previousdate.length == 1) {
            previousdate = "\("0")\(previousdate)"
        }
        if (previousmonth.length == 1) {
            previousmonth = "\("0")\(previousmonth)"
        }
        let endYear = "\(previousdate)\("-")\(previousmonth)\("-")\((Int(currentYear)!+1))"
        currentCompanySelected.policyEnd = endYear
        
        let userId = getUserId(nationalID: currentSelection.nationalID)
        var params = ""
        params = params + "\(constants.BASE_URL)\("savePolicy&id=")\(userId)\("&company_id=")\(company.productID ?? "")"
        getCoverNames(productID: company.productID!)
        let covers = coverController.fetchedObjects
        var appendedCover = ""
        var i = 0
        for cover in covers! {
            let coverId = cover.coverID ?? ""
            let coverName = cover.coverName ?? ""
            appendedCover = appendedCover + "\("&add_ons[")\(i)\("][add_on_id]=")\(coverId)\("&add_ons[")\(i)\("][title]=")\(coverName)\("&add_ons[")\(i)\("][status]=Yes"))"
            i = i + 1
        }
        params = params + appendedCover
        let encodedHost = NSString(format: params as NSString).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.sendPolicyDetails(params: "\(encodedHost)")
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
