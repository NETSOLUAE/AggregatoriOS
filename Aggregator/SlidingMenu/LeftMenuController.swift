//
//  LeftMenuController.swift
//  Aggregator
//
//  Created by Mac Mini on 8/27/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case home = 0
    case notification
    case settings
    case others
    case aboutus
    case privacypolicy
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftMenuController : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var menus = ["Home", "Notification", "Settings", "Others", "About Us", "Privacy Policy"]
    var images = Array<UIImage>(arrayLiteral: UIImage(named: "home")!, UIImage(named: "notification")!, UIImage(named: "settings")!, UIImage(), UIImage(), UIImage())
    var mainViewController: UIViewController!
    var notificationController: UIViewController!
    var settingsController: UIViewController!
    var aboutUsController: UIViewController!
    var privacyPolicyController: UIViewController!
    var imageHeaderView: ImageHeaderView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        self.tableView.layoutMargins = UIEdgeInsets.zero
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        self.tableView.tableFooterView = UIView (frame: CGRect.zero)
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let notificationController = storyboard.instantiateViewController(withIdentifier: "NotificationController") as! NotificationController
        self.notificationController = UINavigationController(rootViewController: notificationController)
        
        let settingsController = storyboard.instantiateViewController(withIdentifier: "SettingsController") as! SettingsController
        self.settingsController = UINavigationController(rootViewController: settingsController)
        
        let aboutUsController = storyboard.instantiateViewController(withIdentifier: "AboutUsController") as! AboutUsController
        self.aboutUsController = UINavigationController(rootViewController: aboutUsController)
        
        let privacyPolicyController = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyController") as! PrivacyPolicyController
        self.privacyPolicyController = UINavigationController(rootViewController: privacyPolicyController)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .home:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true, menuItem: "home")
        case .notification:
            self.slideMenuController()?.changeMainViewController(self.notificationController, close: true, menuItem: "notification")
        case .settings:
            self.slideMenuController()?.changeMainViewController(self.settingsController, close: true, menuItem: "settings")
        case .aboutus:
            self.slideMenuController()?.changeMainViewController(self.aboutUsController, close: true, menuItem: "aboutus")
        case .others:
            self.slideMenuController()?.closeLeft()
        case .privacypolicy:
            self.slideMenuController()?.changeMainViewController(self.privacyPolicyController, close: true, menuItem: "privacypolicy")
        }
    }
}

extension LeftMenuController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .home, .notification, .settings, .others, .aboutus, .privacypolicy:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftMenuController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .home, .notification, .settings, .others, .aboutus, .privacypolicy:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row], images[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}
