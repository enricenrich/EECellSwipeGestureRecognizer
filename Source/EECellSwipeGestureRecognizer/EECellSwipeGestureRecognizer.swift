//
//  EECellSwipeGestureRecognizer.swift
//  EECellSwipeGestureRecognizer
//
//  Created by Enric Enrich on 02/01/16.
//  Copyright © 2016 Enric Enrich. All rights reserved.
//

import UIKit

open class EECellSwipeGestureRecognizer: UIPanGestureRecognizer {

    // MARK: - Properties
    
    open var animationTime: TimeInterval = 0.2 // Default is 0.2
    open var isSwipeActive = false
    
    private var leftActions = [EECellSwipeAction]()
    private var rightActions = [EECellSwipeAction]()
        
    private var actionView = EECellSwipeActionView()
    
    private var originalContentViewBackgroundColor: UIColor?
    
    // MARK: - Initialize
    
    public init() {
        super.init(target: nil, action: nil)
        
        if #available(iOS 13.4, *) {
            allowedScrollTypesMask = .continuous
        }
        
        delegate = self
        addTarget(self, action: #selector(EECellSwipeGestureRecognizer.handlePan))
    }
    
    // MARK: - Actions
    
    @objc private func handlePan() {
        guard let cell = self.cell else {
            return
        }
        
        switch state {
        case .began:
            sortActions()
            
            if actionView.superview != nil {
                actionView.removeFromSuperview()
            }
            
            cell.insertSubview(actionView, at: 0)
            
            actionView.frame = cell.contentView.bounds
            actionView.active = false

            originalContentViewBackgroundColor = cell.contentView.backgroundColor
        case .changed:
            updateCellPosition()
            updateContentViewBackgroundColor()
            
            if isActiveForCurrentCellPosition() != actionView.active {
                actionView.active = isActiveForCurrentCellPosition()
                
                if let didChangeState = actionView.action?.didChangeState, let action = actionView.action {
                    didChangeState(action, actionView.active)
                }
            }
            
            if actionForCurrentCellPosition() != actionView.action {
                actionView.action = actionForCurrentCellPosition()
            }
        case .ended:
            performAction {
                self.updateContentViewBackgroundColor()
            }
        default:
            break
        }
    }
    
    // MARK: - Public API
    
    open func add(actions: [EECellSwipeAction]) {
        for action in actions {
            if action.fraction > 0 {
                leftActions.append(action)
            } else {
                rightActions.append(action)
            }
        }
    }
    
    open func remove(actions: [EECellSwipeAction]) {
        for action in actions {
            if action.fraction > 0 {
                if let index = leftActions.firstIndex(of: action) {
                    leftActions.remove(at: index)
                }
            } else {
                if let index = rightActions.firstIndex(of: action) {
                    rightActions.remove(at: index)
                }
            }
        }
    }
    
    open func removeLeftActions() {
        leftActions.removeAll()
    }
    
    open func removeRightActions() {
        rightActions.removeAll()
    }
    
    open func removeAllActions() {
        leftActions.removeAll()
        rightActions.removeAll()
    }
    
    open func swipeToOrigin(animated: Bool, completion: ((_ finished: Bool) -> Void)?) {
        translateCellHorizontally(0.0, animationDuration: animated ? animationTime : 0.0, completion: { (finished) -> Void in
            self.actionView.removeFromSuperview()
            self.updateContentViewBackgroundColor()

            if let completion = completion {
                completion(finished)
            }
        })
    }
    
    // MARK: - Private API
    
    private var tableView: UITableView? {
        get {
            guard let cell = self.cell else {
                return nil
            }
            
            var view: UIView? = cell.superview
            
            while let unrappedView = view, (unrappedView is UITableView) == false {
                view = unrappedView.superview
            }
            
            return view as? UITableView
        }
    }
    
    private var cell: UITableViewCell? {
        get {
            guard let cell = view as? UITableViewCell else {
                return nil
            }
            
            return cell
        }
    }
    
    private var indexPath: IndexPath? {
        get {
            guard let tableView = self.tableView, let cell = self.cell else {
                return nil
            }
            
            return tableView.indexPath(for: cell)
        }
    }
    
