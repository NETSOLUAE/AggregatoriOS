//
//  AboutController.swift
//  Aggregator
//
//  Created by Mac Mini on 8/28/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit
import CoreData
import Foundation

struct currentSelection {
    static var usageName = String();
    static var typeName = String();
    static var makeName = String();
    static var modelName = String();
    static var variantName = String();
    static var rtoName = String();
    static var usageId = String();
    static var typeID = String();
    static var makeID = String();
    static var modelID = String();
    static var variantID = String();
    static var rtoID = String();
    static var yom = String();
    static var vehicleRegDate = String();
    static var insuranceStartDate = String();
    static var price = String();
    static var name = String();
    static var age = String();
    static var mobileNumber = String();
    static var nationalID = String();
    static var email = String();
    static var employer = String();
    static var Policy = String();
}

struct currentCompanySelected {
    static var companyProductID = String();
    static var companyName = String();
    static var totalPremium = String();
    static var policyStart = String();
    static var policyEnd = String();
    static var vehicleAge = String();
}

class AboutController: UIViewController, UITextFieldDelegate {
    
    var selectedusageId = ""
    var selectedtypeID = ""
    var selectedmakeID = ""
    var selectedmodelID = ""
    var selectedvariantID = ""
    var selectedrtoID = ""
    
    var selectedusageName = ""
    var selectedtypeName = ""
    var selectedmakeName = ""
    var selectedmodelName = ""
    var selectedvariantName = ""
    var selectedrtoName = ""
    var selectedyom = ""
    
    var selectedVehicleRegDate = ""
    var selectedPolicyStartDate = ""
    var selectedprice = ""
    var selectedname = ""
    var selectedage = ""
    var selectedmobileNumber = ""
    var selectednationalID = ""
    var selectedemail = ""
    var selectedemployer = ""
    var selectedPolicy = ""
    var checkBoxSelected = false
    var activeField: UITextField?
    let constants = Constants()
    var employerList = [String]()
    let webserviceManager = WebserviceManager()
    let sharedInstance = CoreDataManager.sharedInstance;
    let managedContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
    
