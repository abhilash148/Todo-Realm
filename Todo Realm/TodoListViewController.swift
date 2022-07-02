//
//  TodoListViewController.swift
//  Todo Realm
//
//  Created by Sai Abhilash Gudavalli on 02/07/22.
//

import UIKit
import RealmSwift
import SwipeCellKit

class TodoListViewController: SwipeTableViewController {
    
    var items: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = items?[indexPath.row].title ?? "No Items added yet!"
        cell.accessoryType = items?[indexPath.row].done ?? false ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // update method
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Abhilash unable to update - \(error)")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
    }
    
    
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        
        let alertVC = UIAlertController(title: "Item", message: "Add Item", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] (action) in
            
            guard let textField = alertVC.textFields?.first, let value = textField.text else { return }
            
            if let category = selectedCategory {
                let newItem = Item()
                newItem.title = value
                newItem.done = false
                newItem.dateCreated = Date()
                do {
                    try realm.write {
                        realm.add(newItem)
                        category.items.append(newItem)
                    }
                } catch {
                    print("Abhilash unable to save newItem - \(error)")
                }
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Add Item"
        }
        alertVC.addAction(saveAction)
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true)
        
    }
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        self.tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write({
                    realm.delete(item)
                })
            } catch {
                print("Abhilash failed to delete iteam - \(error)")
            }
        }
    }
    
}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
