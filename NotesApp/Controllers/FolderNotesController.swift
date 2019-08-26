//
//  FolderNotesController.swift
//  NotesApp
//
//  Created by Дмитрий Папушин on 01/07/2019.
//  Copyright © 2019 Дмитрий Папушин. All rights reserved.
//

import UIKit

class FolderNotesController: UITableViewController, UISearchBarDelegate, NoteDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var folderData: NoteFolder!{
        didSet {

            notes = CoreDataManager.shared.fetchNotes(from: folderData)
            filteredNotes = notes
        }
    }
    
    fileprivate var notes = [Note]()
    fileprivate var filteredNotes = [Note]()
    fileprivate var cachedText = ""
    
    fileprivate let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Folder Notes"
        
        setupTableView()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let items: [UIBarButtonItem] = [
            UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "\(notes.count) Notes", style: .done, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNewNote))
        ]
        
        self.toolbarItems = items
        
        tableView.reloadData()
    }
    
    @objc fileprivate func createNewNote() {
        let noteDetailController = NoteDetailController()
        
        noteDetailController.delegate = self
        
        navigationController?.pushViewController(noteDetailController, animated: true)
    }
    
    // MARK: - Setups
    
    fileprivate func setupTableView() {
        tableView.register(NotesCell.self, forCellReuseIdentifier: cellId)
    }
    
    fileprivate func setupSearchBar() {
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
    }
    
    // MARK: - Save notes
    
    func saveNewNote(title: String, date: Date, text: String) {
        let newNote = CoreDataManager.shared.createNewNote(title: title, date: date, text: text, noteFolder: self.folderData)
        notes.append(newNote)
        filteredNotes.append(newNote)
        self.tableView.insertRows(at: [IndexPath(row: notes.count - 1, section: 0)], with: .fade)
    }
    
    // MARK: - Search function
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredNotes = notes.filter({ (note) -> Bool in
            return note.title?.lowercased().contains(searchText.lowercased()) ?? false
        })
        
        if searchBar.text!.isEmpty && filteredNotes.isEmpty {
            filteredNotes = notes
        }
        cachedText = searchText
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if !cachedText.isEmpty && !filteredNotes.isEmpty {
            searchController.searchBar.text = cachedText
        }
    }
}

// MARK: - Extention

extension FolderNotesController {
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions = [UITableViewRowAction]()
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            print("trying to delete items", indexPath)
            
            let targetRow = indexPath.row
            // remove from coredata
            if CoreDataManager.shared.deleteNote(note: self.notes[targetRow]) {
                self.notes.remove(at: targetRow)
                self.filteredNotes.remove(at: targetRow)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
        actions.append(deleteAction)
        return actions
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredNotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NotesCell
        let noteForRow = self.filteredNotes[indexPath.row]
        cell.noteData = noteForRow
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteDetailController = NoteDetailController()
        let noteForRow = self.filteredNotes[indexPath.row]
        noteDetailController.noteData = noteForRow
        navigationController?.pushViewController(noteDetailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
