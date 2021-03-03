//
//  DetailsViewController.swift
//  Notes
//
//  Created by Ming Liang Khong on 3/3/21.
//

import UIKit
class ContentViewController: UIViewController{
    
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteContentTextView: UITextView!
    @IBOutlet weak var addNoteButton: UIButton!
    
    var note : Note?
    var existingNote:Bool = false
    var instanceOfNotesViewController:NotesViewController!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // To star
        self.dismissKeyboard()
        
        // Aesthetics adjustments
        addNoteButton.layer.cornerRadius = 5.0
        noteContentTextView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        noteContentTextView.layer.borderWidth = 0.5
        noteContentTextView.layer.cornerRadius = 5.0
        
        // Loading of note
        noteTitleTextField.text = note?.title
        noteContentTextView.text = note?.content
        
        // Changing the button title if the note is not new
        if note?.title != "" {
            addNoteButton.setTitle("Save Note", for: .normal)
            existingNote = true
        }
        
        
    }
    
    // For saving the note
    @IBAction func addNotePressed(_ sender: UIButton) {
        if noteTitleTextField.text == "" {
            // Changing the note title Edited note if the note is not new but the title has been removed
            if existingNote {
                note?.title = "Edited Note"
            } else {
                note?.title = "New Note"
            }
            
        } else {
            note?.title = noteTitleTextField.text
        }
        
        note?.content = noteContentTextView.text
        saveData()
        // Returns to Notes list on Add
        instanceOfNotesViewController.loadData()
        instanceOfNotesViewController.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveData(){
        do {
            try context.save()
        } catch  {
            print("Error saving Context: \(error)")
        }
    }
    
}

//MARK: - To Dismiss Keyboard on Touch Outside
extension UIViewController {
    
    func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target:self, action: #selector(UIViewController.dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
        
}
