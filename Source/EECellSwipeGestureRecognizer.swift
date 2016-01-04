//
//  EECellSwipeGestureRecognizer.swift
//  EECellSwipeGestureRecognizer
//
//  Created by Enric Enrich on 02/01/16.
//  Copyright © 2016 Enric Enrich. All rights reserved.
//

import UIKit

public class EECellSwipeGestureRecognizer: UIPanGestureRecognizer, UIGestureRecognizerDelegate {

    // MARK: Properties
    
    public var isSwipeActive: Bool = false
    public var animationTime: NSTimeInterval = 0.2 // Default is 0.2
    
    private var leftActions: Array<EECellSwipeAction> = []
    private var rightActions: Array<EECellSwipeAction> = []
        
    private var actionView: EECellSwipeActionView = EECellSwipeActionView()
    
    // MARK: Initialize
    
    public init() {
        super.init(target: nil, action: nil)
        
        self.delegate = self
        self.addTarget(self, action: "handlePan")
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let velocity: CGPoint = self.velocityInView(self.view)
        return fabs(velocity.x) > fabs(velocity.y)
    }
    
    // MARK: Actions
    
    @objc private func handlePan() {
        if let cell = self.cell {
            switch self.state {
            case .Began:
                self.sortActions()
                
                if self.actionView.superview != nil {
                    self.actionView.removeFromSuperview()
                }
                
                cell.insertSubview(self.actionView, atIndex: 0)
                
                self.actionView.frame = cell.contentView.bounds
                self.actionView.active = false
            case .Changed:
                self.updateCellPosition()
                
                if let tableView = self.tableView where CGColorGetAlpha(cell.contentView.backgroundColor?.CGColor) == 0 {
                    cell.contentView.backgroundColor = tableView.backgroundColor
                }
                
                if self.isActiveForCurrentCellPosition() != self.actionView.active {
                    self.actionView.active = self.isActiveForCurrentCellPosition()
                    
                    if let didChangeState = self.actionView.action?.didChangeState, let action = self.actionView.action {
                        didChangeState(action: action, active: self.actionView.active)
                    }
                }
                
                if self.actionForCurrentCellPosition() != self.actionView.action {
                    self.actionView.action = self.actionForCurrentCellPosition()
                }
            case .Ended:
                self.performAction()
            default:
                break
            }
        }
    }
    
    // MARK: Public API
    
    public func addActions(actions: Array<EECellSwipeAction>) {
        for action in actions {
            if action.fraction > 0 {
                self.leftActions.append(action)
            } else {
                self.rightActions.append(action)
            }
        }
    }
    
    public func removeActions(actions: Array<EECellSwipeAction>) {
        for action in actions {
            if action.fraction > 0 {
                if let index = self.leftActions.indexOf(action) {
                    self.leftActions.removeAtIndex(index)
                }
            } else {
                if let index = self.rightActions.indexOf(action) {
                    self.rightActions.removeAtIndex(index)
                }
            }
        }
    }
    
    public func removeLeftActions() {
        self.leftActions.removeAll()
    }
    
    public func removeRightActions() {
        self.rightActions.removeAll()
    }
    
    public func removeAllActions() {
        self.leftActions.removeAll()
        self.rightActions.removeAll()
    }
    
    public func swipeToOrigin(animated: Bool, completion: ((finished: Bool) -> Void)?) {
        self.translateCellHorizontally(0.0, animationDuration: animated ? self.animationTime : 0.0, completion: { (finished) -> Void in
            self.actionView.removeFromSuperview()
            
            if let completion = completion {
                completion(finished: finished)
            }
        })
    }
    
    // MARK: Private API
    
    private var tableView: UITableView? {
        get {
            if let cell = self.cell {
                var view: UIView? = cell.superview
                
                while let unrappedView = view where (unrappedView is UITableView) == false {
                    view = unrappedView.superview
                }
                
                return view as? UITableView
            }
            
            return nil
        }
    }
    
    private var cell: UITableViewCell? {
        get {
            if let cell = self.view as? UITableViewCell {
                return cell
            }
            
            return nil
        }
    }
    
    private var indexPath: NSIndexPath? {
        get {
            if let tableView = self.tableView, let cell = self.cell {
                return tableView.indexPathForCell(cell)
            }
            
            return nil
        }
    }
    