    private func currentHorizontalTranslation() -> CGFloat {
        guard let cell = self.cell else {
            return 0.0
        }
        
        var horizontalTranslation: CGFloat = translation(in: cell).x
        
        if (horizontalTranslation > 0 && leftActions.count == 0) || (horizontalTranslation < 0 && rightActions.count == 0) {
            horizontalTranslation = 0.0
        }
        
        return horizontalTranslation
    }
    
    private func sortActions() {
        leftActions.sort { (action1, action2) -> Bool in
            return action1.fraction > action2.fraction
        }
        
        rightActions.sort { (action1, action2) -> Bool in
            return action1.fraction < action2.fraction
        }
    }
    
    private func fractionForCurrentCellPosition() -> CGFloat {
        guard let cell = self.cell else {
            return 0.0
        }
        
        return cell.contentView.frame.origin.x / cell.contentView.frame.width
    }
    
    private func actionsForCurrentCellPosition() -> [EECellSwipeAction] {
        return fractionForCurrentCellPosition() > 0 ? leftActions : rightActions
    }
    
    private func actionForCurrentCellPosition() -> EECellSwipeAction? {
        let actions = actionsForCurrentCellPosition()
        var action: EECellSwipeAction? = actions.first
        
        for a in actions {
            if abs(fractionForCurrentCellPosition()) > abs(a.fraction) {
                action = a
            } else {
                break
            }
        }
        
        return action
    }
    
    private func isActiveForCurrentCellPosition() -> Bool {
        if let currentAction = actionForCurrentCellPosition() {
            return abs(fractionForCurrentCellPosition()) >= abs(currentAction.fraction)
        }
        
        return false
    }
    
    private func updateContentViewBackgroundColor() {
        if actionView.superview != nil {
            cell?.contentView.backgroundColor = originalContentViewBackgroundColor ?? cell?.backgroundColor
        } else {
            cell?.contentView.backgroundColor = originalContentViewBackgroundColor
        }
    }
    
    private func updateCellPosition() {
        if let cell = self.cell {
            actionView.cellDidUpdatePosition(cell)
        }
        
        translateCellHorizontally(currentHorizontalTranslation())
    }
    
    private func translateCellHorizontally(_ horizontalTranslation: CGFloat) {
        guard let cell = cell else {
            return
        }
        
        cell.contentView.center = CGPoint(x: cell.contentView.frame.width / 2 + horizontalTranslation, y: cell.contentView.center.y)
    }
    
    private func translateCellHorizontally(_ horizontalTranslation: CGFloat, animationDuration: TimeInterval, completion: ((_ finished: Bool) -> Void)?) {
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIView.AnimationOptions() , animations: { () -> Void in
            self.translateCellHorizontally(horizontalTranslation)
        }, completion: completion)
    }
    
    private func performAction(completion: (() -> Void)? = nil) {
        if actionView.active {
            if let willTrigger = actionView.action?.willTrigger, let tableView = self.tableView, let indexPath = self.indexPath {
                willTrigger(tableView, indexPath)
            }
            
            translateCellHorizontally(horizontalTranslationForActionBehavior(), animationDuration: animationTime, completion: { (finished) -> Void in
                if self.actionView.action?.behavior == .pull {
                    self.actionView.removeFromSuperview()
                }
                
                if self.actionView.action?.behavior == .push {
                    self.isSwipeActive = true
                }
                
                if let didTrigger = self.actionView.action?.didTrigger, let tableView = self.tableView, let indexPath = self.indexPath {
                    didTrigger(tableView, indexPath)
                }

                completion?()
            })
        } else {
            isSwipeActive = false
            
            translateCellHorizontally(0.0, animationDuration: animationTime, completion: { (finished) -> Void in
                self.actionView.removeFromSuperview()
                completion?()
            })
        }
    }
    
    private func horizontalTranslationForActionBehavior() -> CGFloat {
        if let action = actionView.action, let cell = self.cell {
            return action.behavior == .pull ? 0 : cell.contentView.frame.width * (action.fraction / abs(action.fraction))
        }
        
        return 0.0
    }
    
}

// MARK: - UIGestureRecognizerDelegate

extension EECellSwipeGestureRecognizer: UIGestureRecognizerDelegate {
    
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let velocity = self.velocity(in: view)
        return abs(velocity.x) > abs(velocity.y)
    }
    
}
