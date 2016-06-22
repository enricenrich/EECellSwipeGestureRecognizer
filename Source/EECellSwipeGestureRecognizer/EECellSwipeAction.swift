//
//  EECellSwipeAction.swift
//  EECellSwipeGestureRecognizer
//
//  Created by Enric Enrich on 02/01/16.
//  Copyright © 2016 Enric Enrich. All rights reserved.
//

import UIKit

@objc public enum EECellSwipeActionBehavior: Int {
    
    case Pull
    case Push
    
}

public class EECellSwipeAction: NSObject {

    // MARK: Properties
    
    public var behavior: EECellSwipeActionBehavior
    public private(set) var fraction: CGFloat
    
    public var activeBackgroundColor: UIColor
    public var inactiveBackgroundColor: UIColor
    
    public var activeColor: UIColor
    public var inactiveColor: UIColor
    
    public var icon: UIImage
    public var iconMargin: CGFloat
    
    public var willTrigger: ((tableView: UITableView, indexPath: NSIndexPath) -> Void)?
    public var didTrigger: ((tableView: UITableView, indexPath: NSIndexPath) -> Void)?
    public var didChangeState: ((action: EECellSwipeAction, active: Bool) -> Void)?
    
    // MARK: Initialize
    
    public init(fraction: CGFloat) {
        self.behavior = .Push
        self.icon = UIImage()
        self.fraction = fraction
        
        self.activeBackgroundColor = UIColor.blueColor()
        self.inactiveBackgroundColor = UIColor(white: 0.94, alpha: 1.0)
        self.activeColor = UIColor.whiteColor()
        self.inactiveColor = UIColor.whiteColor()
        self.iconMargin = 25.0
        
        super.init()
    }
}
