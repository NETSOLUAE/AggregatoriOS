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
    weak var cellDelegate: CompareDelegate?
    
    @IBOutlet open var companyName: UILabel!
    @IBOutlet open var productName: UILabel!
    @IBOutlet open var primium: UILabel!
    @IBOutlet open var covers: UIView!
    @IBOutlet weak var coverHeading: UILabel!
    @IBOutlet open var attributes: UILabel!
    @IBOutlet open var fees: UILabel!
    @IBOutlet weak var tax: UILabel!
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
        covers.subviews.forEach { $0.removeFromSuperview() }
//        for subview in self.covers.subviews {
//            if subview is UIStackView {
//                subview.removeFromSuperview()
//            }
//        }
        super.prepareForReuse()
        //hide or reset anything you want hereafter, for example
    }
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        coverPremium.sizeToFit()
        attributes.sizeToFit()
        fees.sizeToFit()
    }
}
