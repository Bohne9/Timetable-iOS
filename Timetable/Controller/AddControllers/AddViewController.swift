//
//  AddViewController.swift
//  Timetable
//
//  Created by Jonah Schueller on 14.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{

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
    
    private var selectedTextField: UITextField?
    private var selectedTextView: UITextView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set top safe area offset for collectionView cells
        
        UIApplication.shared.statusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
        
        view.backgroundColor = .white
        
        if let navBar = navigationController?.navigationBar {
            navBar.prefersLargeTitles = true
            navBar.isTranslucent = false
        }
        
        AddTopTableViewHeader.topOffset = view.safeAreaInsets.top
        
        // Add an empty UIView to prevent the navigationBar from shrining while scrolling
        view.addSubview(UIView())
        
        // Do any additional setup after loading the view.
        setupUserInterface()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    internal var keyboardSize: CGRect?
    
    func keyboardWillShow(keyboardSize: CGRect?) {
        guard let keyboardSize = keyboardSize else{
            return
        }
        self.keyboardSize = keyboardSize
        let contentInsets = UIEdgeInsets(top: self.tableView.contentInset.top, left: 0, bottom: keyboardSize.height, right: 0)
        self.tableView.contentInset = contentInsets
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect: CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        let selectedTextFieldRect: CGRect?
        let selectedTextFieldOrigin: CGPoint?
        
        if self.selectedTextField != nil {
            print("activeTextField not nil !")
            selectedTextFieldRect = self.selectedTextField?.superview?.frame
            selectedTextFieldOrigin = selectedTextFieldRect?.origin
            self.tableView.scrollRectToVisible(selectedTextFieldRect!, animated:true)
        }
        else if self.selectedTextView != nil {
            print("activeTextView not nil !")
            selectedTextFieldRect = self.selectedTextView?.superview?.frame
            selectedTextFieldOrigin = selectedTextFieldRect?.origin
            self.tableView.scrollRectToVisible(selectedTextFieldRect!, animated:true)
        }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardWillShow(keyboardSize: keyboardSize)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: self.tableView.contentInset.top, left: 0, bottom: 0, right: 0)
//        bottomLayoutConstraint.constant = 0
//        view.layoutIfNeeded()
        self.tableView.contentInset = contentInsets
        self.selectedTextField = nil
        self.selectedTextView = nil
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("Should begin editing")
        self.selectedTextField = textField
        return true;
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("Should begin editing")
        self.selectedTextView = textView
        return true;
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
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
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
    
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        selectedTextView = nil
//        selectedTextField = textField
//    }
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        selectedTextView = textView
//        selectedTextField = nil
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
