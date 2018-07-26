//
//  ViewController.swift
//  NotesApp
//
//  Created by robin on 2018-07-14.
//  Copyright © 2018 robin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    
    // MARK:  variables
    
    @IBOutlet weak var textboxNotebookName: UITextField!
    @IBOutlet weak var textboxNote: UITextField!

    var notebooks:[Notebook] = []
    
    // MARK:  CoreData variables
    var context:NSManagedObjectContext!
    

    
    
    
    // MARK: default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize CoreData variables
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        context = appDelegate.persistentContainer.viewContext
        
        // setup array of notebooks
        getAllNotebooks()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:  button handlers

    @IBAction func addNewNotebook(_ sender: UIBarButtonItem) {
        
        
        // 1. Create a popup
        let alertBox = UIAlertController(title: "Add a Notebook", message: "Give your notebook a name.", preferredStyle: .alert)
        
        
        // 2. Add Save and Cancel buttons
        alertBox.addAction(UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let textField = alertBox.textFields![0] as UITextField
            
            
            if (textField.text?.isEmpty == false) {
                let notebookSaved = self.addNotebook(notebookName: textField.text!)
                if (notebookSaved == true) {
                    // reload the table
                    self.getAllNotebooks()
                    self.tableView.reloadData()
                }
            }            
        }))
        alertBox.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // 3. Add a textbox
        alertBox.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "Enter notebook name"
        })
        
        
        // 4. show the alertbox
        self.present(alertBox, animated: true, completion: nil)
        
        
    }
    
    
    
    // MARK: database helper functions
    // ------------------------------------------------------------
    func getAllNotebooks() {
        // setup array of notebooks
        let fetchRequest:NSFetchRequest<Notebook> = Notebook.fetchRequest()
        
        // Uncomment if you want to sort the list by name
        // let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        // notebookFetchRequest.sortDescriptors = [sortDescriptor]
        
        
        do {
            self.notebooks = try context.fetch(fetchRequest)
        }
        catch {
            print("Error fetching notebooks from database")
        }
    }
    
    func addNotebook(notebookName:String) -> Bool {
        let notebook = Notebook(context: self.context)
        notebook.name = notebookName
        notebook.setValue(Date(), forKey:"dateCreated")
        
        //notebook.dateCreated = Date()     // this is for XCode 9+
        
        do {
            try self.context.save()
            print("notebook saved!")
            return true
            
        }
        catch {
            print("error while trying to save a new notebook")
        }
        
        return false
        
    }
    
    // MARK: -- Segue functions
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        /*
        if (identifier == "showNotesSegue") {
            // VALIDATION: Check if noteboox textbox is empty
            
            let n = textboxNotebookName.text!
            if (n.isEmpty) {
                print("Please enter a notebook name")
                textboxNotebookName.text = ""
                return false
            }
            
            
            // 1. get a reference to the notebook
            let notebook = getNotebook(notebookName: textboxNotebookName.text!)
            if (notebook == nil) {
                print("cannot find a notebook with that name")
                return false
            }
        }
        */
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showNotesSegue") {

            print("calling PREPARE function")
            
            
            let notesVC = segue.destination as! NotesTableViewController
            
            let i = (self.tableView.indexPathForSelectedRow?.row)!
            notesVC.notebook = notebooks[i]

            
        }
        
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notebooks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 20.0)!
        
        cell.textLabel?.text = notebooks[indexPath.row].name!
        
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            
            // LOGIC:
            // - Remove the item from the database
            // - Remove the item from the pages array
            
            let i = indexPath.row
            let notebookToDelete = notebooks[i]
            print(notebookToDelete.name!)
            
            // remove from array
            notebooks.remove(at: i)
            
            // remove from databas
            self.context.delete(notebookToDelete)
            
            
            do {
                try self.context.save()
                print("Deleted!")
            }
            catch {
                print("error while commiting notebook delete")
            }
            
            
            // UI NONSENSE: remove the row from the tableview
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
}

