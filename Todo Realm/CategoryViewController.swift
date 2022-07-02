//
//  ViewController.swift
//  Todo Realm
//
//  Created by Sai Abhilash Gudavalli on 02/07/22.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.loadCategories()
        tableView.rowHeight = 80.0
        
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        let alertVC = UIAlertController(title: "Category", message: "Add new category", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] (action) in
            guard let textField = alertVC.textFields?.first, let value = textField.text else { return }
            
            let newCategory = Category()
            newCategory.name = value
            
            self.saveCategory(newCategory)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Add category"
        }
        alertVC.addAction(saveAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func saveCategory(_ category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Abhilash failed to save newCategory - \(error)")
        }
        
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categories?[indexPath.row] {
            do {
                try self.realm.write({
                    self.realm.delete(category)
                })
            } catch {
                print("Abhilash failed to delete category - \(error)")
            }
        }
        loadCategories()
    }
}

