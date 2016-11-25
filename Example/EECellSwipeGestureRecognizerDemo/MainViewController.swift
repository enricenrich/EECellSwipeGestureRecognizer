//
//  MainViewController.swift
//  EECellSwipeGestureRecognizerDemo
//
//  Created by Enric Enrich on 02/01/16.
//  Copyright © 2016 Enric Enrich. All rights reserved.
//

import UIKit
import EECellSwipeGestureRecognizer

class MainViewController: UITableViewController {

    // MARK: - Properties
    
    fileprivate var rows = [UITableViewCell]()
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "EECellSwipeGestureRecognizer"
        self.view.backgroundColor = UIColor.white
        
        self.prepareDataArray()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 60
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.rows.count > 0 {
            return self.rows[indexPath.row]
        } else {
            return UITableViewCell()
        }
    }
    
    // MARK: - Private API
    
    fileprivate func prepareDataArray() {
        self.rows = [self.rightPushSwipeCell, self.leftPullSwipeCell, self.rightAndLeftSwipeCell]
    }
    
    // MARK: - Getters
    
    fileprivate lazy var rightPushSwipeCell: UITableViewCell = {
        let cell: UITableViewCell = UITableViewCell()
        cell.contentView.backgroundColor = UIColor.white
        cell.textLabel?.text = "Right Push"
        
        let slideGestureRecognizer: EECellSwipeGestureRecognizer = EECellSwipeGestureRecognizer()
        
        let rightPushAction: EECellSwipeAction = EECellSwipeAction(fraction: 0.25)
        rightPushAction.icon = UIImage(named: "circle")!
        rightPushAction.activeBackgroundColor = UIColor.green
        rightPushAction.behavior = .push
        rightPushAction.didTrigger = { (tableView, indexPath) in
            print("Right Push")
            
            let alert = UIAlertController(title: "Swiped", message: "Right Push", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                slideGestureRecognizer.swipeToOrigin(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        slideGestureRecognizer.add(actions: [rightPushAction])
        
        cell.addGestureRecognizer(slideGestureRecognizer)
        return cell
    }()
    
    fileprivate lazy var leftPullSwipeCell: UITableViewCell = {
        let cell: UITableViewCell = UITableViewCell()
        cell.contentView.backgroundColor = UIColor.white
        cell.textLabel?.text = "Left Pull"
        
        let slideGestureRecognizer: EECellSwipeGestureRecognizer = EECellSwipeGestureRecognizer()
        
        let leftPullAction: EECellSwipeAction = EECellSwipeAction(fraction: -0.25)
        leftPullAction.icon = UIImage(named: "circle")!
        leftPullAction.activeBackgroundColor = UIColor.blue
        leftPullAction.behavior = .pull
        leftPullAction.didTrigger = { (tableView, indexPath) in
            print("Left Pull")
        }
        
        slideGestureRecognizer.add(actions: [leftPullAction])
        
        cell.addGestureRecognizer(slideGestureRecognizer)
        return cell
    }()
    
    fileprivate lazy var rightAndLeftSwipeCell: UITableViewCell = {
        let cell: UITableViewCell = UITableViewCell()
        cell.contentView.backgroundColor = UIColor.white
        cell.textLabel?.text = "Right Push & Left Pull"
        
        let slideGestureRecognizer: EECellSwipeGestureRecognizer = EECellSwipeGestureRecognizer()
        
        let rightPushAction: EECellSwipeAction = EECellSwipeAction(fraction: 0.25)
        rightPushAction.icon = UIImage(named: "circle")!
        rightPushAction.activeBackgroundColor = UIColor.green
        rightPushAction.behavior = .push
        rightPushAction.didTrigger = { (tableView, indexPath) in
            print("Right Push")
            
            let alert = UIAlertController(title: "Swiped", message: "Right Push", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                slideGestureRecognizer.swipeToOrigin(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        let leftPullAction: EECellSwipeAction = EECellSwipeAction(fraction: -0.25)
        leftPullAction.icon = UIImage(named: "circle")!
        leftPullAction.activeBackgroundColor = UIColor.blue
        leftPullAction.behavior = .pull
        leftPullAction.didTrigger = { (tableView, indexPath) in
            print("Left Pull")
        }
        
        slideGestureRecognizer.add(actions: [rightPushAction, leftPullAction])
        
        cell.addGestureRecognizer(slideGestureRecognizer)
        return cell
    }()

}

