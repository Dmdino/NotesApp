//
//  NoteDetailController.swift
//  NotesApp
//
//  Created by Дмитрий Папушин on 03/07/2019.
//  Copyright © 2019 Дмитрий Папушин. All rights reserved.
//

import UIKit

protocol NoteDelegate {
    func saveNewNote(title: String, date: Date, text: String)
}

class NoteDetailController: UIViewController {
    
    // MARK: - Properties
    
    let dateFormatter: DateFormatter = {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd MMMM, yyyy, 'at' hh:mm a"
        return dateFormater
    }()
    
    var noteData: Note? {
        didSet {
            guard let noteData = noteData else {return}
            textView.text = noteData.title
            dateLabel.text = dateFormatter.string(from: noteData.date ?? Date())
        }
    }
    
    var delegate: NoteDelegate?
    
    fileprivate let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = ""
        tv.isEditable = true
        tv.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return tv
    }()
    
    fileprivate lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .lightGray
        label.text = dateFormatter.string(from: Date())
        label.textAlignment = .center
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.noteData == nil {
            delegate?.saveNewNote(title: textView.text, date: Date(), text: textView.text)
        } else {
            // update note
            guard let newText = textView.text else {return}
            guard let noteData = self.noteData else {return}
            CoreDataManager.shared.saveUdatedNote(note: noteData, newText: newText)
        }
    }
    
    // MARK: - Constraints
    
    fileprivate func setupUI() {
        view.addSubview(textView)
        view.addSubview(dateLabel)
        
        dateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        textView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let items: [UIBarButtonItem] = [
            UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .camera, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .compose, target: nil, action: nil)
        ]
        
        self.toolbarItems = items
        
        let topItems:[UIBarButtonItem] = [
            UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
        ]
        
        self.navigationItem.setRightBarButtonItems(topItems, animated: false)
    }
}
