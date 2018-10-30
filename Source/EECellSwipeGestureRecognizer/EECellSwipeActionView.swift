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
            if oldValue != self.active {
                self.tint()
            }
        }
    }
    open var action: EECellSwipeAction? {
        didSet {
            if let action = self.action {
                self.iconImageView.image = action.icon.withRenderingMode(.alwaysTemplate)
                self.iconImageView.contentMode = action.fraction >= 0 ? .left : .right
                
                self.tint()
                self.updateIconFrame()
            }
        }
    }
    
    fileprivate var iconImageView: UIImageView = UIImageView()
    
    // MARK: - Initialize
    
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(self.iconImageView)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API
    
    open func cellDidUpdatePosition(_ cell: UITableViewCell) {
        if let image = self.iconImageView.image, let action = self.action {
            self.updateIconFrame()
            self.iconImageView.alpha = abs(cell.contentView.frame.origin.x) / (image.size.width + action.iconMargin * 2)
        }
    }
    
    // MARK: - Private API
    
    fileprivate func updateIconFrame() {
        if let action = self.action {
            self.iconImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width - action.iconMargin * 2, height: self.frame.height)
            self.iconImageView.center = CGPoint(x: self.center.x, y: self.iconImageView.frame.height / 2)
        }
    }
    
    fileprivate func tint() {
        if let action = self.action {
            self.iconImageView.tintColor = self.active ? action.activeColor : action.inactiveColor
            self.backgroundColor = self.active ? action.activeBackgroundColor : action.inactiveBackgroundColor
        }
    }
    
}
