//
//  ViewController.swift
//  Todoey
//
//  Created by viNs on 6/26/18.
//  Copyright © 2018 Vinay Soni. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    var itemList : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItem()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    //MARK: TableView DataSource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        if let item = itemList?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.checked ? .checkmark : .none
        } else {
            cell.textLabel?.text = "Please add some items"
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 1
    }
    
    //MARK: TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = itemList?[indexPath.row] {
            do {
                
                try realm.write {
                    item.checked = !item.checked
                }
                
            } catch {
                print("Errors saving!")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add new item to List
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) {
            (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                                    let newItem = Item()
                                    newItem.title = textField.text!
                                    newItem.dateCreated = Date()
                                    currentCategory.items.append(newItem)
                                }
                } catch {
                    print("Errors saving!")
                }
            }
            self.tableView.reloadData()
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

    
    func loadItem() {

        itemList = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        
        tableView.reloadData()
    }


}

//MARK: SearchBar methods
extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemList = itemList?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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




