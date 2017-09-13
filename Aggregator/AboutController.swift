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
    static var yom = String();
    static var date = String();
    static var price = String();
    static var name = String();
    static var age = String();
    static var mobileNumber = String();
    static var nationalID = String();
    static var email = String();
    static var Policy = String();
}

struct currentCompanySelected {
    static var companyName = String();
    static var totalPremium = String();
    static var policyStart = String();
    static var policyEnd = String();
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
    
    var selecteddate = ""
    var selectedprice = ""
    var selectedname = ""
    var selectedage = ""
    var selectedmobileNumber = ""
    var selectednationalID = ""
    var selectedemail = ""
    var selectedPolicy = ""
    var checkBoxSelected = false
    let constants = Constants()
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
    @IBAction func done(_ sender: Any) {
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
        } else{
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
            
           let userInfoDict: [String: String] =
            ["id" : userId,
             "full_name" : selectedname,
             "age" : selectedage,
             "mobile_no" : selectedmobileNumber,
             "national_id" : selectednationalID,
             "email" : selectedemail,
             "status" : "Incomplete",
             "company_id" : "0",
             "vehicle_usage" : selectedusageId,
             "usage_type" : selectedtypeID,
             "make" : selectedmakeID,
             "modal" : selectedmodelID,
             "variant" : selectedvariantID,
             "rto" : selectedrtoID,
             "year_of_manufacture" : selectedyom,
             "registration_date" : selecteddate,
             "price" : selectedprice]
            
            var params = "\(constants.BASE_URL)\("saveUser&")"
            for (key, value) in userInfoDict {
                params = params + "\(key)\("=")\(value)\("&")"
//                print("\(key): \(value)")
            }
            currentSelection.name = selectedname
            currentSelection.age = selectedage
            currentSelection.mobileNumber = selectedmobileNumber
            currentSelection.nationalID = selectednationalID
            currentSelection.email = selectedemail
            currentSelection.usageName = selectedusageName
            currentSelection.typeName = selectedtypeName
            currentSelection.makeName = selectedmakeName
            currentSelection.modelName = selectedmodelName
            currentSelection.variantName = selectedvariantName
            currentSelection.rtoName = selectedrtoName
            currentSelection.yom = selectedyom
            currentSelection.date = selecteddate
            currentSelection.price = selectedprice
            currentSelection.Policy = selectedPolicy
            
            let encodedHost = NSString(format: params as NSString).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            sendUserInfo(userDict: userInfoDict, params: encodedHost)
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
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: NSMakeRange(0,3))
        mobileNo.attributedText = attributedString
        
        addDoneButtonOnKeyboard()
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
                self.alertDialog (heading: "", message: message);
            default:
                self.alertDialog (heading: "", message: self.constants.errorMessage);
            }
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
                self.alertDialog (heading: "", message: message);
            default:
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
