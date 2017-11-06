//
//  WebPaymentController.swift
//  Aggregator
//
//  Created by Mac Mini on 10/8/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import UIKit

class WebPaymentController:UIViewController, UIWebViewDelegate {
    
    let constants = Constants();
    let webserviceManager = WebserviceManager();
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "http://netsolintl.net/aggrigator/payment.php"
        
        webView.loadRequest(NSURLRequest(url: NSURL(string: "http://netsolintl.net/aggrigator/payment.php")! as URL) as URLRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let text = webView.request?.url?.absoluteString{
            self.title = text
            if (text == "http://netsolintl.net/aggrigator/success.php") {
                self.alertDialog(heading: "Success", message: "Your Transaction has been successful.")
            } else if (text == "http://netsolintl.net/aggrigator/fail.php") {
                self.alertDialog(heading: "Error", message: "You have not completed your transaction.")
            }
            print(text)
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
