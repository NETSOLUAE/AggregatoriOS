//
//  MultiplePhotoCollection.swift
//  Aggregator
//
//  Created by Mac Mini on 9/6/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import Foundation
import UIKit

protocol MultiplePhotoDelegate : class {
    func didPressButton(sender: UIButton, image: UIImageView)
}

open class MultiplePhotoCollection: UICollectionViewCell {
    weak var cellDelegate: MultiplePhotoDelegate?
    
    @IBOutlet open var image: UIImageView!
    @IBOutlet open var checkBox: UIButton!
    @IBAction func photoPressed(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender: sender, image: image)
    }
}
