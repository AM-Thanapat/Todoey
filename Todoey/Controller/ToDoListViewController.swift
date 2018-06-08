//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Thanapat Saisoontornwattana on 7/6/2561 BE.
//  Copyright © 2561 Thanapat Saisoontornwattana. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    var selectedCategory : Category?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Todo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        tableView.deselectRow(at: indexPath, animated: true)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItem()
    }
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Todo(context: self.context)
            newItem.title = textField.text
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItem()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItem(){
        do{
            try context.save()
            print("SaveComplete")
        }catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        loadItems(category: selectedCategory!)
    }
    func loadItems(request: NSFetchRequest<Todo>){
        do{
            itemArray = try context.fetch(request)
            tableView.reloadData()
        }catch {
            print("Error fetch request from context \(error)")
        }
    }
    func loadItems(category: Category){
        let request : NSFetchRequest<Todo> = Todo.fetchRequest()
        let predicate = NSPredicate(format: "parentCategory.title MATCHES %@", category.title!)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(request: request)
    }
    func loadItem(category: Category, title: String){
        let request : NSFetchRequest<Todo> = Todo.fetchRequest()
        let predicate = NSPredicate(format: "parentCategory.name MATCH %@ AND title CONTAINS[cd] %@", category.title!,title)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(request: request)
    }
    
}

extension ToDoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadItem(category: selectedCategory!, title: searchBar.text!)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}
