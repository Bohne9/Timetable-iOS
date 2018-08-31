//
//  MaterialPickerViewController.swift
//  Timetable
//
//  Created by Jonah Schueller on 22.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class MaterialPickerViewController: UINavigationController {
    let navigationBarHeight: CGFloat = 150
    let navigationBarTint: UIColor = UIColor(hexString: "#e55039") // Red
    
    var navBar: UINavigationBar!
    
    let materialPickerRootViewController = MaterialPickerRootViewController()
    
    init() {
        super.init(rootViewController: materialPickerRootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidesBarsOnSwipe = false
//        navigationBar.isHidden = true
//        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: navigationBarHeight)
//
//        navBar = UINavigationBar(frame: .zero)
//
//        view.addSubview(navBar)
//
//        navBar.translatesAutoresizingMaskIntoConstraints = false
//        navBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        navBar.heightAnchor.constraint(equalToConstant: navigationBarHeight).isActive = true
//          
//        navBar.isTranslucent = false
//        navBar.backgroundColor = navigationBarTint
//        navBar.barTintColor = navigationBarTint
//
//        additionalSafeAreaInsets = UIEdgeInsetsMake(navigationBarHeight - view.safeAreaInsets.top, 0, 0, 0)
//
//        UINavigationBar.appearance().frame = frame
//        print(navBar.frame)
//        print(view.safeAreaInsets.top)
    }
    
//    private var didUpdateSafeArea = false
//
//    override func viewSafeAreaInsetsDidChange() {
//        super.viewSafeAreaInsetsDidChange()
//
//        if didUpdateSafeArea {
//            didUpdateSafeArea = false
//            return
//        }
//        didUpdateSafeArea = true
//        additionalSafeAreaInsets = UIEdgeInsetsMake(navigationBarHeight - view.safeAreaInsets.top, 0, 0, 0)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MaterialPickerRootViewController: UIViewController {
    
    let navigationBarHeight: CGFloat = 300
    let navigationBarTint: UIColor = UIColor(hexString: "#e55039") // Red
    
    var navigationBar: UINavigationBar? {
        return navigationController?.navigationBar
    }
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MaterialPicker"
        navigationBar?.prefersLargeTitles = true
        navigationBar?.frame.size.height = 300
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.barHideOnSwipeGestureRecognizer.isEnabled = false
        
        // Do any additional setup after loading the view.
        setupUserInterface()
    }

    
    private func setupUserInterface(){
        tableView = UITableView(frame: .zero, style: .grouped)
        
        registerCells()
        view.addSubview(UIView())
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func registerCells(){
        registerCell(cellClass: MaterialPickerTableViewCell.self, withIdentifier: MaterialPickerCellIdentifier)
    }
    
    private func registerCell(cellClass: AnyClass, withIdentifier: String) {
        tableView.register(cellClass, forCellReuseIdentifier: withIdentifier)
    }
}


extension MaterialPickerRootViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MaterialPickerCellIdentifier, for: indexPath) as! MaterialPickerTableViewCell
        cell.textLabel?.text = "Hallo label"
        return cell
    }
    
}


let MaterialPickerCellIdentifier = "MaterialPickerTableViewCell"
class MaterialPickerTableViewCell: UITableViewCell {
    
    
}




