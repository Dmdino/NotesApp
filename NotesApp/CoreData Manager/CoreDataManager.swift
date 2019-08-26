//
//  CoreDataManager.swift
//  NotesApp
//
//  Created by Дмитрий Папушин on 05/07/2019.
//  Copyright © 2019 Дмитрий Папушин. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NotesApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of stores if faled: \(err)")
            }
        })
        return container
    }()
    
    // 1. createNoteFolder
    func createNewFolder(title: String) -> NoteFolder {
        let context = persistentContainer.viewContext
        
        let newNoteFolder = NSEntityDescription.insertNewObject(forEntityName: "NoteFolder", into: context) as! NoteFolder
        
        newNoteFolder.title = title

        do {
            try context.save()
            return newNoteFolder
        } catch let err {
            print("Failed to save new note folder:", err)
            return newNoteFolder
        }
    }
    
    // 2. fetchNoteFolders
    
    func fetchNoteFolders() -> [NoteFolder] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NoteFolder>(entityName: "NoteFolder")
        
        do {
            let noteFolders = try context.fetch(fetchRequest)
            return noteFolders
        } catch let err {
            print("Failed to fetch new folders with error:", err)
            return []
        }
    }
    
    func deleteNoteFolder(noteFolder: NoteFolder) -> Bool {
        
        let context = persistentContainer.viewContext
        
        // delete
        context.delete(noteFolder)
        // check if saved
        do {
            
            try context.save()
            return true
            
        } catch let err {
            print("Failed to delete note folder entity instance", err)
            return false
        }
    }
    
    // note functions
    
    func createNewNote(title: String, date: Date, text: String, noteFolder: NoteFolder) -> Note {
        let context = persistentContainer.viewContext
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        
        newNote.title = title
        newNote.text = text
        newNote.date = date
        newNote.noteFolder = noteFolder
        
        do {
            try context.save()
            return newNote
        } catch let err {
            print("Failed to save new note folder:", err)
            return newNote
        }
    }
    
    func fetchNotes(from noteFolder: NoteFolder) -> [Note] {
        guard let folderNotes = noteFolder.notes?.allObjects as? [Note] else {return []}
        return folderNotes
    }
    
    func deleteNote(note: Note) -> Bool {
        
        let context = persistentContainer.viewContext
        
        // delete
        context.delete(note)
        // check if saved
        do {
            
            try context.save()
            return true
            
        } catch let err {
            print("Failed to delete note entity instance", err)
            return false
        }
    }
    
    func saveUdatedNote(note: Note, newText: String) {
        let context = persistentContainer.viewContext
        note.title = newText
        note.text = newText
        note.date = Date()
        
        do {
            try context.save()
            
        } catch let err {
            print("Failed to save/udate note", err)
        }
    }
}
