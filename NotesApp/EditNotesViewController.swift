//
//  EditNotesViewController.swift
//  NotesApp
//
//  Created by robin on 2018-07-14.
//  Copyright © 2018 robin. All rights reserved.
//

import UIKit
import CoreData

class EditNotesViewController: UIViewController {

    
    // MARK: -- outlets
    @IBOutlet weak var textView: UITextView!
    
    
    // MARK: -- variables
    var note:Note!
    var notebook : Notebook?
    var userIsEditing = true;
    
    // MARK: -- database
    var context:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        context = appDelegate.persistentContainer.viewContext
        
        if (userIsEditing == true) {
            print("Editing an existing note")
            textView.text = note.text!
        }
        else {
            print("Going to add a new note to: \(notebook!.name!)")
            textView.text = ""
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        // save text
        
        
        if (textView.text!.isEmpty) {
            print("Please enter some text")
            return
        }
        
        
        if (userIsEditing == true) {
            note.text = textView.text!
        }
        else {
            // create a new note in the notebook
            self.note = Note(context:context)
            note.setValue(Date(), forKey:"dateAdded")
            note.text = textView.text!
            note.notebook = self.notebook
        }
        
        do {
            try context.save()
            print("Note Saved!")
            
            
            // show an alert box
            let alertBox = UIAlertController(title: "Saved!", message: "Save Successful.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
        }
        catch {
            print("Error saving note in Edit Note screen")
            
            // show an alert box with an error message
            let alertBox = UIAlertController(title: "Error", message: "Error while saving.", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertBox, animated: true, completion: nil)
        }
        
        if (userIsEditing == false) {
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        
        
        
    }
    
    

}
