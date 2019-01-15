//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Brittany Deventer on 1/11/19.
//  Copyright © 2019 Brittany Deventer. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()

    // User defaults method (not used in the end...)
    //let defaults = UserDefaults.standard
    
    // Filepath to items.plist file created in app document folder
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Eat Food"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Go home"
        itemArray.append(newItem3)

        
        //Check that data exists in user defaults, if so, populate the array
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
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
            
            let newItem = Item()
            newItem.title = textField.text!
            
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
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        tableView.reloadData()
    }
    
    //decode
    func loadItems() {
        
        do{
            //if there is a plist there, then create a decoder and decode the file
            if let data = try? Data(contentsOf: dataFilePath!) {
                let decoder = PropertyListDecoder()
                do {
                    itemArray = try decoder.decode([Item].self, from: data)
                } catch {
                    print("Error decoding array, \(error)")
                }
            }
        }
    }
}

