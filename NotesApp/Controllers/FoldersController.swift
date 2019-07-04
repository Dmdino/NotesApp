//
//  ViewController.swift
//  NotesApp
//
//  Created by Дмитрий Папушин on 01/07/2019.
//  Copyright © 2019 Дмитрий Папушин. All rights reserved.
//

import UIKit

class FoldersController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    
    fileprivate let headerView: UIView = {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        let label = UILabel(frame: CGRect(x: 20, y: 15, width: 100, height: 20))
        label.text = "ICLOUD"
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = .darkGray
        header.addBorder(toSide: .bottom, withColor: UIColor.lightGray.withAlphaComponent(0.5).cgColor, andThickness: 0.3)
        header.addSubview(label)
        return header
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Folders"
        
        setupTabelView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        let items: [UIBarButtonItem] = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "New Folder", style: .done, target: self, action: nil)
        ]
        
        self.toolbarItems = items
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
        self.navigationItem.setRightBarButton(editButton, animated: false)
        self.navigationController?.toolbar.tintColor = .primaryColor
        self.navigationController?.navigationBar.tintColor = .primaryColor
        
        setupTranslucentViews()
    }
    
    fileprivate func setupTabelView() {
        tableView.register(FolderCell.self, forCellReuseIdentifier: cellId)
        tableView.tableHeaderView = headerView
    }
    
    // create graphic image
    fileprivate func getImage(withColor color: UIColor, andSize size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    // the way how to make a clear navbar
    fileprivate func setupTranslucentViews() {
        let toolBar = self.navigationController?.toolbar
        let navBar = self.navigationController?.navigationBar
        
        // set clarity to toolbar
        let slightWhite = getImage(withColor: UIColor.white.withAlphaComponent(0.9), andSize: CGSize(width: 30, height: 30))
        
        toolBar?.setBackgroundImage(slightWhite, forToolbarPosition: .any, barMetrics: .default)
        toolBar?.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        // set clarity to navigationbar
        navBar?.setBackgroundImage(slightWhite, for: .default)
        navBar?.shadowImage = slightWhite
    }

}

extension FoldersController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FolderCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folderNotesController = FolderNotesController()
        navigationController?.pushViewController(folderNotesController, animated: true)
    }
}

//    override func viewWillDisappear(_ animated: Bool) {
//        super .viewWillAppear(animated)
//
//        self.navigationController?.setToolbarHidden(true, animated: true)
//    }

