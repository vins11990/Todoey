//
//  ViewController.swift
//  Todoey
//
//  Created by viNs on 6/26/18.
//  Copyright © 2018 Vinay Soni. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var listArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItem()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
//    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(filePath!)
//        loadItem()
        
        
    }

    //MARK: TableView DataSource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = listArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.checked ? .checkmark : .none
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    //MARK: TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(listArray[indexPath.row])
        
        listArray[indexPath.row].checked = !listArray[indexPath.row].checked
        
        saveItem()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add new item to List
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let newItem = Item(context: self.context)
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) {
            (action) in
            newItem.title = textField.text!
            newItem.checked = false
            newItem.parentCategory = self.selectedCategory
            self.listArray.append(newItem)
            print(newItem)
            self.saveItem()
        }
        
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "Enter new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: Data manipulation methods
    
    func saveItem() {
        
        do {
            try context.save()
        } catch {
            print("Errors saving data \(error)")
        }
        tableView.reloadData()
    }

    
    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        let catPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catPredicate, additionalPredicate])
        } else {
            request.predicate = catPredicate
        }
        
        do {
            listArray = try context.fetch(request)
        } catch {
            print("Errors loading data \(error)")
        }
        
        tableView.reloadData()
    }


}

//MARK: SearchBar methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItem(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
 
        }
    }
    


}




