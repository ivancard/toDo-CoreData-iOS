//
//  CategoryTableViewController.swift
//  ToDp
//
//  Created by ivan cardenas on 02/04/2023.
//

import UIKit
import CoreData 

class CategoryTableViewController: UITableViewController {

    var categoryArray = [CategoryItem]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    func loadCategories() {
        let request: NSFetchRequest<CategoryItem> = CategoryItem.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print(error)
        }
    }

    func saveCategory() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "" , preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            let newCategory = CategoryItem(context: self.context)
            newCategory.name = textField.text
            self.categoryArray.append(newCategory)
            self.saveCategory()
        }

        alert.addTextField() { alertTextField in
            alertTextField.placeholder = "Create a Category"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }

}

//MARK: - TableViewDelegate and DataSource

extension CategoryTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = categoryArray[indexPath.row]

        cell.textLabel?.text = item.name

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //code to navigate
        performSegue(withIdentifier: "goToItems", sender: self)
    }
}
