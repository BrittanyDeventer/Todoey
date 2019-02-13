 //
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Brittany Deventer on 1/22/19.
//  Copyright © 2019 Brittany Deventer. All rights reserved.
//

import UIKit
import RealmSwift
 
class CategoryTableViewController: UITableViewController {
    
    //Create a new realm
    let realm = try! Realm()   //valid via RealmSwift documentation, dont worry about the !
    
    var categories: Results<Category>?
    
    // Reference the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load categories to tableview
        loadCategories()
    }

    // MARK: - TableView Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return categories?.count ?? 1 //if categories is nil, return 1  Nil coalescing operator
     }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet."

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
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data (or Model) Manipulation Methods
        //so we can use CRUD...
    //encode
    func save(category: Category) {
        // Realm
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    //decode
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //created to access the text within the alert
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // create category
            let newCategory = Category()
            newCategory.name = textField.text!
            
            // save the category to realm
            self.save(category: newCategory)
            
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
