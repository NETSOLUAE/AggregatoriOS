//
//  LaunchScreen.swift
//  Aggregator
//
//  Created by Mac Mini on 8/27/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit

class LaunchScreen: UIViewController {
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var logo: UIImageView!
    
    var window: UIWindow?
    let constants = Constants()
    let webserviceManager = WebserviceManager()
    let sharedInstance = CoreDataManager.sharedInstance;
    let managedContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progress.startAnimating()
        self.sharedInstance.clearUserInfo()
        self.getVehicleUsage(params: "\(constants.VEHICLE_USAGE)")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getVehicleUsage(params: String) -> Void {
        self.webserviceManager.login(type: "double", endPoint: params) { (result) in
            switch result {
            case .Success(let data):
                self.sharedInstance.clearVehicleUsage()
                self.sharedInstance.saveInVehicleUsageWith(array: [data])
                self.getVehicleMake(params: "\(self.constants.VEHICLE_MAKE)")
            case .Error(let message):
                self.alertDialog (heading: "", message: message);
            default:
                self.alertDialog (heading: "", message: self.constants.errorMessage);
            }
        }
    }
    
    func getVehicleMake(params: String) -> Void {
        self.webserviceManager.login(type: "double", endPoint: params) { (result) in
            switch result {
            case .Success(let data):
                self.sharedInstance.clearVehicleMake()
                self.sharedInstance.saveInVehicleMakeWith(array: [data])
                self.getVehicleModel(params: "\(self.constants.VEHICLE_MODEL)")
            case .Error(let message):
                self.alertDialog (heading: "", message: message);
            default:
                self.alertDialog (heading: "", message: self.constants.errorMessage);
            }
        }
    }
    
    func getVehicleModel(params: String) -> Void {
        self.webserviceManager.login(type: "double", endPoint: params) { (result) in
            switch result {
            case .Success(let data):
                self.sharedInstance.clearVehicleModel()
                self.sharedInstance.saveInVehicleModelWith(array: [data])
                self.getVehicleRto(params: "\(self.constants.VEHICLE_RTO)")
            case .Error(let message):
                self.alertDialog (heading: "", message: message);
            default:
                self.alertDialog (heading: "", message: self.constants.errorMessage);
            }
        }
    }
    
    func getVehicleRto(params: String) -> Void {
        self.webserviceManager.login(type: "double", endPoint: params) { (result) in
            self.progress.stopAnimating()
            switch result {
            case .Success(let data):
                self.sharedInstance.clearRto()
                self.sharedInstance.saveInRtoWith(array: [data])
                self.progress.stopAnimating()
                UIView.animate(withDuration: 1.0, delay: 0.5, animations: {
                    self.logo.transform = CGAffineTransform(scaleX: 1.5,y: 1.5);
                    self.logo.alpha = 0.0
                }, completion: { (finished: Bool) in
                    self.callMainViewController()
                })
            case .Error(let message):
                self.alertDialog (heading: "", message: message);
            default:
                self.alertDialog (heading: "", message: self.constants.errorMessage);
            }
        }
    }
    
    func alertDialog (heading: String, message: String) {
        OperationQueue.main.addOperation {
            self.progress.stopAnimating()
            let alertController = UIAlertController(title: heading, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func callMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
        let leftMenuController = storyboard.instantiateViewController(withIdentifier: "LeftMenuController") as! LeftMenuController
        let navigationController = storyboard.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController
        
        leftMenuController.mainViewController = navigationController
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.hideStatusBar = false;
        
        let slideMenuController = ExSlideMenuController(mainViewController:navigationController, leftMenuViewController: leftMenuController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = slideMenuController
        appDelegate?.window??.makeKeyAndVisible()
        self.present(navigationController, animated: true, completion: nil)
        
        
        
        // create viewController code...
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        let mainViewController = storyboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
//        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftMenuController") as! LeftMenuController
//        
//        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
//        
//        UINavigationBar.appearance().tintColor = UIColor(hex: "ffffff")
//        
//        leftViewController.mainViewController = nvc
//        
//        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
//        slideMenuController.automaticallyAdjustsScrollViewInsets = true
//        slideMenuController.delegate = mainViewController
//        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
//        self.window?.rootViewController = slideMenuController
//        self.window?.makeKeyAndVisible()
//        self.present(nvc, animated: true, completion: nil)
    }
}
