//
//  InsurerController.swift
//  Aggregator
//
//  Created by Mac Mini on 8/30/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class InsurerController: UIViewController, IndicatorInfoProvider {
    
    var uniqueCovers = [String]()
    var selectedCovers = [String]()
    var selectedCompanyProductID = [String]()
    var selectedCompanyDetails = [COMPANY_DETAILS]()
    var isAllQuotes = true
    var tagValue = 0
    var itemInfo: IndicatorInfo = IndicatorInfo(title: "Insurers")
    let constants = Constants()
    let webserviceManager = WebserviceManager();
    let sharedInstance = CoreDataManager.sharedInstance;
    let managedContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
    let persistentContainer = NSPersistentContainer.init(name: "Aggregator")
    
    lazy var coverController: NSFetchedResultsController<COMPANY_COVER> = {
        let fetchRequest: NSFetchRequest<COMPANY_COVER> = COMPANY_COVER.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "coverName", ascending: true)]
        fetchRequest.returnsDistinctResults = true
        fetchRequest.propertiesToFetch = ["coverName"]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    lazy var companyController: NSFetchedResultsController<COMPANY_DETAILS> = {
        let fetchRequest: NSFetchRequest<COMPANY_DETAILS> = COMPANY_DETAILS.fetchRequest()
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "insurerName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
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
    
    @IBOutlet weak var detailHeading: UILabel!
    @IBOutlet weak var detailPremium: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var coverButton: UIButton!
    @IBOutlet weak var allQuotes: UIButton!
    @IBOutlet weak var lowest5: UIButton!
    @IBOutlet weak var detailPrevious: UIButton!
    @IBOutlet weak var detailNext: UIButton!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var coverTable: UITableView!
    @IBOutlet weak var companyTable: UITableView!
    @IBAction func selectCover(_ sender: Any) {
        coverView.isHidden = !coverView.isHidden
    }
    @IBAction func previous(_ sender: Any) {
        if (tagValue > 0) {
            tagValue = tagValue - 1
            let indexPath = IndexPath(item: tagValue, section: 0)
            var company: COMPANY_DETAILS;
            var size = 0
            if (selectedCompanyDetails.count > 0) {
                company = selectedCompanyDetails[indexPath.row] as COMPANY_DETAILS
                size = selectedCompanyDetails.count
            } else {
                company = companyController.object(at: indexPath)
                size = (companyController.fetchedObjects?.count)!
            }
            print("I have pressed a button with a tag: \(tagValue)")
            detailView.isHidden = false
            if (tagValue == 0) {
                self.detailPrevious.isHidden = true
                self.detailNext.isHidden = false
            } else if (tagValue == size-1) {
                self.detailNext.isHidden = true
                self.detailPrevious.isHidden = false
            } else {
                self.detailNext.isHidden = false
                self.detailPrevious.isHidden = false
            }
            self.detailPremium.text = company.totalPremium
            self.detailHeading.text = company.insurerName
            
        }
    }
    @IBAction func next(_ sender: Any) {
        var size = 0
        if (selectedCompanyDetails.count > 0) {
            size = selectedCompanyDetails.count
        } else {
            size = (companyController.fetchedObjects?.count)!
        }
        if (tagValue < size) {
            tagValue = tagValue + 1
            let indexPath = IndexPath(item: tagValue, section: 0)
            var company: COMPANY_DETAILS;
            var size = 0
            if (selectedCompanyDetails.count > 0) {
                company = selectedCompanyDetails[indexPath.row] as COMPANY_DETAILS
                size = selectedCompanyDetails.count
            } else {
                company = companyController.object(at: indexPath)
                size = (companyController.fetchedObjects?.count)!
            }
            print("I have pressed a button with a tag: \(tagValue)")
            detailView.isHidden = false
            if (tagValue == 0) {
                self.detailPrevious.isHidden = true
                self.detailNext.isHidden = false
            } else if (tagValue == size-1) {
                self.detailNext.isHidden = true
                self.detailPrevious.isHidden = false
            } else {
                self.detailNext.isHidden = false
                self.detailPrevious.isHidden = false
            }
            self.detailPremium.text = company.totalPremium
            self.detailHeading.text = company.insurerName
            
        }
    }
    @IBAction func showCoverDetails(_ sender: Any) {
        let indexPath = IndexPath(item: tagValue, section: 0)
        var company: COMPANY_DETAILS;
        if (selectedCompanyDetails.count > 0) {
            company = selectedCompanyDetails[indexPath.row] as COMPANY_DETAILS
        } else {
            company = companyController.object(at: indexPath)
        }
        getCoverNames(productID: company.productID!)
        let covers = coverController.fetchedObjects
        var appendedCover = ""
        for cover in covers! {
            appendedCover = appendedCover + "- " + cover.coverName! + "\n"
        }
        
        self.coveralertDialog(heading: "Cover Details", message: appendedCover)
    }
    @IBAction func detailBuy(_ sender: Any) {
        LoadingIndicatorView.show("Fetching..")
        let indexPath = IndexPath(item: tagValue, section: 0)
        var company: COMPANY_DETAILS;
        if (selectedCompanyDetails.count > 0) {
            company = selectedCompanyDetails[indexPath.row] as COMPANY_DETAILS
        } else {
            company = companyController.object(at: indexPath)
        }
        
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
        
        let currentMonth = startPolicy.substring(with: range)
        
        let index = startPolicy.index(startPolicy.startIndex, offsetBy: 6)
        let currentYear = startPolicy.substring(from: index)
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
    @IBAction func detailBack(_ sender: Any) {
        detailView.isHidden = true
    }
    @IBAction func allQuotesSelected(_ sender: Any) {
        allQuotes.setBackgroundImage(UIImage(named: "radio-selected.png"), for: UIControlState.normal)
        lowest5.setBackgroundImage(UIImage(named: "radio.png"), for: UIControlState.normal)
        if (!isAllQuotes) {
            isAllQuotes = !isAllQuotes
            self.selectedCompanyDetails.removeAll()
            self.selectedCompanyProductID.removeAll()
            self.selectedCovers.removeAll()
            self.coverTable.reloadData()
        }
        self.companyTable.reloadData()
    }
    @IBAction func lowest5Selected(_ sender: Any) {
        allQuotes.setBackgroundImage(UIImage(named: "radio.png"), for: UIControlState.normal)
        lowest5.setBackgroundImage(UIImage(named: "radio-selected.png"), for: UIControlState.normal)
        if (isAllQuotes) {
            isAllQuotes = !isAllQuotes
            self.selectedCompanyDetails.removeAll()
            self.selectedCompanyProductID.removeAll()
            self.selectedCovers.removeAll()
            self.coverTable.reloadData()
        }
        self.companyTable.reloadData()
    }
    @IBAction func done(_ sender: Any) {
        coverView.isHidden = !coverView.isHidden
    }
    @IBAction func compare(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let compareController = storyboard.instantiateViewController(withIdentifier: "CompareViewController") as! CompareViewController
        compareController.selectedCompanyProductID = selectedCompanyProductID
        self.show(compareController, sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.coverTable.register(CoverTable.self, forCellReuseIdentifier: "Cell")
        self.coverButton.layer.borderColor = UIColor(hex:"#e4e4e4", alpha: 1.0).cgColor
        coverView.isHidden = true
        detailView.isHidden = true
        self.companyTable.separatorStyle = UITableViewCellSeparatorStyle.none
        load()
        
        var coverName = [String]()
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "COMPANY_COVER")
            if let results = try managedContext.fetch(fetchRequest) as? [COMPANY_COVER] {
                
                if !results.isEmpty {
                    for x in results {
                        coverName.append(x.coverName!)
                    }
                }
            }
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        uniqueCovers = Array(Set(coverName))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
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
        LoadingIndicatorView.hideInMain()
        self.webserviceManager.login(type: "double", endPoint: params) { (result) in
            switch result {
            default:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let compareController = storyboard.instantiateViewController(withIdentifier: "OwnerDetailsController") as! OwnerDetailsController
                compareController.fromInsurer = true
                self.show(compareController, sender: self)
            }
        }
    }
    
    func coveralertDialog (heading: String, message: String) {
        OperationQueue.main.addOperation {
            
            let vc = CustomAlert()
            vc.covers = message
            self.present(vc, animated: true)
        }
    }
    
    func alertDialog (heading: String, message: String) {
        OperationQueue.main.addOperation {
            let alertController = UIAlertController(title: heading, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension InsurerController: NSFetchedResultsControllerDelegate {
    
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

extension InsurerController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.coverTable {
            return 44
        } else {
            return 72
        }
    }
    
    // click cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if tableView == self.coverTable {
            allQuotes.setBackgroundImage(UIImage(named: "radio-selected.png"), for: UIControlState.normal)
            lowest5.setBackgroundImage(UIImage(named: "radio.png"), for: UIControlState.normal)
            if (!isAllQuotes) {
                isAllQuotes = !isAllQuotes
            }
            let cell = tableView.cellForRow(at: indexPath) as! CoverTable
            if (selectedCovers.contains(uniqueCovers[indexPath.row])) {
                cell.checkBox.setBackgroundImage(UIImage(named: "checkbox.png"), for: UIControlState.normal)
                let removableCoverName = uniqueCovers[indexPath.row]
                if let index = selectedCovers.index(of: removableCoverName) {
                    selectedCovers.remove(at: index)
                }
                for company in selectedCompanyDetails {
                    var isExist = false
                    self.getCoverNames(productID: company.productID!)
                    let covers = coverController.fetchedObjects
                    for cover in covers! {
                        let coverName = cover.coverName
                        if (selectedCovers.contains(coverName!)) {
                            isExist = true
                            break
                        }
                    }
                    if (!isExist) {
                        for cover in covers! {
                            let coverName = cover.coverName
                            if (coverName == removableCoverName) {
                                let index = selectedCompanyDetails.index(of: company)
                                selectedCompanyDetails.remove(at: index!)
                                break
                            }
                        }
                        
                    }
                }
            } else {
                selectedCovers.append(uniqueCovers[indexPath.row])
                cell.checkBox.setBackgroundImage(UIImage(named: "checkbox-selected.png"), for: UIControlState.normal)
                let company = companyController.fetchedObjects
                for company in company! {
                    self.getCoverNames(productID: company.productID!)
                    var companyExist = false
                    let covers = coverController.fetchedObjects
                    for cover in covers! {
                        let coverName = cover.coverName
                        if (coverName == uniqueCovers[indexPath.row]) {
                            for selectedCompany in selectedCompanyDetails {
                                if (selectedCompany.productID == company.productID) {
                                    companyExist = true
                                }
                            }
                            if (!companyExist) {
                                selectedCompanyDetails.append(company)
                            }
                        }
                    }
                }
            }
            self.companyTable.reloadData()
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! CompanyTable
            let company = companyController.object(at: indexPath)
            let productId = company.productID ?? ""
            if (selectedCompanyProductID.contains(productId)) { 
                selectedCompanyProductID.remove(at: indexPath.row)
                cell.checkBoxSelected.setBackgroundImage(UIImage(named: "checkbox.png"), for: UIControlState.normal)
            } else {
                selectedCompanyProductID.append(productId)
                cell.checkBoxSelected.setBackgroundImage(UIImage(named: "checkbox-selected.png"), for: UIControlState.normal)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension InsurerController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.coverTable {
            return uniqueCovers.count
        } else {
            if (isAllQuotes) {
                if (selectedCompanyDetails.count > 0) {
                    return selectedCompanyDetails.count
                } else {
                    guard let quotes = companyController.fetchedObjects else {
                        return 0
                    }
                    return quotes.count
                }
            } else {
                if (selectedCompanyDetails.count > 5 || selectedCompanyDetails.count == 0) {
                    return 5
                } else {
                    return selectedCompanyDetails.count
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.coverTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellCover", for: indexPath) as! CoverTable
            let name = uniqueCovers[indexPath.row]
            cell.name?.text = name
            if (selectedCovers.contains(name)) {
                cell.checkBox.setBackgroundImage(UIImage(named: "checkbox-selected.png"), for: UIControlState.normal)
            } else {
                cell.checkBox.setBackgroundImage(UIImage(named: "checkbox.png"), for: UIControlState.normal)
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CompanyTable
            var company: COMPANY_DETAILS;
            if (selectedCompanyDetails.count > 0) {
                company = selectedCompanyDetails[indexPath.row] as COMPANY_DETAILS
            } else {
                company = companyController.object(at: indexPath)
            }
            cell.cellDelegate = self
            cell.companyName?.text = company.insurerName
            cell.premium?.text = company.totalPremium
            cell.view.tag = indexPath.row
            let productId = company.productID ?? ""
            if (selectedCompanyProductID.contains(productId)) {
                cell.checkBoxSelected.setBackgroundImage(UIImage(named: "checkbox-selected.png"), for: UIControlState.normal)
            } else {
                cell.checkBoxSelected.setBackgroundImage(UIImage(named: "checkbox.png"), for: UIControlState.normal)
            }
            cell.companyView.layer.borderColor = UIColor(hex:"#e4e4e4", alpha: 1.0).cgColor
            cell.selectionStyle = .none
            return cell
        }
    }
}

extension InsurerController : CompanyDelegate {
    func didPressButton(sender: UIButton) {
        tagValue = sender.tag
        let indexPath = IndexPath(item: tagValue, section: 0)
        var company: COMPANY_DETAILS;
        var size = 0
        if (selectedCompanyDetails.count > 0) {
            company = selectedCompanyDetails[indexPath.row] as COMPANY_DETAILS
            size = selectedCompanyDetails.count
        } else {
            company = companyController.object(at: indexPath)
            size = (companyController.fetchedObjects?.count)!
        }
        print("I have pressed a button with a tag: \(tagValue)")
        detailView.isHidden = false
        if (tagValue == 0) {
            self.detailPrevious.isHidden = true
            self.detailNext.isHidden = false
        } else if (tagValue == size-1) {
            self.detailNext.isHidden = true
            self.detailPrevious.isHidden = false
        } else {
            self.detailNext.isHidden = false
            self.detailPrevious.isHidden = false
        }
        self.detailPremium.text = company.totalPremium
        self.detailHeading.text = company.insurerName
    }
}
