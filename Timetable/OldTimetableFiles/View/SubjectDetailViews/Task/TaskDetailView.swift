//
//  SubjectTaskDetailView.swift
//  Timetable
//
//  Created by Jonah Schueller on 03.07.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit


class SubjectTaskDetailView: MasterDetailView<Task>, UITableViewDelegate, UITableViewDataSource {
    
    let taskTextView = UITextView()
    
    let materialTitle = UILabel()
    let materialTableView = UITableView()
    
    let creatorLabel = UILabel()
    
    let cellIdentifier = "materialTableViewCell"
    
    init() {
        super.init(frame: .zero)
//        print("\(safeArea.owningView)")
//        if let view = safeArea.owningView {
//            view.addSubview(self)
//        }
        
        title = Language.translate("Task")
        dismissImage = #imageLiteral(resourceName: "back")
        materialTitle.text = "Materials"
        materialTableView.backgroundColor = .background
        materialTableView.separatorColor = .clear
        
        backgroundColor = .background
        
        addStackedView(taskTextView, horizontalBounds: 30, height: 150)
        setupUILabel(materialTitle, fontSize: 20)
        addStackedView(materialTableView, horizontalBounds: 30, height: 150)
        
        taskTextView.isEditable = false
        
        taskTextView.font = UIFont.robotoBold(16)
        taskTextView.textColor = .appWhite
        taskTextView.backgroundColor = .background
        taskTextView.isScrollEnabled = false
        
        materialTableView.register(MaterialDetailTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        materialTableView.delegate = self
        materialTableView.dataSource = self
        
    }
    
    
    private func setupUILabel(_ label: UILabel, fontSize: CGFloat, height: CGFloat? = nil) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.robotoBold(fontSize)
        label.textColor = .appWhite
        
        addStackedView(label, height: height)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.materials.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MaterialDetailTableViewCell
        let material = data!.materials[indexPath.row]
        
        print("TableViewCell: \(material.url.lastPathComponent)")
        let cellTitle = " \u{25CF} \(material.url.lastPathComponent)"
        cell.nextImg.removeFromSuperview()
        cell.materialLabel.text = cellTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    override func reload(_ data: Task) {
        super.reload(data)
        taskTextView.text = data.task
        materialTableView.reloadData()
        layoutIfNeeded()
    }
    
    override func fadeInLayoutChanges() {
        super.fadeInLayoutChanges()
        transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    override func fadeOutLayoutChanges() {
        super.fadeOutLayoutChanges()
        transform = CGAffineTransform(translationX: frame.width, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
