//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Thanapat Saisoontornwattana on 8/6/2561 BE.
//  Copyright © 2561 Thanapat Saisoontornwattana. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var arrayCategory = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Database Control
    func searchCategory(title: String){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", title)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(request: request)
    }
    func loadItems(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        loadItems(request: request)
    }
    func loadItems(request: NSFetchRequest<Category>){
        do{
            arrayCategory = try context.fetch(request)
            tableView.reloadData()
        }catch{
            print("Error fetch request from context \(error)")
        }
    }
    func saveItem(){
        do{
            try context.save()}
        catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Table View Control
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = arrayCategory[indexPath.row].title
        return cell
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCategory.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItem", sender: self)
        
    }
    
    // Mark: - go segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItem"{
            let destinationVC = segue.destination as! ToDoListViewController
            destinationVC.selectedCategory = arrayCategory[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    // MARK: - Button Add Control
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Category(context: self.context)
            newItem.title = textField.text
            self.arrayCategory.append(newItem)
            self.saveItem()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