    lazy var userInfoController: NSFetchedResultsController<USER_INFO> = {
        let fetchRequest: NSFetchRequest<USER_INFO> = USER_INFO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var mobileNo: UITextField!
    @IBOutlet weak var nationalId: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var terms: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var employerTable: UITableView!
    @IBOutlet weak var employer: UIButton!
    @IBAction func selectEmployer(_ sender: Any) {
        self.employerTable.isHidden = !self.employerTable.isHidden
    }
    @IBAction func done(_ sender: Any) {
        self.view.endEditing(true)
        deregisterFromKeyboardNotifications()
        self.employerTable.isHidden = true
        selectedname = self.firstName.text ?? ""
        selectedage = self.age.text ?? ""
        selectedmobileNumber = self.mobileNo.text ?? ""
        selectednationalID = self.nationalId.text ?? ""
        selectedemail = self.email.text ?? ""
        if (self.selectedname == ""
            || self.selectedage == ""
            || self.selectedmobileNumber == ""
            || self.selectednationalID == ""
            || self.selectedemail == "") {
            self.alertDialog (heading: "", message: "All fields are mandatory");
        } else if (selectedmobileNumber.length < 11) {
            self.alertDialog (heading: "", message: "Please enter valid mobile number");
        } else if !isValidEmail(email: selectedemail){
            self.alertDialog (heading: "", message: "Please enter valid Email address");
        } else if !checkBoxSelected{
            self.alertDialog (heading: "", message: "Please agree to the Terms and Condition");
        } else if (selectedage.length > 2){
            self.alertDialog (heading: "", message: "Please Enter Valid Age.");
        } else if (selectedemployer == "Select Employer" || selectedemployer == ""){
            self.alertDialog (heading: "", message: "Please Select Employer.");
        } else if (selectedemployer != "Other/None"){
            self.alertDialogCall ()
        } else {
            self.sendUser()
        }
    }
    @IBAction func checkBoxPressed(_ sender: Any) {
        checkBoxSelected = !checkBoxSelected
        if (checkBoxSelected) {
            terms.setBackgroundImage(UIImage(named: "checkbox-selected.png"), for: UIControlState.normal)
        } else {
            terms.setBackgroundImage(UIImage(named: "checkbox.png"), for: UIControlState.normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "RMS"
        
        let paddingView1 = UIView()
        paddingView1.frame = CGRect(x: 0, y: 0, width: 3, height: self.firstName.frame.size.height)
        firstName.leftView = paddingView1
        firstName.leftViewMode = UITextFieldViewMode.always
        
        let paddingView2 = UIView()
        paddingView2.frame = CGRect(x: 0, y: 0, width: 3, height: self.age.frame.size.height)
        age.leftView = paddingView2
        age.leftViewMode = UITextFieldViewMode.always
        
        let paddingView3 = UIView()
        paddingView3.frame = CGRect(x: 0, y: 0, width: 3, height: self.mobileNo.frame.size.height)
        mobileNo.leftView = paddingView3
        mobileNo.leftViewMode = UITextFieldViewMode.always
        
        let paddingView4 = UIView()
        paddingView4.frame = CGRect(x: 0, y: 0, width: 3, height: self.nationalId.frame.size.height)
        nationalId.leftView = paddingView4
        nationalId.leftViewMode = UITextFieldViewMode.always
        
        let paddingView5 = UIView()
        paddingView5.frame = CGRect(x: 0, y: 0, width: 3, height: self.email.frame.size.height)
        email.leftView = paddingView5
        email.leftViewMode = UITextFieldViewMode.always
        
        let attributedString = NSMutableAttributedString(string: "968")
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSMakeRange(0,3))
        mobileNo.attributedText = attributedString
        
        self.employer.layer.borderColor = UIColor(hex:"#e4e4e4", alpha: 1.0).cgColor
        self.employerTable.isHidden = true
        employerList.append("Select Employer")
        employerList.append("Al Mamary");
        employerList.append("ISS");
        employerList.append("MOD");
        employerList.append("Muscat Pharmacy");
        employerList.append("Private and Trade");
        employerList.append("ROP");
        employerList.append("Royal Office");
        employerList.append("Other/None");
        
        addDoneButtonOnKeyboard()
        registerForKeyboardNotifications()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.firstName.text = currentSelection.name
        self.age.text = currentSelection.age
        let mobile = currentSelection.mobileNumber
        self.nationalId.text = currentSelection.nationalID
        self.email.text = currentSelection.email
        if (self.selectedemployer == "") {
            self.selectedemployer = "Select Employer"
        }
        self.employer.setTitle(self.selectedemployer, for: .normal)
        
        if (mobile == "") {
            let attributedString = NSMutableAttributedString(string: "968")
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSMakeRange(0,3))
            mobileNo.attributedText = attributedString
        } else {
            let attributedString = NSMutableAttributedString(string: currentSelection.mobileNumber)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSMakeRange(0,3))
            mobileNo.attributedText = attributedString
        }
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        selectedname = self.firstName.text ?? ""
        selectedage = self.age.text ?? ""
        selectedmobileNumber = self.mobileNo.text ?? ""
        selectednationalID = self.nationalId.text ?? ""
        selectedemail = self.email.text ?? ""
        
        currentSelection.name = selectedname
        currentSelection.age = selectedage
        currentSelection.mobileNumber = selectedmobileNumber
        currentSelection.nationalID = selectednationalID
        currentSelection.email = selectedemail
        deregisterFromKeyboardNotifications()
    }
    
