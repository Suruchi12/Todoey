//
//  ViewController.swift
//  Todoey
//
//  Created by Suruchi Singh on 1/15/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

   // var itemArray = ["Find Dean", "Get Mark of Cain", "Kill Lucifer"]
    
    let realm = try! Realm()
    var todoItems : Results<Item>?
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    //let defaults = UserDefaults.standard
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory,
    //in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //loadItems()
        
/*      if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
            itemArray = items
        }
*/
    }

    //MARK - TableView Data sorce methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        }
        else{
            cell.textLabel?.text = "No Items Added"
            
        }
        
        //use ternary operator instead
/*        if itemArray[indexPath.row].done == true{
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
       }
 */
 
        
        return cell

    }
    
    //MARK - TableView Delegate Methods
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let item = todoItems?[indexPath.row]{
        
        do{
             try realm.write {
                //To delete
                //realm.delete(item)
                //To check in
                item.done = !item.done
            }
        }
        catch{
            print("Error saving done status, \(error)")
        }
        
        tableView.reloadData()
    }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            //what will happen once the user clicks the add item button on our UIAlert
            print("Add item pressed")
            //print(textField.text)
            
           // self.itemArray.append(textField.text!) doesnt work after adding Item Data Model
            if let currentCategory = self.selectedCategory{
               do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                }
              }
               catch{
                print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            //print(alertTextField.text) //--wont print until the alert is added to the action
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    
    // MARK: Model manipulation method
    func loadItems(){
         //has internal and external parameteres and a default value

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

    tableView.reloadData()

   }
    
    
}

//MARK:- Search bar method
extension TodoListViewController : UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
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

