//
//  EECellSwipeGestureRecognizer.swift
//  EECellSwipeGestureRecognizer
//
//  Created by Enric Enrich on 02/01/16.
//  Copyright © 2016 Enric Enrich. All rights reserved.
//

import UIKit

open class EECellSwipeGestureRecognizer: UIPanGestureRecognizer, UIGestureRecognizerDelegate {

    // MARK: Properties
    
    open var isSwipeActive: Bool = false
    open var animationTime: TimeInterval = 0.2 // Default is 0.2
    
    fileprivate var leftActions: [EECellSwipeAction] = []
    fileprivate var rightActions: [EECellSwipeAction] = []
        
    fileprivate var actionView: EECellSwipeActionView = EECellSwipeActionView()
    
    // MARK: Initialize
    
    public init() {
        super.init(target: nil, action: nil)
        
        self.delegate = self
        self.addTarget(self, action: #selector(EECellSwipeGestureRecognizer.handlePan))
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let velocity: CGPoint = self.velocity(in: self.view)
        return fabs(velocity.x) > fabs(velocity.y)
    }
    
    // MARK: Actions
    
    @objc fileprivate func handlePan() {
        if let cell = self.cell {
            switch self.state {
            case .began:
                self.sortActions()
                
                if self.actionView.superview != nil {
                    self.actionView.removeFromSuperview()
                }
                
                cell.insertSubview(self.actionView, at: 0)
                
                self.actionView.frame = cell.contentView.bounds
                self.actionView.active = false
            case .changed:
                self.updateCellPosition()
                
                if let tableView = self.tableView, let backgroundColor = cell.contentView.backgroundColor, backgroundColor.cgColor.alpha == 0 {
                    cell.contentView.backgroundColor = tableView.backgroundColor
                }
                
                if self.isActiveForCurrentCellPosition() != self.actionView.active {
                    self.actionView.active = self.isActiveForCurrentCellPosition()
                    
                    if let didChangeState = self.actionView.action?.didChangeState, let action = self.actionView.action {
                        didChangeState(action, self.actionView.active)
                    }
                }
                
                if self.actionForCurrentCellPosition() != self.actionView.action {
                    self.actionView.action = self.actionForCurrentCellPosition()
                }
            case .ended:
                self.performAction()
            default:
                break
            }
        }
    }
    
    // MARK: Public API
    
    open func addActions(_ actions: Array<EECellSwipeAction>) {
        for action in actions {
            if action.fraction > 0 {
                self.leftActions.append(action)
            } else {
                self.rightActions.append(action)
            }
        }
    }
    
    open func removeActions(_ actions: Array<EECellSwipeAction>) {
        for action in actions {
            if action.fraction > 0 {
                if let index = self.leftActions.index(of: action) {
                    self.leftActions.remove(at: index)
                }
            } else {
                if let index = self.rightActions.index(of: action) {
                    self.rightActions.remove(at: index)
                }
            }
        }
    }
    
    open func removeLeftActions() {
        self.leftActions.removeAll()
    }
    
    open func removeRightActions() {
        self.rightActions.removeAll()
    }
    
    open func removeAllActions() {
        self.leftActions.removeAll()
        self.rightActions.removeAll()
    }
    
    open func swipeToOrigin(_ animated: Bool, completion: ((_ finished: Bool) -> Void)?) {
        self.translateCellHorizontally(0.0, animationDuration: animated ? self.animationTime : 0.0, completion: { (finished) -> Void in
            self.actionView.removeFromSuperview()
            
            if let completion = completion {
                completion(finished)
            }
        })
    }
    
    // MARK: Private API
    
    fileprivate var tableView: UITableView? {
        get {
            if let cell = self.cell {
                var view: UIView? = cell.superview
                
                while let unrappedView = view, (unrappedView is UITableView) == false {
                    view = unrappedView.superview
                }
                
                return view as? UITableView
            }
            
            return nil
        }
    }
    
    fileprivate var cell: UITableViewCell? {
        get {
            if let cell = self.view as? UITableViewCell {
                return cell
            }
            
            return nil
        }
    }
    
    fileprivate var indexPath: IndexPath? {
        get {
            if let tableView = self.tableView, let cell = self.cell {
                return tableView.indexPath(for: cell)
            }
            
            return nil
        }
    }
    
    fileprivate func currentHorizontalTranslation() -> CGFloat {
        if let cell = self.cell {
            var horizontalTranslation: CGFloat = self.translation(in: cell).x
            
            if (horizontalTranslation > 0 && self.leftActions.count == 0) || (horizontalTranslation < 0 && self.rightActions.count == 0) {
                horizontalTranslation = 0.0
            }
            
            return horizontalTranslation
        }
        
        return 0.0
    }
    
    fileprivate func sortActions() {
        self.leftActions.sort { (action1, action2) -> Bool in
            return action1.fraction > action2.fraction
        }
        
        self.rightActions.sort { (action1, action2) -> Bool in
            return action1.fraction < action2.fraction
        }
    }
    
    fileprivate func fractionForCurrentCellPosition() -> CGFloat {
        if let cell = self.cell {
            return cell.contentView.frame.origin.x / cell.contentView.frame.width
        }
        
        return 0.0
    }
    
    fileprivate func actionsForCurrentCellPosition() -> Array<EECellSwipeAction> {
        return self.fractionForCurrentCellPosition() > 0 ? self.leftActions : self.rightActions
    }
    
    fileprivate func actionForCurrentCellPosition() -> EECellSwipeAction? {
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
    
    fileprivate func isActiveForCurrentCellPosition() -> Bool {
        if let currentAction = self.actionForCurrentCellPosition() {
            return fabs(self.fractionForCurrentCellPosition()) >= fabs(currentAction.fraction)
        }
        
        return false
    }
    
    fileprivate func updateCellPosition() {
        let horizontalTranslation: CGFloat = self.currentHorizontalTranslation()
        
        if let cell = self.cell {
            self.actionView.cellDidUpdatePosition(cell)
        }
        
        self.translateCellHorizontally(horizontalTranslation)
    }
    
    fileprivate func translateCellHorizontally(_ horizontalTranslation: CGFloat) {
        if let cell = cell {
            cell.contentView.center = CGPoint(x: cell.contentView.frame.width / 2 + horizontalTranslation, y: cell.contentView.center.y)
        }
    }
    
    fileprivate func translateCellHorizontally(_ horizontalTranslation: CGFloat, animationDuration: TimeInterval, completion: ((_ finished: Bool) -> Void)?) {
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIViewAnimationOptions() , animations: { () -> Void in
            self.translateCellHorizontally(horizontalTranslation)
        }, completion: completion)
    }
    
    fileprivate func performAction() {
        if self.actionView.active {
            let horizontalTranslation = self.horizontalTranslationForActionBehavior()
            
            if let willTrigger = self.actionView.action?.willTrigger, let tableView = self.tableView, let indexPath = self.indexPath {
                willTrigger(tableView, indexPath)
            }
            
            self.translateCellHorizontally(horizontalTranslation, animationDuration: self.animationTime, completion: { (finished) -> Void in
                if self.actionView.action?.behavior == .pull {
                    self.actionView.removeFromSuperview()
                }
                
                if self.actionView.action?.behavior == .push {
                    self.isSwipeActive = true
                }
                
                if let didTrigger = self.actionView.action?.didTrigger, let tableView = self.tableView, let indexPath = self.indexPath {
                    didTrigger(tableView, indexPath)
                }
            })
        } else {
            self.isSwipeActive = false
            
            self.translateCellHorizontally(0.0, animationDuration: self.animationTime, completion: { (finished) -> Void in
                self.actionView.removeFromSuperview()
            })
        }
    }
    
    fileprivate func horizontalTranslationForActionBehavior() -> CGFloat {
        if let action = self.actionView.action, let cell = self.cell {
            return action.behavior == .pull ? 0 : cell.contentView.frame.width * (action.fraction / fabs(action.fraction))
        }
        
        return 0.0
    }
    
}
