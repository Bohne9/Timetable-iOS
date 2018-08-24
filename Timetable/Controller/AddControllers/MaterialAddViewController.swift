//
//  MaterialAddViewController.swift
//  Timetable
//
//  Created by Jonah Schueller on 21.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class MaterialAddViewController: AddViewController {

    private lazy var titleView = MaterialAddTopTableViewHeader(superview: view)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        titleView.heightConstraint.constant = navigationController!.navigationBar.frame.height + view.safeAreaInsets.top
    }
    
    override func setupUserInterface() {
        topSectionHeader = titleView
        topSectionPlaceholder = "Subject name"
        topSectionColor = UIColor(hexString: "#e55039")
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        titleView.delegate = self
        
        titleView.heightConstraint = titleView.heightAnchor.constraint(equalToConstant: navigationController!.navigationBar.frame.height + AddTopTableViewHeader.topOffset)
        titleView.heightConstraint.isActive = true
        
        super.setupUserInterface()
    }
    
    
    override func registerCellClasses() {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension MaterialAddViewController: AddTopHeaderActionDelegate {
    func save(_ header: AddTopTableViewHeader, isValid: Bool) {
        
        self.navigationController?.dismiss(animated: true) {
            self.reset()
        }
    }
    
    func cancel(_ header: AddTopTableViewHeader) {
        self.navigationController?.dismiss(animated: true) {
            self.reset()
        }
    }
    
    func isValid(_ header: AddTopTableViewHeader) -> Bool {
        return true
    }
}
