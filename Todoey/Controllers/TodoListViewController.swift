//
//  ViewController.swift
//  Todoey
//
//  Created by Gabriel Raymondou on 18/08/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            // Retrieving saved data only if selectedCategory is set
            loadItems()
        }
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // -- Sets the size of the tableView
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // -- Puts cell label on each item in itemArray
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // -- Handles the ability to check and uncheck the cells
        
        //print(itemArray[indexPath.row])

//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // -- Handles the ability to add new items
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen one the user clicks the Add Item
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model Manipulation Methods
    func saveItems() {
        // -- Saves the items into DataModel/Item
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        // -- Loads the items from DataModel/Item
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])

        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
}

// MARK: - Search Bar Extension
extension TodoListViewController: UISearchBarDelegate {
    
    // MARK: - Search Delegate Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // -- Triggers the search when the button is clicked
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
            
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
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
