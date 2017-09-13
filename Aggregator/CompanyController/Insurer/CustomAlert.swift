//
//  CustomAlert.swift
//  Aggregator
//
//  Created by Mac Mini on 9/9/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit
import CoreData

class CustomAlert: UIViewController {
    let transitioner = CAVTransitioner()
    
    var covers = ""
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self.transitioner
    }
    @IBOutlet weak var oldPin: UITextView!
    
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
    }
}
