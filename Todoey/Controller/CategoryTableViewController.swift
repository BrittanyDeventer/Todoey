 //
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Brittany Deventer on 1/22/19.
//  Copyright © 2019 Brittany Deventer. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    //declare category array - an array of categories  *** this type was created in our dataModel!
    var categories = [Category]()
    
    // Reference the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create default/first category
        let newCategory = Category(context: context)
        newCategory.name = "Default"
        //newCategory.items = // set which item is related to this category
        
        // Show category in tableview
        categories.append(newCategory)
        
        // load categories to tableview
        loadCategories()
    }

    // MARK: - TableView Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        // Configure the cell...
        let category = categories[indexPath.row].name
        
        // populate cell
        cell.textLabel?.text = category

        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // tell the todo list vc which item list to use
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    //MARK: - Data (or Model) Manipulation Methods
        //so we can use CRUD...
    //encode
    func saveCategories() {
     
        // Core Data
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    //decode
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //created to access the text within the alert
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // create category
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            // add category to local context
            self.categories.append(newCategory)
            
            // save the context
            self.saveCategories()
            
        }
        
        //add textfield to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
 }
