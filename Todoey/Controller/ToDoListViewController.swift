//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Brittany Deventer on 1/11/19.
//  Copyright © 2019 Brittany Deventer. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()  // didSet is called only when selectedCategory has a value (when category tapped in other vc)
        }
    }
    
    // Filepath to items.plist file created in app document folder
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("data file path = \(dataFilePath)")
        print(Realm.Configuration.defaultConfiguration.fileURL)
    }

    
    //MARK: TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return number of rows
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            //populate cell
            cell.textLabel?.text = item.title
            
            //handle the checkmark
            
            //ternary operator
            // value = condition ? ifTrue : ifFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
 
        //return cell
        return cell
    }

    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
    
        // handle done
        if let item = todoItems?[indexPath.row] {  //check that todoItems isn't nil > if not, go to indexPath.row and...
            do{
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        //make animation for pressing row (flashes grey when pressed and goes away)
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
        
    }
    
    //MARK: Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //create alert action that prompts user for new todo
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        // create item
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
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
    

    
    //decode
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
}

//MARK: Search Bar Delegate
//extension ToDoListViewController: UISearchBarDelegate {
//    //Search Bar delgate methods
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        //make a request
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        //check search bar
//        //print(searchBar.text!)
//
//        //make a predicate
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.predicate = predicate
//
//        // decide how to sort the response
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//
//        request.sortDescriptors = [sortDescriptor]
//
//
//        // fetch the request
//        loadItems(with: request)
//
////      THis was the ugly code...
////        do {
////            itemArray = try context.fetch(request)
////        } catch {
////            print("Error fetching context, \(error)")
////        }
////
////        // reload data
////        tableView.reloadData()
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            // on the main thread,
//            DispatchQueue.main.async {
//                //get rid of keyboard and cursor
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
//}
