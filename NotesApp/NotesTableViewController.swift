//
//  NotesTableViewController.swift
//  NotesApp
//
//  Created by robin on 2018-07-14.
//  Copyright © 2018 robin. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController {

    
    // MARK: -- Variables
    
    var notebook : Notebook!
    var notes : [Note] = []
    var context : NSManagedObjectContext!
    
    // MARK: -- Default functions
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 1. set up database variables
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        context = appDelegate.persistentContainer.viewContext
        
        
        print("Welcome to the notes controller")
        
        self.getNotes()
        
        
        
        for note in self.notes {
            print("\(note.dateAdded!) \(note.text!)")
        }

        
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: Database helper functions
    
    
    func getNotes() {
        // 1. get notes from the database
        let fetchRequest:NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "notebook = %@", notebook)
        //fetchRequest.predicate = NSPredicate(format: "notebook.name = %@", notebook.name)
        
        do {
            self.notes = try context.fetch(fetchRequest)
        }
        catch{
            print("Error while fetching notes from database")
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 20.0)!
        
        cell.detailTextLabel?.text = "\(notes[indexPath.row].dateAdded!)"
        cell.textLabel?.text = notes[indexPath.row].text!

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            
            // LOGIC:
            // - Remove the item from the database
            // - Remove the item from the pages array
            
            let i = indexPath.row
            let pageToDelete = notes[i]
            print(pageToDelete.text!)
            
            // remove from array
            notes.remove(at: i)
            
            // remove from databas
            self.context.delete(pageToDelete)
            
            
            do {
                try self.context.save()
                print("Deleted!")
            }
            catch {
                print("error while commiting delete")
            }
            
            
            // UI NONSENSE: remove the row from the tableview
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
    override func viewWillAppear(_ animated: Bool) {
        // This function is called:
        // - after viewDidLoad (the first time)
        // - after coming "back" to this screen
        
        self.getNotes()
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editNoteSegue") {
            
            let editNoteVC = segue.destination as! EditNotesViewController
            
            let i = (self.tableView.indexPathForSelectedRow?.row)!
            editNoteVC.note = notes[i]
            
        }
        else if (segue.identifier == "addNoteSegue") {
            // person wants to add a new note 
            let editNoteVC = segue.destination as! EditNotesViewController
            editNoteVC.userIsEditing = false
            editNoteVC.notebook = self.notebook
            
        }
        
    }
 

}
