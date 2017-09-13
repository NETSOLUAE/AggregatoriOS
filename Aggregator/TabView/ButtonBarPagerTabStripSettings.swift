//
//  ButtonBarPagerTabStripSettings.swift
//  Aggregator
//
//  Created by Mac Mini on 8/30/17.
//  Copyright © 2017 Netsol. All rights reserved.
//

import Foundation
import UIKit

public enum ButtonBarItemSpec<CellType: UICollectionViewCell> {
    
    case nibFile(nibName: String, bundle: Bundle?, width:((IndicatorInfo)-> CGFloat))
    case cellClass(width:((IndicatorInfo)-> CGFloat))
    
    public var weight: ((IndicatorInfo) -> CGFloat) {
        switch self {
        case .cellClass(let widthCallback):
            return widthCallback
        case .nibFile(_, _, let widthCallback):
            return widthCallback
        }
    }
}

public struct ButtonBarPagerTabStripSettings {
    
    public struct Style {
        public var buttonBarBackgroundColor: UIColor?
        public var buttonBarMinimumInteritemSpacing: CGFloat?
        public var buttonBarMinimumLineSpacing: CGFloat?
        public var buttonBarLeftContentInset: CGFloat?
        public var buttonBarRightContentInset: CGFloat?
        
        public var selectedBarBackgroundColor = UIColor.init(hex: "#ED1941")
        public var selectedBarHeight: CGFloat = 1
        public var selectedBarVerticalAlignment: SelectedBarVerticalAlignment = .bottom
        
        public var buttonBarItemBackgroundColor: UIColor?
        public var buttonBarItemLeftRightMargin: CGFloat = 8
        public var buttonBarItemTitleColor = UIColor.black
        @available(*, deprecated: 7.0.0) public var buttonBarItemsShouldFillAvailiableWidth: Bool {
            set {
                buttonBarItemsShouldFillAvailableWidth = newValue
            }
            get {
                return buttonBarItemsShouldFillAvailableWidth
            }
        }
        public var buttonBarItemsShouldFillAvailableWidth = true
        // only used if button bar is created programaticaly and not using storyboards or nib files
        public var buttonBarHeight: CGFloat?
        public var buttonBarWidth: CGFloat?
    }
    
    public var style = Style()
}
