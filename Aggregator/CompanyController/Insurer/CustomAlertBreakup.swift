//
//  CustomAlertBreakup.swift
//  Aggregator
//
//  Created by Mac Mini on 9/19/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit
import CoreData

class CustomAlertBreakup: UIViewController {
    let transitioner = CAVTransitioner()
    
    var covers = ""
    var headingText = ""
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self.transitioner
    }
    @IBOutlet weak var oldPin: UITextView!
    @IBOutlet weak var heading: UILabel!
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    @IBAction func doDismiss(_ sender:Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.oldPin.text = covers
        self.heading.text = headingText
    }
}
