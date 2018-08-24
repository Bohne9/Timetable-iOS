//
//  AddViewController.swift
//  Timetable
//
//  Created by Jonah Schueller on 14.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var tableView: UITableView!
    var topSectionHeader: AddTopTableViewHeader!{
        didSet{
            topSectionHeader.titleTextField.text = topSectionTitle
            topSectionHeader.titleTextField.placeholder = topSectionPlaceholder
        }
    }
    
    var topSectionColor: UIColor? {
        didSet{
            topSectionHeader?.backgroundColor = topSectionColor
        }
    }
    
    var topSectionTitle: String?{
        didSet{
            topSectionHeader?.titleTextField.text = topSectionTitle
        }
    }
    
    var topSectionPlaceholder: String?{
        didSet{
            topSectionHeader?.titleTextField.placeholder = topSectionPlaceholder
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set top safe area offset for collectionView cells
        
        UIApplication.shared.statusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
        
        view.backgroundColor = .white
        
        if let navBar = navigationController?.navigationBar {
            navBar.prefersLargeTitles = true
            
            navigationController?.view.layer.masksToBounds = true
            navigationController?.view.layer.cornerRadius = 5
            navigationController?.navigationBar.isHidden = true
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.hidesBarsOnSwipe = false
        }
        
        AddTopTableViewHeader.topOffset = view.safeAreaInsets.top
        
        // Do any additional setup after loading the view.
        setupUserInterface()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUpdate(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUpdate(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardUpdate(notification: NSNotification){
        let userInfo = notification.userInfo!
        
        // get data from the userInfo
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).uintValue << 16
        let animationCurve = UIViewAnimationOptions(rawValue: UInt(rawAnimationCurve))
        
//        bottomLayoutConstraint.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY
        
        // animate the changes
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.beginFromCurrentState, animationCurve], animations: {
            self.tableView.contentOffset.y += keyboardEndFrame.height
            self.tableView.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        print(view.safeAreaInsets)
        AddTopTableViewHeader.topOffset = view.safeAreaInsets.top
        
    }
    
    func registerCellClasses(){
        tableView.register(AddTopTableViewHeader.self, forCellReuseIdentifier: AddTopCollectionViewCellIdentifer)
    }
    
    func register(_ cellClass: AnyClass, with identifier: String){
        tableView.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func register(_ cellClass: AnyClass, header identifier: String){
        tableView.register(cellClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    private var bottomLayoutConstraint: NSLayoutConstraint!
    internal func setupUserInterface(){
    
        tableView = UITableView()
        
       view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topSectionHeader.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomLayoutConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomLayoutConstraint.isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.keyboardDismissMode = .interactive
        
        tableView.backgroundColor = UIColor(hexString: "#FEFEFE")
        
        tableView.tableFooterView = UIView()
        
        registerCellClasses()
        
        tableView.reloadData()
        
    }
    
    func reset(){
        
    }

}

extension AddViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("AddViewController - override 'numberOfSections(in)' to add custom collectionViewCells")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("AddViewController - override 'collectionView(collectionView, numberOfItemsInSection)' to add custom collectionViewCells")
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("AddViewController dequeueCellFor indexPath: \(indexPath) - cannot")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        
        switch section {
        case 0:
            return 200
        case 1 :
            return LessonAddTimeCollectionViewCellHeight
        default:
            return 200
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tableView.becomeFirstResponder()
        
    }
}
