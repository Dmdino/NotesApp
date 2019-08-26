//
//  FolderCell.swift
//  NotesApp
//
//  Created by Дмитрий Папушин on 04/07/2019.
//  Copyright © 2019 Дмитрий Папушин. All rights reserved.
//

import UIKit

class FolderCell: UITableViewCell {
    
    // MARK: - Properties
    
    var folderData: NoteFolder?{
        didSet {
            guard let folderData = folderData else {return}
            label.text = folderData.title
            let count = CoreDataManager.shared.fetchNotes(from: folderData).count
            countLabel.text = String(count)
        }
    }
    
     var label: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
     var countLabel:UILabel = {
        let label = UILabel()
        label.text = "5"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
     lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [label, countLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(stack)
        stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
