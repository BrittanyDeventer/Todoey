//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Brittany Deventer on 1/11/19.
//  Copyright © 2019 Brittany Deventer. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    let itemArray = ["Find Mike", "Buy Shoes", "Destroy Demagorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    
    
}

