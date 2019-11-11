//
//  EECellSwipeActionView.swift
//  EECellSwipeGestureRecognizer
//
//  Created by Enric Enrich on 02/01/16.
//  Copyright © 2016 Enric Enrich. All rights reserved.
//

import UIKit

open class EECellSwipeActionView: UIView {

    // MARK: - Properties
    
    open var active: Bool = false {
        didSet {
            if oldValue != active {
                tint()
            }
        }
    }
    open var action: EECellSwipeAction? {
        didSet {
            if let action = self.action {
                iconImageView.image = action.icon.withRenderingMode(.alwaysTemplate)
                iconImageView.contentMode = action.fraction >= 0 ? .left : .right
                
                tint()
                updateIconFrame()
            }
        }
    }
    
    fileprivate var iconImageView: UIImageView = UIImageView()
    
    // MARK: - Initialize
    
    init() {
        super.init(frame: CGRect.zero)
        addSubview(iconImageView)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API
    
    open func cellDidUpdatePosition(_ cell: UITableViewCell) {
        if let image = iconImageView.image, let action = self.action {
            updateIconFrame()
            iconImageView.alpha = abs(cell.contentView.frame.origin.x) / (image.size.width + action.iconMargin * 2)
        }
    }
    
    // MARK: - Private API
    
    fileprivate func updateIconFrame() {
        if let action = self.action {
            iconImageView.frame = CGRect(x: 0, y: 0, width: frame.width - action.iconMargin * 2, height: frame.height)
            iconImageView.center = CGPoint(x: center.x, y: iconImageView.frame.height / 2)
        }
    }
    
    fileprivate func tint() {
        if let action = self.action {
            iconImageView.tintColor = active ? action.activeColor : action.inactiveColor
            backgroundColor = active ? action.activeBackgroundColor : action.inactiveBackgroundColor
        }
    }
    
}
