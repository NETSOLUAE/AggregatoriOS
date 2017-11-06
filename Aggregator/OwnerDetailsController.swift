//
//  OwnerDetailsController.swift
//  Aggregator
//
//  Created by Mac Mini on 9/4/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit
import Photos
import CoreData
import Foundation

struct currentAddress {
    static var address = String();
}

class OwnerDetailsController: UIViewController, UITextViewDelegate {
    
    var finalphotos = [UIImage]()
    var allPhotos: PHFetchResult<PHAsset> = PHFetchResult()
    var fromInsurer = false
    let constants = Constants()
    let webserviceManager = WebserviceManager();
    let sharedInstance = CoreDataManager.sharedInstance;
    let managedContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
    let persistentContainer = NSPersistentContainer.init(name: "Aggregator")
    
    lazy var userInfoController: NSFetchedResultsController<USER_INFO> = {
        let fetchRequest: NSFetchRequest<USER_INFO> = USER_INFO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var mobile: UILabel!
    @IBOutlet weak var nationalID: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var thumbNailCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Compare and Apply"
        name.text = "\("Name: ")\(currentSelection.name)"
        age.text = "\("Age: ")\(currentSelection.age)"
        mobile.text = "\("Mobile No.: ")\(currentSelection.mobileNumber)"
        nationalID.text = "\("National ID: ")\(currentSelection.nationalID)"
        email.text = "\("Email: ")\(currentSelection.email)"
        address.delegate = self
        if (!fromInsurer) {
            thumbNailCollection.reloadData()
            fromInsurer = false
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        self.view.addGestureRecognizer(tap)
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                print("Good to proceed")
                let fetchOptions = PHFetchOptions()
                let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                print("Found \(allPhotos.count) images")
                if (allPhotos.count > 0) {
                    self.allPhotos = allPhotos
                }
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            }
        }
        
        if (currentAddress.address != "") {
            self.address.text = currentAddress.address
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = self.navigationController {
            var stacks = nav.viewControllers
            for stack in stacks {
                if (stack is ImageAttachmentController) {
                    if let index = stacks.index(of: stack) {
                        stacks.remove(at: index)
                        nav.setViewControllers(stacks, animated: true)
                    }
                }
                
            }
        }
    }
    
    func tapFunction(sender:UITapGestureRecognizer) {
        if (address.isFirstResponder) {
            address.resignFirstResponder()
            self.view.endEditing(true)
        }
    }
    
    override func awakeFromNib() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    @IBAction func buttonContinue(_ sender: Any) {
        self.view.endEditing(true)
        
        if (self.address.text != "") {
            currentAddress.address = self.address.text
        }
        
        if (finalphotos.count > 0) {
            LoadingIndicatorView.show("Please Wait..")
            let userID = self.getUserId(nationalID: currentSelection.nationalID)
            let params = "\(constants.BASE_URL)\("uploadImages&id=")\(userID)"
            self.sendDocuments(params: params)
        } else {
            self.alertDialog (heading: "", message: "Please upload your Documents.");
        }
    }
    @IBAction func camera(_ sender: Any) {
        
        if (self.address.text != "") {
            currentAddress.address = self.address.text
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let compareController = storyboard.instantiateViewController(withIdentifier: "ImageAttachmentController") as! ImageAttachmentController
        compareController.fromCamera = true
        compareController.finalphotos = finalphotos
        self.show(compareController, sender: self)
    }
    @IBAction func gallery(_ sender: Any) {
        
        if (self.address.text != "") {
            currentAddress.address = self.address.text
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let compareController = storyboard.instantiateViewController(withIdentifier: "ImageAttachmentController") as! ImageAttachmentController
        compareController.fromCamera = false
        compareController.finalphotos = finalphotos
        compareController.allPhotos = allPhotos
        self.show(compareController, sender: self)
    }
    
    func textViewShouldReturn(_ scoreText: UITextView) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func sendDocuments(params: String) -> Void {
        self.webserviceManager.sendDocuments(param: finalphotos, endPoint: params) { (result) in
            DispatchQueue.main.async {
                LoadingIndicatorView.hideInMain()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let compareController = storyboard.instantiateViewController(withIdentifier: "ReviewController") as! ReviewController
                compareController.addressOwner = self.address.text
                compareController.finalphotos = self.finalphotos
                self.show(compareController, sender: self)
            }
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
    
    func alertDialog (heading: String, message: String) {
        OperationQueue.main.addOperation {
            let alertController = UIAlertController(title: heading, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension OwnerDetailsController : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.finalphotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OwnerCell", for: indexPath) as! OwnerCollection
        let result = self.finalphotos[indexPath.row]
        cell.image.setBackgroundImage(result, for: .normal)
        cell.image.tag = indexPath.row
        cell.cellDelegate = self
        return cell;
    }
}

extension OwnerDetailsController : OwnerCollectionDelegate {
    func didPressButton(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let compareController = storyboard.instantiateViewController(withIdentifier: "ImageAttachmentController") as! ImageAttachmentController
        compareController.fromThumbNail = true
        compareController.finalphotos = finalphotos
        self.show(compareController, sender: self)
    }
}