    private func currentHorizontalTranslation() -> CGFloat {
        if let cell = self.cell {
            var horizontalTranslation: CGFloat = self.translationInView(cell).x
            
            if (horizontalTranslation > 0 && self.leftActions.count == 0) || (horizontalTranslation < 0 && self.rightActions.count == 0) {
                horizontalTranslation = 0.0
            }
            
            return horizontalTranslation
        }
        
        return 0.0
    }
    
    private func sortActions() {
        self.leftActions.sortInPlace { (action1, action2) -> Bool in
            return action1.fraction > action2.fraction
        }
        
        self.rightActions.sortInPlace { (action1, action2) -> Bool in
            return action1.fraction < action2.fraction
        }
    }
    
    private func fractionForCurrentCellPosition() -> CGFloat {
        if let cell = self.cell {
            return cell.contentView.frame.origin.x / cell.contentView.frame.width
        }
        
        return 0.0
    }
    
    private func actionsForCurrentCellPosition() -> Array<EECellSwipeAction> {
        return self.fractionForCurrentCellPosition() > 0 ? self.leftActions : self.rightActions
    }
    
    private func actionForCurrentCellPosition() -> EECellSwipeAction? {
        let actions: Array<EECellSwipeAction> = self.actionsForCurrentCellPosition()
        var action: EECellSwipeAction? = actions.first
        
        for a in actions {
            if fabs(self.fractionForCurrentCellPosition()) > fabs(a.fraction) {
                action = a
            } else {
                break
            }
        }
        
        return action
    }
    
    private func isActiveForCurrentCellPosition() -> Bool {
        if let currentAction = self.actionForCurrentCellPosition() {
            return fabs(self.fractionForCurrentCellPosition()) >= fabs(currentAction.fraction)
        }
        
        return false
    }
    
    private func updateCellPosition() {
        let horizontalTranslation: CGFloat = self.currentHorizontalTranslation()
        
        if let cell = self.cell {
            self.actionView.cellDidUpdatePosition(cell)
        }
        
        self.translateCellHorizontally(horizontalTranslation)
    }
    
    private func translateCellHorizontally(horizontalTranslation: CGFloat) {
        if let cell = cell {
            cell.contentView.center = CGPointMake(cell.contentView.frame.width / 2 + horizontalTranslation, cell.contentView.center.y)
        }
    }
    
    private func translateCellHorizontally(horizontalTranslation: CGFloat, animationDuration: NSTimeInterval, completion: ((finished: Bool) -> Void)?) {
        UIView.animateWithDuration(animationDuration, delay: 0.0, options: .TransitionNone , animations: { () -> Void in
            self.translateCellHorizontally(horizontalTranslation)
        }, completion: completion)
    }
    
    private func performAction() {
        if self.actionView.active {
            let horizontalTranslation = self.horizontalTranslationForActionBehavior()
            
            if let willTrigger = self.actionView.action?.willTrigger, let tableView = self.tableView, let indexPath = self.indexPath {
                willTrigger(tableView: tableView, indexPath: indexPath)
            }
            
            self.translateCellHorizontally(horizontalTranslation, animationDuration: self.animationTime, completion: { (finished) -> Void in
                if self.actionView.action?.behavior == .Pull {
                    self.actionView.removeFromSuperview()
                }
                
                if self.actionView.action?.behavior == .Push {
                    self.isSwipeActive = true
                }
                
                if let didTrigger = self.actionView.action?.didTrigger, let tableView = self.tableView, let indexPath = self.indexPath {
                    didTrigger(tableView: tableView, indexPath: indexPath)
                }
            })
        } else {
            self.isSwipeActive = false
            
            self.translateCellHorizontally(0.0, animationDuration: self.animationTime, completion: { (finished) -> Void in
                self.actionView.removeFromSuperview()
            })
        }
    }
    
    private func horizontalTranslationForActionBehavior() -> CGFloat {
        if let action = self.actionView.action, let cell = self.cell {
            return action.behavior == .Pull ? 0 : cell.contentView.frame.width * (action.fraction / fabs(action.fraction))
        }
        
        return 0.0
    }
    
}
