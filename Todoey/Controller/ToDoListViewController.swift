//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Brittany Deventer on 1/11/19.
//  Copyright © 2019 Brittany Deventer. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()  // didSet is called only when selectedCategory has a value (when category tapped in other vc)
        }
    }
    
    //initialize core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // User defaults method (not used in the end...)
    //let defaults = UserDefaults.standard
    
    // Filepath to items.plist file created in app document folder
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("data file path = \(dataFilePath)")
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Eat Food"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Go home"
//        itemArray.append(newItem3)

        
        //Check that data exists in user defaults, if so, populate the array
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        loadItems()



    }

    
    //MARK: TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return number of rows
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        let item = itemArray[indexPath.row]
    
        //populate cell
        cell.textLabel?.text = item.title
    
        //handle the checkmark
        
        //ternary operator
        // value = condition ? ifTrue : ifFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
 
        //return cell
        return cell
    }

    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        // Core Data Delete method:
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        //then save context
        
        
        //handle done property
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        saveItems()
        //tableView.reloadData()
        
        //Toggle checkmarks
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        //make animation for pressing row (flashes grey when pressed and goes away)
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MARK: Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //create alert action that prompts user for new todo
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks add button
            //print("success!")
            
            //print(textField.text)
            

            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            // Once a relationship has been established in DataModel
            newItem.parentCategory = self.selectedCategory 
            
            //append item to list array
            self.itemArray.append(newItem)
            
            //Persist data using User Defaults, causes error once we use an Item object
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            
            
            //RELOAD THE DATA TO UPDATE THE TABLEVIEW!!!
            self.tableView.reloadData()
            
            
        }
    
        //add textfield to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        //add action to alert
        alert.addAction(action)
        
        //present alert
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: Model Manipulation Methods
    
    //encode
    func saveItems() {
        // NSCoder
        //let encoder = PropertyListEncoder()
        
        // Core Data
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    //decode
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //Only use the search predicate if it is NOT nil
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
            } else {
                request.predicate = categoryPredicate
            }
        
        
        //below only works if predicate is never nil.  Use the safe unwrapping version above
        //create a compound predicate to handle both search and category request queries
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching context, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    // before adding categoryVC
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching context, \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    
//    func loadItems() {
//
//        // Core Data
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching context, \(error)")
//        }
//
//        // NSCODER
////        do{
////            //if there is a plist there, then create a decoder and decode the file
////            if let data = try? Data(contentsOf: dataFilePath!) {
////                let decoder = PropertyListDecoder()
////                do {
////                    itemArray = try decoder.decode([Item].self, from: data)
////                } catch {
////                    print("Error decoding array, \(error)")
////                }
////            }
////        }
//    }
//

    
}

//MARK: Search Bar Delegate
extension ToDoListViewController: UISearchBarDelegate {
    //Search Bar delgate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //make a request
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //check search bar
        //print(searchBar.text!)
        
        //make a predicate
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        // decide how to sort the response
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        
        // fetch the request
        loadItems(with: request)
        
//      THis was the ugly code...
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching context, \(error)")
//        }
//
//        // reload data
//        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            // on the main thread,
            DispatchQueue.main.async {
                //get rid of keyboard and cursor
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
