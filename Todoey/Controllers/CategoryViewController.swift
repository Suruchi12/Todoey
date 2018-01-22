//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Suruchi Singh on 1/21/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        tableView.separatorStyle = .none
        
    }

    //MARK:- Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            //auto update in realm
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert,animated: true,completion: nil)
    }
    
    //MARK:- TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 //nil coalscing operator
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
       
        if let category = categories?[indexPath.row]{
            
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            cell.backgroundColor = UIColor(hexString: category.colour )
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)

        }
        
        return cell
        
    }
    
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
    }
    
    //MARK:- Data Manipulation Methods
    //save and load data
    
    
    func save(category: Category){
        
        do{
            try  realm.write {
                realm.add(category)
            }
        }
        catch{
            print("Error saving the context \(error)")
        }
        self.tableView.reloadData()
        
        
    }
    
    //Load
    func loadCategories(){
        //has internal and external parameteres and a default value
        
         categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    //MARK:- Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try  self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }
            catch{
                print("\(error)")
            }
            //tableView.reloadData()
        }
        
    }

}


