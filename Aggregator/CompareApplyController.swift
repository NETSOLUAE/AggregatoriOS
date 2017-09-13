//
//  CompareApplyController.swift
//  Aggregator
//
//  Created by Mac Mini on 8/28/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class CompareApplyController: ButtonBarPagerTabStripViewController {
    
    var isViewDidLaod = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        buttonBarItemSpec = ButtonBarItemSpec.nibFile(nibName: "ButtonBarView", bundle: Bundle(for: ButtonBarViewCell.self), width: { _ in
            return 55.0
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarHeight = 1.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        isHomeViewDidLoad = true
        
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.heading.textColor = UIColor.black
            newCell?.heading.textColor = UIColor.init(hex: "#ED1941")
        }
        isViewDidLaod = true
        
//        self.title = "Compare and Apply"
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
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let insurerController: UIViewController = storyboard.instantiateViewController(withIdentifier: "InsurerController") as UIViewController
        let personalDetailsController: UIViewController = storyboard.instantiateViewController(withIdentifier: "PersonalDetailsController") as UIViewController
        let vehicleDetailsController: UIViewController = storyboard.instantiateViewController(withIdentifier: "VehicleDetailsController") as UIViewController
        return [insurerController, personalDetailsController, vehicleDetailsController]
    }
}






















