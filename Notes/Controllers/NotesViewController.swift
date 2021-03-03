//
//  ViewController.swift
//  Notes
//
//  Created by Ming Liang Khong on 3/3/21.
//

import UIKit
import CoreData

class NotesViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var notesArray = [Note]()
    var selectedNote:Note?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadData()
    }
    
    // For when the Contents view is popped off
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        self.tableView.reloadData()
    }
    
    // For when user press add new note
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        selectedNote = Note(context: context)
        selectedNote?.title=""
        selectedNote?.content=""
        self.performSegue(withIdentifier: "goToContent", sender: self)
    }
    
    // For when the app is transitioning to the content view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ContentViewController
        destinationVC.note = selectedNote
        destinationVC.instanceOfNotesViewController = self
    }
}


//MARK: - UITableView Stuffs
extension NotesViewController {
    // For the notes title to show up on the tableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell",for: indexPath)
        cell.textLabel?.text = notesArray[indexPath.row].title
        return cell
    }
    
    // For when the user select a note
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNote = notesArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "goToContent", sender: self)
    }
    
    // For the number of rows that the tableView should have
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    // For Swipe Action on the notes
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.deleteNote(index: indexPath.row)
            completionHandler(true)
        }
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    
    // For deleting the notes
    func deleteNote(index:Int){
        context.delete(notesArray[index])
        notesArray.remove(at: index)
        saveData()
        self.tableView.reloadData()
    }
    
}

//MARK: - Load Data from Core Data
extension NotesViewController{
    
    func loadData(){
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        
        do {
            notesArray = try context.fetch(request)
        } catch  {
            print("Error fetching Context: \(error)")
        }
        
    }
    
    func saveData(){
        do {
            try context.save()
        } catch  {
            print("Error saving Context: \(error)")
        }
    }
}

