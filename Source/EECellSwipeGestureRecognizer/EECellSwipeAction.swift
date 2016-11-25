//
//  EECellSwipeAction.swift
//  EECellSwipeGestureRecognizer
//
//  Created by Enric Enrich on 02/01/16.
//  Copyright © 2016 Enric Enrich. All rights reserved.
//

import UIKit

@objc public enum EECellSwipeActionBehavior: Int {
    
    case pull
    case push
    
}

open class EECellSwipeAction: NSObject {

    // MARK: - Properties
    
    open var behavior: EECellSwipeActionBehavior
    open fileprivate(set) var fraction: CGFloat
    
    open var activeBackgroundColor: UIColor
    open var inactiveBackgroundColor: UIColor
    
    open var activeColor: UIColor
    open var inactiveColor: UIColor
    
    open var icon: UIImage
    open var iconMargin: CGFloat
    
    open var willTrigger: ((_ tableView: UITableView, _ indexPath: IndexPath) -> Void)?
    open var didTrigger: ((_ tableView: UITableView, _ indexPath: IndexPath) -> Void)?
    open var didChangeState: ((_ action: EECellSwipeAction, _ active: Bool) -> Void)?
    
    // MARK: Initialize
    
    public init(fraction: CGFloat) {
        self.behavior = .push
        self.icon = UIImage()
        self.fraction = fraction
        
        self.activeBackgroundColor = UIColor.blue
        self.inactiveBackgroundColor = UIColor(white: 0.94, alpha: 1.0)
        self.activeColor = UIColor.white
        self.inactiveColor = UIColor.white
        self.iconMargin = 25.0
        
        super.init()
    }
}
