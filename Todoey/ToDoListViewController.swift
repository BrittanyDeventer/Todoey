//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Brittany Deventer on 1/11/19.
//  Copyright © 2019 Brittany Deventer. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Shoes", "Destroy Demagorgon"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Check that data exists in user defaults, if so, populate the array
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }

    
    //MARK: TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return number of rows
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        
        //populate cell
        cell.textLabel?.text = itemArray[indexPath.row]
        
        //return cell
        return cell
    }

    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        //check off row
        
        
        //Toggle checkmarks
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            
            //append item to list array
            self.itemArray.append(textField.text!)
            
            //Persist data
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            
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
    
    
}

