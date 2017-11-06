//
//  ThankYouController.swift
//  Aggregator
//
//  Created by Mac Mini on 9/7/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ThankYouController: UIViewController {
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Thank You"
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
    
    @IBAction func buttonGoBack(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainViewController = storyboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
//        let leftMenuController = storyboard.instantiateViewController(withIdentifier: "LeftMenuController") as! LeftMenuController
//        let navigationController = storyboard.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController
//
//        leftMenuController.mainViewController = mainViewController
//        SlideMenuOptions.contentViewScale = 1
//        SlideMenuOptions.hideStatusBar = false;
//
//        let slideMenuController = ExSlideMenuController(mainViewController:navigationController, leftMenuViewController: leftMenuController)
//        slideMenuController.automaticallyAdjustsScrollViewInsets = true
//        slideMenuController.delegate = mainViewController
//
//        let appDelegate = UIApplication.shared.delegate
//        appDelegate?.window??.rootViewController = slideMenuController
//        appDelegate?.window??.makeKeyAndVisible()
//        self.present(navigationController, animated: true, completion: nil)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func buttonRate(_ sender: Any) {
    }
}
