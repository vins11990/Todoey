//
//  ViewController.swift
//  Todoey
//
//  Created by viNs on 6/26/18.
//  Copyright © 2018 Vinay Soni. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var listArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = Item()
        item1.title = "One"
        listArray.append(item1)
        
        if let items = defaults.array(forKey: "itemArray") as? [Item] {
            listArray = items
        }
        
        tableView.separatorStyle = .none
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
        
        tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add new item to List
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let newItem = Item()
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) {
            (action) in
            newItem.title = textField.text!
            
            self.listArray.append(newItem)
            self.defaults.set(self.listArray, forKey: "itemArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Write here"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    


}

