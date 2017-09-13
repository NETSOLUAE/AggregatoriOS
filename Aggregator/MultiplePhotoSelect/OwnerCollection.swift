//
//  OwnerCollection.swift
//  Aggregator
//
//  Created by Mac Mini on 9/6/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import Foundation
import UIKit

protocol OwnerCollectionDelegate : class {
    func didPressButton(sender: UIButton)
}

open class OwnerCollection: UICollectionViewCell {
    weak var cellDelegate: OwnerCollectionDelegate?
    
    @IBOutlet open var image: UIButton!
    @IBAction func thumbnailPressed(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender: sender)
    }
}
