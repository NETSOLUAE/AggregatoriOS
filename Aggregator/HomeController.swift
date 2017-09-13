//
//  HomeController.swift
//  Aggregator
//
//  Created by Mac Mini on 8/27/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class HomeController: UIViewController, UITextFieldDelegate {
    
    var usageId = ""
    var typeID = ""
    var makeID = ""
    var modelID = ""
    var variantID = ""
    var rtoID = ""
    
    var usageName = ""
    var typeName = ""
    var makeName = ""
    var modelName = ""
    var variantName = ""
    var rtoName = ""
    var year = ""
    
    var dateSelected = ""
    var activeField: UITextField?
    var isNewPolicy = true
    var yomList = [String]()
    let constants = Constants()
    let webserviceManager = WebserviceManager()
    let sharedInstance = CoreDataManager.sharedInstance;
    let managedContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
    let persistentContainer = NSPersistentContainer.init(name: "Aggregator")
    
    lazy var usageController: NSFetchedResultsController<VEHICLE_USAGE> = {
        let fetchRequest: NSFetchRequest<VEHICLE_USAGE> = VEHICLE_USAGE.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "usageName", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    lazy var typeController: NSFetchedResultsController<VEHICLE_TYPE> = {
        let fetchRequest: NSFetchRequest<VEHICLE_TYPE> = VEHICLE_TYPE.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "typeName", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    lazy var makeController: NSFetchedResultsController<VEHICLE_MAKE> = {
        let fetchRequest: NSFetchRequest<VEHICLE_MAKE> = VEHICLE_MAKE.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "makeName", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    lazy var modelController: NSFetchedResultsController<VEHICLE_MODEL> = {
        let fetchRequest: NSFetchRequest<VEHICLE_MODEL> = VEHICLE_MODEL.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "modelName", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    lazy var variantController: NSFetchedResultsController<VEHICLE_VARIANT> = {
        let fetchRequest: NSFetchRequest<VEHICLE_VARIANT> = VEHICLE_VARIANT.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "variantName", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    lazy var rtoController: NSFetchedResultsController<VEHICLE_RTO> = {
        let fetchRequest: NSFetchRequest<VEHICLE_RTO> = VEHICLE_RTO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rtoName", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    @IBOutlet weak var usageTable: UITableView!
    @IBOutlet weak var typeTable: UITableView!
    @IBOutlet weak var makeTable: UITableView!
    @IBOutlet weak var modelTable: UITableView!
    @IBOutlet weak var variantTable: UITableView!
    @IBOutlet weak var rtoTable: UITableView!
    @IBOutlet weak var yomTable: UITableView!
    @IBOutlet weak var usage: UIButton!
    @IBOutlet weak var type: UIButton!
    @IBOutlet weak var make: UIButton!
    @IBOutlet weak var model: UIButton!
    @IBOutlet weak var variant: UIButton!
    @IBOutlet weak var rto: UIButton!
    @IBOutlet weak var yom: UIButton!
    @IBOutlet weak var date: UIButton!
    @IBOutlet weak var newPolicy: UIButton!
    @IBOutlet weak var existingPolicy: UIButton!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateTool: UIToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    @IBAction func profilePressed(_ sender: Any) {
        self.slideMenuController()?.openLeft()
    }
    @IBAction func selectUsage(_ sender: Any) {
        self.usageTable.isHidden = !self.usageTable.isHidden
        self.typeTable.isHidden = true
        self.makeTable.isHidden = true
        self.modelTable.isHidden = true
        self.variantTable.isHidden = true
        self.rtoTable.isHidden = true
        self.yomTable.isHidden = true
        if (!self.usageTable.isHidden) {
            self.view.bringSubview(toFront: self.usageTable)
        }
    }
    @IBAction func selectType(_ sender: Any) {
        self.usageTable.isHidden = true
        self.typeTable.isHidden = !self.typeTable.isHidden
        self.makeTable.isHidden = true
        self.modelTable.isHidden = true
        self.variantTable.isHidden = true
        self.rtoTable.isHidden = true
        self.yomTable.isHidden = true
    }
    @IBAction func selectMake(_ sender: Any) {
        self.usageTable.isHidden = true
        self.typeTable.isHidden = true
        self.makeTable.isHidden = !self.makeTable.isHidden
        self.modelTable.isHidden = true
        self.variantTable.isHidden = true
        self.rtoTable.isHidden = true
        self.yomTable.isHidden = true
    }
    @IBAction func selectModel(_ sender: Any) {
        self.usageTable.isHidden = true
        self.typeTable.isHidden = true
        self.makeTable.isHidden = true
        self.modelTable.isHidden = !self.modelTable.isHidden
        self.variantTable.isHidden = true
        self.rtoTable.isHidden = true
        self.yomTable.isHidden = true
    }
    @IBAction func selectVariant(_ sender: Any) {
        self.usageTable.isHidden = true
        self.typeTable.isHidden = true
        self.makeTable.isHidden = true
        self.modelTable.isHidden = true
        self.variantTable.isHidden = !self.variantTable.isHidden
        self.rtoTable.isHidden = true
        self.yomTable.isHidden = true
    }
    @IBAction func selectRto(_ sender: Any) {
        self.usageTable.isHidden = true
        self.typeTable.isHidden = true
        self.makeTable.isHidden = true
        self.modelTable.isHidden = true
        self.variantTable.isHidden = true
        self.rtoTable.isHidden = !self.rtoTable.isHidden
        self.yomTable.isHidden = true
    }
    @IBAction func selectYom(_ sender: Any) {
        self.usageTable.isHidden = true
        self.typeTable.isHidden = true
        self.makeTable.isHidden = true
        self.modelTable.isHidden = true
        self.variantTable.isHidden = true
        self.yomTable.isHidden = !self.yomTable.isHidden
        self.rtoTable.isHidden = true
    }
    @IBAction func selectDate(_ sender: Any) {
        self.usageTable.isHidden = true
        self.typeTable.isHidden = true
        self.makeTable.isHidden = true
        self.modelTable.isHidden = true
        self.variantTable.isHidden = true
        self.rtoTable.isHidden = true
        self.yomTable.isHidden = true
        self.date.setTitle(self.dateSelected, for: .normal)
        self.datePicker.isHidden = !self.datePicker.isHidden
        self.dateTool.isHidden = !self.dateTool.isHidden
    }
    @IBAction func nextPressed(_ sender: Any) {
        if (self.usageId == "" || self.typeID == "" || self.makeID == "" || self.modelID == ""
            || self.variantID == "" || self.rtoID == "" || self.dateSelected == "" || self.price.text == "") {
            self.alertDialog (heading: "", message: "All fields are mandatory");
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let aboutController = storyboard.instantiateViewController(withIdentifier: "AboutController") as! AboutController
            aboutController.selectedusageId = self.usageId
            aboutController.selectedtypeID = self.typeID
            aboutController.selectedmakeID = self.makeID
            aboutController.selectedmodelID = self.modelID
            aboutController.selectedvariantID = self.variantID
            aboutController.selectedrtoID = self.rtoID
            aboutController.selectedusageName = self.usageName
            aboutController.selectedtypeName = self.typeName
            aboutController.selectedmakeName = self.makeName
            aboutController.selectedmodelName = self.modelName
            aboutController.selectedvariantName = self.variantName
            aboutController.selectedrtoName = self.rtoName
            aboutController.selectedyom = self.year
            aboutController.selecteddate = self.dateSelected
            aboutController.selectedprice = self.price.text ?? ""
            if (isNewPolicy) {
                aboutController.selectedPolicy = "New Policy"
            } else {
                aboutController.selectedPolicy = "Existing Policy"
            }
            self.show(aboutController, sender: self)
        }
    }
    
    @IBAction func dateSelected(_ sender: Any) {
    }
    @IBAction func done(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.string(from: datePicker.date)
        self.dateSelected = strDate
        self.date.setTitle(self.dateSelected, for: .normal)
        self.datePicker.isHidden = !self.datePicker.isHidden
        self.dateTool.isHidden = !self.dateTool.isHidden
    }
    @IBAction func cancel(_ sender: Any) {
        self.datePicker.isHidden = !self.datePicker.isHidden
        self.dateTool.isHidden = !self.dateTool.isHidden
    }
    @IBAction func newPolicySelected(_ sender: Any) {
        newPolicy.setBackgroundImage(UIImage(named: "radio-selected.png"), for: UIControlState.normal)
        existingPolicy.setBackgroundImage(UIImage(named: "radio.png"), for: UIControlState.normal)
        if (!isNewPolicy) {
            isNewPolicy = !isNewPolicy
        }
    }
    @IBAction func existingPolicySelected(_ sender: Any) {
        newPolicy.setBackgroundImage(UIImage(named: "radio.png"), for: UIControlState.normal)
        existingPolicy.setBackgroundImage(UIImage(named: "radio-selected.png"), for: UIControlState.normal)
        if (isNewPolicy) {
            isNewPolicy = !isNewPolicy
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        
        self.title = ""
        self.addLeftBarButtonWithImage(UIImage(named: "hamburger")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
        
        self.usage.layer.borderColor = UIColor(hex:"#e4e4e4", alpha: 1.0).cgColor
        self.type.layer.borderColor = UIColor(hex:"#e4e4e4", alpha: 1.0).cgColor
        self.make.layer.borderColor = UIColor(hex:"#e4e4e4", alpha: 1.0).cgColor
        self.model.layer.borderColor = UIColor(hex:"#e4e4e4", alpha: 1.0).cgColor
        self.variant.layer.borderColor = UIColor(hex:"#e4e4e4", alpha: 1.0).cgColor
        self.rto.layer.borderColor = UIColor(hex:"#e4e4e4", alpha: 1.0).cgColor
        self.yom.layer.borderColor = UIColor(hex:"#e4e4e4", alpha: 1.0).cgColor
        self.date.layer.borderColor = UIColor(hex:"#e4e4e4", alpha: 1.0).cgColor
        self.usageTable.isHidden = true
        self.typeTable.isHidden = true
        self.makeTable.isHidden = true
        self.modelTable.isHidden = true
        self.variantTable.isHidden = true
        self.rtoTable.isHidden = true
        self.yomTable.isHidden = true
        self.datePicker.isHidden = true
        self.dateTool.isHidden = true
        
        let paddingView1 = UIView()
        paddingView1.frame = CGRect(x: 0, y: 0, width: 3, height: self.price.frame.size.height)
        price.leftView = paddingView1
        price.leftViewMode = UITextFieldViewMode.always
        
        let date = Date.init(timeIntervalSinceNow: 1)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.string(from: date)
        self.dateSelected = strDate
        self.date.setTitle(self.dateSelected, for: .normal)
        self.datePicker.minimumDate = Date()
        
        self.datePicker.backgroundColor = UIColor(hex: "#EBEBEB")
        self.dateTool.backgroundColor = UIColor(hex: "#EBEBEB")
        
        let index = strDate.index(strDate.startIndex, offsetBy: 6)
        let currentYear = strDate.substring(from: index)
        
        var year = 0
        for var i in (0..<30).reversed()
        {
            if (i == 29) {
                year = Int(currentYear)!
                yomList.append(currentYear)
            } else {
                 year = year - 1
                yomList.append("\(year)")
            }
        }
        
        registerForKeyboardNotifications()
        self.scrollView.contentInset.bottom = scrollViewHeightConstraint.constant/4
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
//        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        deregisterFromKeyboardNotifications()
    }
    
    override func awakeFromNib() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height*1.8, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.contentInset.bottom = scrollViewHeightConstraint.constant/4
//        self.scrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
    
    func tapFunction(sender:UITapGestureRecognizer) {
        self.usageTable.isHidden = true
        self.typeTable.isHidden = true
        self.makeTable.isHidden = true
        self.modelTable.isHidden = true
        self.variantTable.isHidden = true
        self.rtoTable.isHidden = true
        self.yomTable.isHidden = true
    }
    
    func load(){
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            } else {
                do {
                    try self.usageController.performFetch()
                    try self.typeController.performFetch()
                    try self.makeController.performFetch()
                    try self.modelController.performFetch()
                    try self.variantController.performFetch()
                    try self.rtoController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
                
            }
        }
    }
    
    func getVehicleType(params: String) -> Void {
        self.webserviceManager.login(type: "double", endPoint: params) { (result) in
            self.hideActivityIndicator(view: self.view)
            switch result {
            case .Success(let data):
                self.sharedInstance.clearVehicleType()
                self.sharedInstance.saveInVehicleTypeWith(array: [data])
                self.type.titleLabel?.text = "Select Type"
                self.typeTable.reloadData()
            case .Error(let message):
                self.alertDialog (heading: "", message: message);
            default:
                self.alertDialog (heading: "", message: self.constants.errorMessage);
            }
        }
    }
    
    func getVehicleVariant(params: String) -> Void {
        self.webserviceManager.login(type: "double", endPoint: params) { (result) in
            self.hideActivityIndicator(view: self.view)
            switch result {
            case .Success(let data):
                self.sharedInstance.clearVehicleVariant()
                self.sharedInstance.saveInVehicleVariantWith(array: [data])
                self.variant.titleLabel?.text = "Select Variant"
                self.variantTable.reloadData()
            case .Error(let message):
                self.alertDialog (heading: "", message: message);
            default:
                self.alertDialog (heading: "", message: self.constants.errorMessage);
            }
        }
    }
    
    func showActivityIndicator(view: UIView, targetVC: UIViewController) {
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: targetVC.view.frame.width/2 - 25, y: targetVC.view.frame.height/2 - 150, width: 50, height: 50))
        activityIndicator.backgroundColor = UIColor.gray
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        activityIndicator.tag = 1
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func hideActivityIndicator(view: UIView) {
        let activityIndicator = view.viewWithTag(1) as? UIActivityIndicatorView
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func alertDialog (heading: String, message: String) {
        OperationQueue.main.addOperation {
            self.hideActivityIndicator(view: self.view)
            let alertController = UIAlertController(title: heading, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func updateModelController(makeID: String) {
        let predicate = NSPredicate(format: "makeID == %@", makeID)
        self.modelController.fetchRequest.predicate = predicate
        do {
            try self.modelController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        self.model.titleLabel?.text = "Select Model"
        self.modelTable.reloadData()
        
    }
    public func notification () {
        OperationQueue.main.addOperation {
            let vc = NotificationController()
            self.present(vc, animated: true)
        }
    }
}

extension HomeController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
    }
    
    func leftDidOpen() {
    }
    
    func leftWillClose() {
    }
    
    func leftDidClose() {
//        let menuItem = self.slideMenuController()?.menuItem
    }
    
    func rightWillOpen() {
    }
    
    func rightDidOpen() {
    }
    
    func rightWillClose() {
    }
    
    func rightDidClose() {
    }
}

extension HomeController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.usageTable {
            self.usageTable.isHidden = !self.usageTable.isHidden
            self.usage.imageEdgeInsets = UIEdgeInsets(top: 0, left: 129, bottom: 0, right: 5)
            let usage = usageController.object(at: indexPath)
            self.usageId = usage.usageID ?? ""
            self.usageName = usage.usageName ?? ""
            self.usage.setTitle(usageName, for: .normal)
            self.showActivityIndicator(view: self.view, targetVC: self)
            self.getVehicleType(params: "\(constants.VEHICLE_TYPE)\(self.usageId)")
            self.type.imageEdgeInsets = UIEdgeInsets(top: 0, left: 129, bottom: 0, right: 5)
            self.type.setTitle("Select Type", for: .normal)
        } else if tableView == self.typeTable{
            self.typeTable.isHidden = !self.typeTable.isHidden
            self.type.imageEdgeInsets = UIEdgeInsets(top: 0, left: 129, bottom: 0, right: 5)
            let type = typeController.object(at: indexPath)
            typeName = type.typeName ?? ""
            self.typeID = type.typeID ?? ""
            self.type.setTitle(typeName, for: .normal)
        } else if tableView == self.makeTable{
            self.makeTable.isHidden = !self.makeTable.isHidden
            self.make.imageEdgeInsets = UIEdgeInsets(top: 0, left: 129, bottom: 0, right: 5)
            let make = makeController.object(at: indexPath)
            makeName = make.makeName ?? ""
            self.makeID = make.makeID ?? ""
            self.make.setTitle(makeName, for: .normal)
            self.updateModelController(makeID: self.makeID)
            self.model.imageEdgeInsets = UIEdgeInsets(top: 0, left: 129, bottom: 0, right: 5)
            self.model.setTitle("Select Model", for: .normal)
            self.variant.imageEdgeInsets = UIEdgeInsets(top: 0, left: 300, bottom: 0, right: 5)
            self.variant.setTitle("Select Variant", for: .normal)
        } else if tableView == self.modelTable{
            self.modelTable.isHidden = !self.modelTable.isHidden
            self.model.imageEdgeInsets = UIEdgeInsets(top: 0, left: 129, bottom: 0, right: 5)
            let model = modelController.object(at: indexPath)
            modelName = model.modelName ?? ""
            self.modelID = model.modelID ?? ""
            self.model.setTitle(modelName, for: .normal)
            self.showActivityIndicator(view: self.view, targetVC: self)
            self.getVehicleVariant(params: "\(constants.VEHICLE_VARIANT)\(self.makeID)\("/")\(self.modelID)")
            self.variant.imageEdgeInsets = UIEdgeInsets(top: 0, left: 300, bottom: 0, right: 5)
            self.variant.setTitle("Select Variant", for: .normal)
        } else if tableView == self.variantTable{
            self.variantTable.isHidden = !self.variantTable.isHidden
            self.variant.imageEdgeInsets = UIEdgeInsets(top: 0, left: 300, bottom: 0, right: 5)
            let variant = variantController.object(at: indexPath)
            variantName = variant.variantName ?? ""
            self.variantID = variant.variantID ?? ""
            self.variant.setTitle(variantName, for: .normal)
            self.price.text = variant.price ?? ""
        } else if tableView == self.rtoTable{
            self.rtoTable.isHidden = !self.rtoTable.isHidden
            self.rto.imageEdgeInsets = UIEdgeInsets(top: 0, left: 300, bottom: 0, right: 5)
            let rto = rtoController.object(at: indexPath)
            rtoName = rto.rtoName ?? ""
            self.rtoID = rto.rtoID ?? ""
            self.rto.setTitle(rtoName, for: .normal)
        } else if tableView == self.yomTable{
            self.yomTable.isHidden = !self.yomTable.isHidden
            self.yom.imageEdgeInsets = UIEdgeInsets(top: 0, left: 129, bottom: 0, right: 5)
            let yom = yomList[indexPath.row]
            self.year = yom
            self.yom.setTitle(yom, for: .normal)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}

extension HomeController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.usageTable {
            guard let quotes = usageController.fetchedObjects else {
                return 0
            }
            return quotes.count
        } else if tableView == self.typeTable{
            guard let quotes = typeController.fetchedObjects else {
                return 0
            }
            let count = quotes.count
            return count
        } else if tableView == self.makeTable{
            guard let quotes = makeController.fetchedObjects else {
                return 0
            }
            return quotes.count
        } else if tableView == self.modelTable{
            guard let quotes = modelController.fetchedObjects else {
                return 0
            }
            return quotes.count
        } else if tableView == self.variantTable{
            guard let quotes = variantController.fetchedObjects else {
                return 0
            }
            return quotes.count
        } else if tableView == self.rtoTable{
            guard let quotes = rtoController.fetchedObjects else {
                return 0
            }
            return quotes.count
        } else if tableView == self.yomTable{
            return yomList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.usageTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Usage
            let usage = usageController.object(at: indexPath)
            cell.usage?.text = usage.usageName
            cell.selectionStyle = .none
            return cell
        } else if tableView == self.typeTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Type
            let type = typeController.object(at: indexPath)
            let typeName = type.typeName
            cell.type?.text = typeName
            cell.selectionStyle = .none
            return cell
        } else if tableView == self.makeTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Make
            let make = makeController.object(at: indexPath)
            cell.make?.text = make.makeName
            cell.selectionStyle = .none
            return cell
        } else if tableView == self.modelTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Model
            let model = modelController.object(at: indexPath)
            cell.model?.text = model.modelName
            cell.selectionStyle = .none
            return cell
        } else if tableView == self.variantTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Variant
            let variant = variantController.object(at: indexPath)
            let variantName = variant.variantName ?? ""
            let numCycle = variant.numCycle ?? ""
            cell.variant?.text = "\(variantName)\(" ( ")\(numCycle)\(" ) ")"
            cell.selectionStyle = .none
            return cell
        } else if tableView == self.rtoTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Rto
            let rto = rtoController.object(at: indexPath)
            cell.rto?.text = rto.rtoName
            cell.selectionStyle = .none
            return cell
        }  else if tableView == self.yomTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Yom
            let yom = yomList[indexPath.row]
            cell.yom?.text = yom
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Usage
            let usage = usageController.object(at: indexPath)
            cell.usage?.text = usage.usageName
            cell.selectionStyle = .none
            return cell
        }
    }
}

extension HomeController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == self.typeController {
            self.typeTable.beginUpdates()
        } else if controller == self.variantController {
            self.variantTable.beginUpdates()
        } else if controller == self.modelController {
            self.modelTable.beginUpdates()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == self.typeController {
            self.typeTable.endUpdates()
        } else if controller == self.variantController {
            self.variantTable.endUpdates()
        } else if controller == self.modelController {
            self.modelTable.endUpdates()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if controller == self.typeController {
                self.typeTable.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.automatic)
            } else if controller == self.variantController {
                self.variantTable.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.automatic)
            } else if controller == self.modelController {
                self.modelTable.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.automatic)
            }
        case .delete:
            if controller == self.typeController {
                self.typeTable.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
            } else if controller == self.variantController {
                self.variantTable.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
            } else if controller == self.modelController {
                self.modelTable.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
            }
        case .update:
            break
        // update cell at indexPath
        case .move:
            if controller == self.typeController {
                self.typeTable.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
                self.typeTable.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.automatic)
            } else if controller == self.variantController {
                self.variantTable.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
                self.variantTable.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.automatic)
            } else if controller == self.modelController {
                self.modelTable.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
                self.modelTable.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.automatic)
            }
        }
    }
}
