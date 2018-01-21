//
//  ViewController.swift
//  Todoey
//
//  Created by Suruchi Singh on 1/15/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

   // var itemArray = ["Find Dean", "Get Mark of Cain", "Kill Lucifer"]
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    //let defaults = UserDefaults.standard
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory,
    //in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
              //print(dataFilePath!)
        
        // if let items = defaults.array(forKey: "TodoListArray") as? [String]{
       //     itemArray = items
        // }
  
 /*       let newItem = Item()
        newItem.title = "Find Dean"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Get Mark of Cain"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Kill Lucifer"
        itemArray.append(newItem3)
*/
        
        //loadItems()
        
/*      if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
            itemArray = items
        }
*/
    }

    //MARK - TableView Data sorce methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
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
       // print(indexPath.row)
       // print(itemArray[indexPath.row])
        //wont have gray when selecting a row
        
        
        //making this better by ternary operator
 /*       if itemArray[indexPath.row].done == false{
            itemArray[indexPath.row].done = true
        }
        else{
            itemArray[indexPath.row].done = false
     }
*/
        //replace above code with this : -
        
        //Before adding the class Item
        //----------------------------------
/*        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
     
     */
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done //sets the property to opposite of what it was
        saveItems()
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
            
           // let newItem = Item()
            
            let newItem = Item(context:self.context)
            
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
            
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
    func saveItems(){
        
       // let encoder = PropertyListEncoder()
        do{
            try  context.save()
        }
        catch{
            print("Error saving the context \(error)")
        }
        self.tableView.reloadData()

        
    }
    
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate:NSPredicate? = nil){
         //has internal and external parameteres and a default value
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate  = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }
        else{
            request.predicate = categoryPredicate
        }
        
        
       /* if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch{
                print("Error decoding, \(error)")
            }
        }*/
    
    
    //let request : NSFetchRequest<Item> = Item.fetchRequest() //need to specify data types
    do{
       itemArray =  try context.fetch(request)
    }
    catch{
        print("Error saving context \(error)")
    }
    
    tableView.reloadData()
    
   }
    
    
 
    
}

//MARK:- Search bar method
extension TodoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
      //  request.predicate = predicate
        
       //  request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //let sortDescriptor = NSSortDescriptor(key : "title", ascending : true)
        //request.sortDescriptors = [sortDescriptor]
        
        request.sortDescriptors = [NSSortDescriptor(key : "title", ascending : true)]
        
        loadItems(with : request,predicate: predicate)
        
        
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

