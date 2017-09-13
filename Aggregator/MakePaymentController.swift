//
//  MakePaymentController.swift
//  Aggregator
//
//  Created by Mac Mini on 9/7/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class MakePaymentController: UIViewController, UITextFieldDelegate {
    
    let constants = Constants()
    let webserviceManager = WebserviceManager()
    let sharedInstance = CoreDataManager.sharedInstance;
    let managedContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
    
    lazy var userInfoController: NSFetchedResultsController<USER_INFO> = {
        let fetchRequest: NSFetchRequest<USER_INFO> = USER_INFO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var expiry: UITextField!
    @IBOutlet weak var cvv: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var totalAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paddingView1 = UIView()
        paddingView1.frame = CGRect(x: 0, y: 0, width: 3, height: self.cardNumber.frame.size.height)
        cardNumber.leftView = paddingView1
        cardNumber.leftViewMode = UITextFieldViewMode.always
        
        let paddingView = UIView()
        paddingView.frame = CGRect(x: 0, y: 0, width: 3, height: self.cardNumber.frame.size.height)
        expiry.leftView = paddingView
        expiry.leftViewMode = UITextFieldViewMode.always
        
        let paddingView2 = UIView()
        paddingView2.frame = CGRect(x: 0, y: 0, width: 3, height: self.cardNumber.frame.size.height)
        cvv.leftView = paddingView2
        cvv.leftViewMode = UITextFieldViewMode.always
        
        let paddingView3 = UIView()
        paddingView3.frame = CGRect(x: 0, y: 0, width: 3, height: self.cardNumber.frame.size.height)
        name.leftView = paddingView3
        name.leftViewMode = UITextFieldViewMode.always
        
        self.title = "Make Payment"
        totalAmount.text = currentCompanySelected.totalPremium
        self.addDoneButtonOnKeyboard()
        cardNumber.delegate = self
        expiry.delegate = self
        cvv.delegate = self
        name.delegate = self
        self.cardNumber.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
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
    
    @IBAction func buttonContinue(_ sender: Any) {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM/yyyy"
        let someDate = expiry.text
        
        if (cardNumber.text == "" || expiry.text == "" || cvv.text == "" || name.text == "") {
            self.alertDialog(heading: "Alert", message: "All fileds are Mandatory")
        } else {
            if dateFormatterGet.date(from: someDate!) != nil {
                let date = Date.init(timeIntervalSinceNow: 1)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let startPolicy = dateFormatter.string(from: date)
                
                let expiryMonth = expiry.text?.substring(to: (expiry.text?.index((expiry.text?.startIndex)!, offsetBy: 2))!)
                
                let index = startPolicy.index(startPolicy.startIndex, offsetBy: 6)
                let currentYear = startPolicy.substring(from: index)
                
                let eindex = expiry.text?.index(startPolicy.startIndex, offsetBy: 3)
                let currenteYear = expiry.text?.substring(from: eindex!)
                
                if (Int(expiryMonth!)! > 12) {
                    self.alertDialog(heading: "Alert", message: "Please Enter Valid Date")
                } else if (Int(currenteYear!)! < Int(currentYear)!) {
                    self.alertDialog(heading: "Alert", message: "Please Enter Valid Date")
                } else {
                    LoadingIndicatorView.show("Redirecting...")
                    var userId = "0"
                    var results : [USER_INFO]
                    let studentUniversityFetchRequest: NSFetchRequest<USER_INFO>  = USER_INFO.fetchRequest()
                    let predicate = NSPredicate(format: "nationalID == %@", currentSelection.nationalID)
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
                         "full_name" : currentSelection.name,
                         "age" : currentSelection.age,
                         "mobile_no" :  currentSelection.mobileNumber,
                         "national_id" : currentSelection.nationalID,
                         "email" : currentSelection.email,
                         "status" : "Complete",
                         "company_id" : "0",
                         "vehicle_usage" : currentSelection.usageName,
                         "usage_type" : currentSelection.typeName,
                         "make" : currentSelection.makeName,
                         "modal" : currentSelection.modelName,
                         "variant" : currentSelection.variantName,
                         "rto" : currentSelection.rtoName,
                         "registration_date" : currentSelection.date,
                         "price" : currentSelection.price]
                    
                    var params = "\(constants.BASE_URL)\("saveUser&")"
                    for (key, value) in userInfoDict {
                        params = params + "\(key)\("=")\(value)\("&")"
                    }
                    let encodedHost = NSString(format: params as NSString).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    sendUserInfo(userDict: userInfoDict, params: encodedHost)
                }
                
            } else {
                self.alertDialog(heading: "Alert", message: "Please Enter Valid Date")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField === name) {
            self.view.endEditing(true)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        
        if(textField == cardNumber) {
            return newLength <= 19
        } else if (textField == expiry) {
            if range.length > 0 {
                return true
            }
            if string == " " {
                return false
            }
            if range.location >= 7 {
                return false
            }
            var originalText = textField.text
            if range.location == 2
            {
                originalText?.append("/")
                textField.text = originalText
            }
        }else if (textField == cvv) {
            return newLength <= 5
        }
        return true
    }
    
    func didChangeText(textField:UITextField) {
        textField.text = modifyCreditCardString(creditCardString: textField.text!)
    }
    
    func modifyCreditCardString(creditCardString : String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        
        let arrOfCharacters = Array(trimmedString.characters)
        
        var modifiedCreditCardString = ""
        
        if(arrOfCharacters.count > 0)
        {
            for i in 0...arrOfCharacters.count-1
            {
                modifiedCreditCardString.append(arrOfCharacters[i])
                
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count)
                {
                    
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.done, target: self, action: #selector(MakePaymentController.doneButtonAction))
        done.tintColor = .black
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        self.cardNumber.inputAccessoryView = doneToolbar
        self.expiry.inputAccessoryView = doneToolbar
        self.cvv.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction() {
        if (cardNumber.isFirstResponder) {
            cardNumber.resignFirstResponder()
            expiry.becomeFirstResponder()
        } else if (expiry.isFirstResponder) {
            expiry.resignFirstResponder()
            cvv.becomeFirstResponder()
        } else if (cvv.isFirstResponder) {
            cvv.resignFirstResponder()
            name.becomeFirstResponder()
        } else if (name.isFirstResponder) {
            self.view.endEditing(true)
        }
    }
    
    func sendUserInfo(userDict: [String: String], params: String) -> Void {
        self.webserviceManager.login(type: "double", endPoint: params) { (result) in
            LoadingIndicatorView.hideInMain()
            switch result {
            case .Success( _):
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let compareController = storyboard.instantiateViewController(withIdentifier: "ThankYouController") as! ThankYouController
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
            let alertController = UIAlertController(title: heading, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
