//
//  ViewController.swift
//  ToDp
//
//  Created by ivan cardenas on 02/04/2023.
//

import UIKit
import CoreData
import RealmSwift

class ToDoListViewController: UITableViewController {

    var selectedCategory: CategoryItem? {
        didSet{
            loadToDos()
        }
    }
    var arrayItem = [ToDoItem]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayItem.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        let item = arrayItem[indexPath.row]

        cell.textLabel?.text = item.title

        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

         arrayItem[indexPath.row].done.toggle()
//        context.delete(arrayItem[indexPath.row])
//        arrayItem.remove(at: indexPath.row)
        saveToDo()
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ToDo", message: "" , preferredStyle: .alert)

        let action = UIAlertAction(title: "Add ToDo", style: .default) { action in

            let newToDo = ToDoItem(context: self.context)
            newToDo.title = textField.text
            newToDo.done = false
            newToDo.parentCategory = self.selectedCategory
            self.arrayItem.append(newToDo)
            self.saveToDo()

        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create a ToDo"
            textField = alertTextField
        }
        alert.addAction(action)

        present(alert, animated: true)
    }

    @IBAction func searchDidChange(_ sender: UITextField) {

        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        let predicate1 = NSPredicate(format: "title CONTAINS[cd] %@", sender.text!)
        let predicate2 = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        do {
            if sender.text?.trimmingCharacters(in: .whitespaces) != "" {
                arrayItem = try context.fetch(request)
            } else {
                let whiteRequest: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
                whiteRequest.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", self.selectedCategory!.name!)
                arrayItem = try context.fetch(whiteRequest)
                DispatchQueue.main.async {
                    sender.resignFirstResponder()
                }
            }
        } catch {
            print(error)
        }
        tableView.reloadData()
    }

    func saveToDo() {

        do {
            try  context.save()
        } catch {

        }
        self.tableView.reloadData()
    }

    func loadToDos() {
        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        request.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        do{
            arrayItem =  try context.fetch(request)
        } catch {
            print(error)
        }
    }

}
