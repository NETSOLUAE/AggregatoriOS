//
//  CompareCellView.swift
//  Aggregator
//
//  Created by Mac Mini on 9/5/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import Foundation
import UIKit

protocol CompareDelegate : class {
    func didPressButton(sender: UIButton)
}

open class CompareCellView: UICollectionViewCell {
    weak var cellDelegate: CompanyDelegate?
    
    @IBOutlet open var companyName: UILabel!
    @IBOutlet open var productName: UILabel!
    @IBOutlet open var primium: UILabel!
    @IBOutlet open var covers: UIView!
    @IBOutlet weak var coverHeading: UILabel!
    @IBOutlet open var attributes: UILabel!
    @IBOutlet open var fees: UILabel!
    @IBOutlet weak var coverPremium: UILabel!
    @IBOutlet weak var coverHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var attributeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var feesHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var coverPremiumHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buyButton: UIButton!
    
    @IBAction func buyPressed(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender: sender)
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        //hide or reset anything you want hereafter, for example
        
    }
    
//    func createCovers(index: Int) -> UIStackView {
//        
//        let company = selectedCompanyDetails[index] as COMPANY_DETAILS
//        getCoverNames(productID: company.productID!)
//        let covers = coverController.fetchedObjects
//        
//        //Stack View Vertical
//        let stackViewV   = UIStackView()
//        stackViewV.axis  = UILayoutConstraintAxis.vertical
//        stackViewV.distribution  = UIStackViewDistribution.equalSpacing
//        stackViewV.alignment = UIStackViewAlignment.center
//        stackViewV.spacing   = 5.0
//        stackViewV.translatesAutoresizingMaskIntoConstraints = false
//        stackViewV.tag = index
//        
//        for selectedCover in selectedCovers {
//            let coverName = selectedCover
//            var exist = false
//            
//            //Image View
//            let imageView = UIImageView()
//            imageView.backgroundColor = UIColor.clear
//            imageView.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
//            imageView.widthAnchor.constraint(equalToConstant: 12.0).isActive = true
//            
//            if (selectedCovers.count == covers?.count){
//                imageView.image = UIImage(named: "right")
//            } else {
//                for cover in covers! {
//                    let covername = cover.coverName
//                    if (covername == coverName) {
//                        exist = true
//                        break
//                    }
//                }
//                if (exist) {
//                    imageView.image = UIImage(named: "right")
//                } else {
//                    imageView.image = UIImage(named: "wrong")
//                }
//            }
//            
//            //Text Label
//            let textLabel = UILabel()
//            textLabel.backgroundColor = UIColor.clear
//            textLabel.font = UIFont.systemFont(ofSize: 15.0)
//            textLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
//            textLabel.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
//            textLabel.text  = coverName
//            textLabel.textAlignment = .left
//            
//            //Stack View Horizontal
//            let stackView   = UIStackView()
//            stackView.axis  = UILayoutConstraintAxis.horizontal
//            stackView.distribution  = UIStackViewDistribution.equalSpacing
//            stackView.alignment = UIStackViewAlignment.center
//            stackView.spacing   = 8.0
//            
//            stackView.addArrangedSubview(imageView)
//            stackView.addArrangedSubview(textLabel)
//            stackView.translatesAutoresizingMaskIntoConstraints = false
//            
//            stackViewV.addArrangedSubview(stackView)
//            stackViewV.translatesAutoresizingMaskIntoConstraints = false
//            
//            stackViewV.addSubview(stackView)
//        }
//        return stackViewV
//    }
}
