//
//  SwipeTableViewController.swift
//  Todo Realm
//
//  Created by Sai Abhilash Gudavalli on 02/07/22.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else {return nil}
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
            // handle Action
            self?.updateModel(at: indexPath)
        }
        
        let archiveAction = SwipeAction(style: .default, title: "Archive") { action, indexPath in
            // handle Action
        }
        
        deleteAction.image = UIImage(named: "delete")
        archiveAction.image = UIImage(named: "archive")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func updateModel(at indexPath: IndexPath) {
        
    }
}