    override func awakeFromNib() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField === firstName) {
            firstName.resignFirstResponder()
            age.becomeFirstResponder()
        } else if (textField === email) {
            self.view.endEditing(true)
        }
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
        self.scrollView.contentInset.bottom = keyboardSize!.height
        //        self.scrollView.isScrollEnabled = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == mobileNo) {//This makes the new text black.
            textField.typingAttributes = [NSForegroundColorAttributeName:UIColor.black]
            let protectedRange = NSMakeRange(0, 3)
            let intersection = NSIntersectionRange(protectedRange, range)
            if intersection.length > 0 {
                
                return false
            }
            if range.location == 10 {
                return true
            }
            if range.location + range.length > 10 {
                return false
            }
            return true
        }
        return true
    }
    
    func sendUser() -> Void {
        LoadingIndicatorView.show("Getting Quotes..")
        var userId = "0"
        var results : [USER_INFO]
        let studentUniversityFetchRequest: NSFetchRequest<USER_INFO>  = USER_INFO.fetchRequest()
        let predicate = NSPredicate(format: "nationalID == %@", selectednationalID)
        self.userInfoController.fetchRequest.predicate = predicate
        studentUniversityFetchRequest.returnsObjectsAsFaults = false
        do {
            results = try self.managedContext.fetch(studentUniversityFetchRequest)
            if (results.count > 0 ) {
                userId = results.first!.id ?? "0"
            }
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        currentSelection.name = selectedname
        currentSelection.age = selectedage
        currentSelection.mobileNumber = selectedmobileNumber
        currentSelection.nationalID = selectednationalID
        currentSelection.email = selectedemail
        currentSelection.employer = selectedemployer
        currentSelection.usageName = selectedusageName
        currentSelection.typeName = selectedtypeName
        currentSelection.makeName = selectedmakeName
        currentSelection.modelName = selectedmodelName
        currentSelection.variantName = selectedvariantName
        currentSelection.rtoName = selectedrtoName
        currentSelection.usageId = selectedusageId
        currentSelection.typeID = selectedtypeID
        currentSelection.makeID = selectedmakeID
        currentSelection.modelID = selectedmodelID
        currentSelection.variantID = selectedvariantID
        currentSelection.rtoID = selectedrtoID
        currentSelection.yom = selectedyom
        currentSelection.vehicleRegDate = selectedVehicleRegDate
        currentSelection.insuranceStartDate = selectedPolicyStartDate
        currentSelection.price = selectedprice
        currentSelection.Policy = selectedPolicy
        
        let startPolicy = currentSelection.insuranceStartDate
        currentCompanySelected.policyStart = startPolicy
        
        let currentDate = startPolicy.substring(to: startPolicy.index(startPolicy.startIndex, offsetBy: 2))
        
        let start = startPolicy.index(startPolicy.startIndex, offsetBy: 3)
        let end = startPolicy.index(startPolicy.endIndex, offsetBy: -5)
        let range = start..<end
        
        let currentMonth = startPolicy.substring(with: range)
        
        let index = startPolicy.index(startPolicy.startIndex, offsetBy: 6)
        let currentYear = startPolicy.substring(from: index)
        
        var previousdate = "\(Int(currentDate)!)"
        var previousmonth = "\(Int(currentMonth)!)"
        if (previousdate.length == 1) {
            previousdate = "\("0")\(previousdate)"
        }
        if (previousmonth.length == 1) {
            previousmonth = "\("0")\(previousmonth)"
        }
        
        var nextYear = ""
        if (previousdate == "01" && previousmonth == "01") {
            nextYear = currentYear
            previousmonth = "\("12")"
            previousdate = "\("31")"
        } else if (previousdate == "01") {
            nextYear = "\(Int(currentYear)!+1)"
            previousmonth = "\(Int(currentMonth)!-1)"
            if (previousmonth == "03" || previousmonth == "05" || previousmonth == "07"
                || previousmonth == "08" || previousmonth == "10" || previousmonth == "12") {
                previousdate = "\("31")"
            } else if (previousmonth == "04" || previousmonth == "06" || previousmonth == "09"
                || previousmonth == "11") {
                previousdate = "\("30")"
            } else if (previousmonth == "02") {
                if Int(nextYear)! % 4 == 0 {
                    previousdate = "\("29")"
                    print("\(nextYear) is leap year")
                } else {
                    previousdate = "\("28")"
                    print("\(previousmonth) is normal year")
                }
            }
        } else {
            nextYear = "\(Int(currentYear)!+1)"
            previousdate = "\(Int(currentDate)!-1)"
            previousmonth = currentMonth
        }
        
        if (previousdate.length == 1) {
            previousdate = "\("0")\(previousdate)"
        }
        if (previousmonth.length == 1) {
            previousmonth = "\("0")\(previousmonth)"
        }
        let endYear = "\(previousdate)\("-")\(previousmonth)\("-")\(nextYear)"
        currentCompanySelected.policyEnd = endYear
        
        //Vehicle Age Calculation
        let date = Date.init(timeIntervalSinceNow: 1)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.string(from: date)
        
        let vindex = selectedVehicleRegDate.index(selectedVehicleRegDate.startIndex, offsetBy: 6)
        let vehicleYear = selectedVehicleRegDate.substring(from: vindex)
        let cindex = strDate.index(strDate.startIndex, offsetBy: 6)
        let currentyear = strDate.substring(from: cindex)
        let vehicleAge = Int(currentyear)! - Int(vehicleYear)!
        currentCompanySelected.vehicleAge = "\(vehicleAge)"
        
        let userInfoDict: [String: String] =
            ["id" : userId,
             "full_name" : selectedname,
             "age" : selectedage,
             "mobile_no" : selectedmobileNumber,
             "national_id" : selectednationalID,
             "email" : selectedemail,
             "employer" : selectedemployer,
             "status" : "Incomplete",
             "company_id" : "0",
             "vehicle_usage" : selectedusageName,
             "usage_type" : selectedtypeName,
             "make" : selectedmakeName,
             "modal" : selectedmodelName,
             "variant" : selectedvariantName,
             "rto" : selectedrtoName,
             "year_of_manufacture" : selectedyom,
             "registration_date" : selectedVehicleRegDate,
             "policy_start_date" : currentCompanySelected.policyStart,
             "policy_end_date" : currentCompanySelected.policyEnd,
             "vehicle_age" : currentCompanySelected.vehicleAge,
             "premiume_amount" : "0",
             "price" : selectedprice]
        
        var params = "\(constants.BASE_URL)\("saveUser&")"
        for (key, value) in userInfoDict {
            params = params + "\(key)\("=")\(value)\("&")"
            //                print("\(key): \(value)")
        }
        
        let encodedHost = NSString(format: params as NSString).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        sendUserInfo(userDict: userInfoDict, params: encodedHost)
        
    }
    
    func sendUserInfo(userDict: [String: String], params: String) -> Void {
        self.webserviceManager.login(type: "double", endPoint: params) { (result) in
            switch result {
            case .Success(let data):
                var userDic = userDict
                for (key, value) in userDic {
                    if (key == "id" && value == "0") {
                        for data in data {
                            for (key, value) in data {
                                let id = value as? Int ?? 0
                                userDic.updateValue("\(id)", forKey: key)
                            }
                        }
                    }
                }
                self.sharedInstance.createUserInfoEntityFrom(dictionary: userDic as [String : AnyObject])
                self.getVehicleDetails(userDict: userDic, params: self.constants.COMPANY_DETAILS);
            case .Error(let message):
                LoadingIndicatorView.hideInMain()
                self.alertDialog (heading: "", message: message);
            default:
                LoadingIndicatorView.hideInMain()
                self.alertDialog (heading: "", message: self.constants.errorMessage);
            }
//            self.selectedemployer = "Select Employeer"
//            self.employer.setTitle(self.selectedemployer, for: .normal)
        }
    }
    
    func getVehicleDetails(userDict: [String: String], params: String) -> Void {
        self.webserviceManager.getCompanyDetails(userInfoDict: userDict, endPoint: params) { (result) in
            switch result {
            case .Success(let data):
                let userInfo: [String:String] = [ "userName": self.selectedname, "phone": self.selectedmobileNumber]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logged"), object: userInfo)
                
                self.sharedInstance.clearCompanyDetails()
                self.sharedInstance.saveInCompanyDetailsWith(array: [data])
                LoadingIndicatorView.hideInMain()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let compareController = storyboard.instantiateViewController(withIdentifier: "CompareApplyController") as! CompareApplyController
                self.show(compareController, sender: self)
            case .Error(let message):
                LoadingIndicatorView.hideInMain()
                self.alertDialog (heading: "", message: message);
            default:
                LoadingIndicatorView.hideInMain()
                self.alertDialog (heading: "", message: self.constants.errorMessage);
            }
        }
    }
    
    func alertDialog (heading: String, message: String) {
        OperationQueue.main.addOperation {
            LoadingIndicatorView.hideInMain()
            let alertController = UIAlertController(title: heading, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func alertDialogCall () {
        let message = "\("RMS negotiated special rates for employees of ")\(selectedemployer)\(" company. Please contact +96824762679 for details. Continue to see off the shelf rates.")"
        OperationQueue.main.addOperation {
            let alert = UIAlertController(title: "",
                                          message: message,
                                          preferredStyle: .alert)
            // Change font of the title and message
//            let titleFont:[String : AnyObject] = [ NSFontAttributeName : UIFont(name: "AmericanTypewriter", size: 18)! ]
//            let attributedTitle = NSMutableAttributedString(string: "Action", attributes: titleFont)
//            alert.setValue(attributedTitle, forKey: "attributedTitle")
            
            // Continue button
            let call = UIAlertAction(title: "Call", style: .default, handler: { (action) -> Void in
                let url:NSURL = NSURL(string: "tel://" + "+96824762679")!
                if (UIApplication.shared.canOpenURL(url as URL))
                {
                    if let urlMobile = NSURL(string: "tel://" + "+96824762679"), UIApplication.shared.canOpenURL(urlMobile as URL) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(urlMobile as URL, options: [:], completionHandler: nil)
                        }
                        else {
                            UIApplication.shared.openURL(urlMobile as URL)
                        }
                    }
                }
            })
            
            // Continue button
            let cancel = UIAlertAction(title: "Continue", style: .default, handler: { (action) -> Void in
                self.selectedemployer = "Other/None"
                self.employer.setTitle(self.selectedemployer, for: .normal)
                self.sendUser()
            })
            
            // Restyle the view of the Alert
            //            alert.view.tintColor = UIColor.brown  // change text color of the buttons
            //            alert.view.backgroundColor = UIColor.cyan  // change background color
            alert.view.layer.cornerRadius = 25   // change corner radius
            // Add action buttons and present the Alert
            alert.addAction(cancel)
            alert.addAction(call)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        print("validate emilId: \(email)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.done, target: self, action: #selector(AboutController.doneButtonAction))
        done.tintColor = .black
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        self.age.inputAccessoryView = doneToolbar
        self.mobileNo.inputAccessoryView = doneToolbar
        self.nationalId.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction() {
        if (age.isFirstResponder) {
            age.resignFirstResponder()
            mobileNo.becomeFirstResponder()
        } else if (mobileNo.isFirstResponder) {
            mobileNo.resignFirstResponder()
            nationalId.becomeFirstResponder()
        } else if (nationalId.isFirstResponder) {
            nationalId.resignFirstResponder()
            email.becomeFirstResponder()
        }
    }
}

extension AboutController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.employerTable.isHidden = !self.employerTable.isHidden
        self.employer.imageEdgeInsets = UIEdgeInsets(top: 0, left: 340, bottom: 0, right: 10)
        let employer = employerList[indexPath.row]
        self.selectedemployer = employer
        self.employer.setTitle(selectedemployer, for: .normal)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}

extension AboutController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employercell", for: indexPath) as! Employer
        let employer = employerList[indexPath.row]
        cell.employer?.text = employer
        cell.selectionStyle = .none
        return cell
    }
}

extension AboutController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            break
        case .delete:
            break
        case .update:
            break
        // update cell at indexPath
        case .move:
            break
        }
    }
}
