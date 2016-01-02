//
//  EECellSwipeActionView.swift
//  EECellSwipeGestureRecognizer
//
//  Created by Enric Enrich on 02/01/16.
//  Copyright © 2016 Enric Enrich. All rights reserved.
//

import UIKit

public class EECellSwipeActionView: UIView {

    // MARK: Properties
    
    public var active: Bool = false {
        didSet {
            if oldValue != self.active {
                self.tint()
            }
        }
    }
    public var action: EECellSwipeAction? {
        didSet {
            if let action = self.action {
                self.iconImageView.image = action.icon.imageWithRenderingMode(.AlwaysTemplate)
                self.iconImageView.contentMode = action.fraction >= 0 ? .Left : .Right
                
                self.tint()
                self.updateIconFrame()
            }
        }
    }
    
    private var iconImageView: UIImageView = UIImageView()
    
    // MARK: Initialize
    
    init() {
        super.init(frame: CGRectZero)
        self.addSubview(self.iconImageView)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public API
    
    public func cellDidUpdatePosition(cell: UITableViewCell) {
        if let image = self.iconImageView.image, let action = self.action {
            self.updateIconFrame()
            self.iconImageView.alpha = fabs(cell.frame.origin.x) / (image.size.width + action.iconMargin * 2)
        }
    }
    
    // MARK: Private API
    
    private func updateIconFrame() {
        if let action = self.action {
            self.iconImageView.frame = CGRectMake(0, 0, self.frame.width - action.iconMargin * 2, self.frame.height)
            self.iconImageView.center = CGPointMake(self.center.x, self.iconImageView.frame.height / 2)
        }
    }
    
    private func tint() {
        if let action = self.action {
            self.iconImageView.tintColor = self.active ? action.activeColor : action.inactiveColor
            self.backgroundColor = self.active ? action.activeBackgroundColor : action.inactiveBackgroundColor
        }
    }
    
}
