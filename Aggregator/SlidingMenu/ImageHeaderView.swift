//
//  ImageHeaderView.swift
//  Aggregator
//
//  Created by Mac Mini on 8/27/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ImageHeaderView : UIView {
    
    @IBOutlet weak var phonenumber: UILabel!
    @IBOutlet weak var name: UILabel!
    let sharedInstance = CoreDataManager.sharedInstance;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 221/255.0, green: 0/255.0, blue: 19/255.0, alpha: 1.0)
        NotificationCenter.default.addObserver(self, selector: #selector(ImageHeaderView.setName(notification:)), name: NSNotification.Name(rawValue: "logged"), object: nil)
    }
    
    func setName(notification: NSNotification) {
        if let userInfo = notification.object as? [String:AnyObject] {
            if let loggedUserName = userInfo["userName"] as? String {
                print(loggedUserName)
                name.text = loggedUserName
            }
            if let loggedPhone = userInfo["phone"] as? String {
                print(loggedPhone)
                phonenumber.text = loggedPhone
            }
        }
        
    }
}
