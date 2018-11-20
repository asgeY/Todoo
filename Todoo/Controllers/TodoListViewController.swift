//
//  ViewController.swift
//  Todoo
//
//  Created by Asgedom Yohannes on 10/30/18.
//  Copyright © 2018 Asgedom Y. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
    }
    //changing the color with the selected category
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        guard let colorHex = selectedCategory?.Color else {fatalError()}
        upDateBar(withHexCode: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        upDateBar(withHexCode: "1D9BF6")

    }
    //MARK:- NaveBar setUp methods
    
    func upDateBar(withHexCode colorHexCode: String){
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller Does not Exist")}
        
        guard let  navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}
        navBar.barTintColor = UIColor(hexString: colorHexCode)
        navBar.tintColor  = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
    }
    
    //Mark: - Table view DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.Color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            //Ternary operator ==>
            //Value=condition ? ValueTrue : ValueFalse
//            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Item Added"
        }
        
        return cell
    }
    
    //MARK: - TableView delegete Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row]{
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch{
                print("Error saving done Items,\(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new todoo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // what will happen once the user add a new item on our UIAlert
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write {
                        let newItem = Item ()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                    
                }catch{
                    print("Error sacing Items,\(error)")
                }
                
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    //MARK: - Model manupulatuion Methods
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
        todoItems = realm.objects(Item.self)
        tableView.reloadData()
    }
    
    //MARK:- Delete Items from Swipe
    override func updateModel(at IndexPath: IndexPath) {
        if let item = self.todoItems? [IndexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            }catch{
                print("Error deleting Items,\(error)")
            }
        }
    
    }
    
}
//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated",ascending: true)
        
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
    


