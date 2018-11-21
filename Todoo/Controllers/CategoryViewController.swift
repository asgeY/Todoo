//
//  CategoryViewController.swift
//  Todoo
//
//  Created by Asgedom Yohannes on 11/5/18.
//  Copyright © 2018 Asgedom Y. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let relam = try! Realm()
    
    var categories: Results<Category>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
    }
    // MARK: - Table view DataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let catagory = categories?[indexPath.row]{
            
            cell.textLabel?.text = catagory.name
            guard let catagoryColor = UIColor(hexString: catagory.Color) else {fatalError()}
            cell.backgroundColor = catagoryColor
            cell.textLabel?.textColor = ContrastColorOf(catagoryColor, returnFlat: true)
    }
        return cell
    }
    
    // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories? [indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation methods
    
    func save(Category: Category)  {
        
        do {
            try relam.write {
                relam.add(Category)
            }
        } catch {
            print("Error saving Category,\(error)")
        }
        
        tableView.reloadData()
    }
    func loadCategories() {
        
        categories = relam.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK:- Delete Data from swipe
    override func updateModel(at IndexPath: IndexPath) {
        if let categoryForDeletion = self.categories? [IndexPath.row] {
            do {
                try self.relam.write {
                    self.relam.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting ategory,\(error)")
            }
        }
    }
    
    
    // MARK: - New categories
    @IBAction func addPressedButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // what will happen once the user add a new category on our UIAlert
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.Color = UIColor.randomFlat.hexValue()
            self.save(Category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
            textField.spellCheckingType = .yes // this and the next line enable spell check
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences // this capitalizes first word
        }
        present(alert, animated: true, completion: nil)
        
    }
}






