//
//  NotesCell.swift
//  NotesApp
//
//  Created by Дмитрий Папушин on 04/07/2019.
//  Copyright © 2019 Дмитрий Папушин. All rights reserved.
//

import UIKit

class NotesCell: UITableViewCell {
    
    // MARK: - Properties
    
    var noteData: Note? {
        didSet {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd/MM/yy"
            guard let noteData = noteData else {return}
            noteLabel.text = noteData.title
            dateLabel.text = dateFormater.string(from: noteData.date ?? Date())
            previewLabel.text = noteData.text
        }
    }
    
     var noteLabel: UILabel = {
        let label = UILabel()
        label.text = "Place for text"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
     var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "9/15/97"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .gray
        return label
    }()
    
     var previewLabel: UILabel = {
        let label = UILabel()
        label.text = "the note text will go here to create a preview...."
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = UIColor.gray.withAlphaComponent(0.8)
        return label
    }()
    
     lazy var horizontalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dateLabel, previewLabel, UIView()])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .leading
        return stack
    }()
    
     lazy var verticalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [noteLabel, horizontalStackView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(verticalStackView)
        verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        verticalStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
