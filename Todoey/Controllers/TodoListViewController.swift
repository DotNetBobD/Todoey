//
//  ViewController.swift
//  Todoey
//
//  Created by bob donovan on 4/17/18.
//  Copyright © 2018 bob donovan. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {

    let realm = try? Realm()
    
    var todoItems: Results<Item>?
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    //let defaults = UserDefaults.standard
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
            
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //    itemArray = items
        //}
    }

    //MARK tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
   
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
    
        return cell
    }
    
    //MARK table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm?.write {
                    //realm?.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("error saving done status \(error)")
            }
        }
        tableView.reloadData()
        //print(itemArray[indexPath.row])
        
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        //todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        //saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what happens when add buttn pressed
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm?.write {
                        let newItem = Item()
                        newItem.title  = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch {
                    print("Error saving new item \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
//    func saveItems() {
//        
//        do {
//            try context.save()
//        } catch {
//            print("error saving context \(error)")
//        }
//        self.tableView.reloadData()
//    }
    
    func loadItems() {
    
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
////        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
////
////        request.predicate = compoundPredicate
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching from context \(error)")
//        }
        
        tableView.reloadData()
    }
    
}

//MARK: search bar methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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

