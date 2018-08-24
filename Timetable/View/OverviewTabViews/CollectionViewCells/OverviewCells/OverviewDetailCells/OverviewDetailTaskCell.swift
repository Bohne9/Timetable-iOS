//
//  OverviewDetailTaskCell.swift
//  Timetable
//
//  Created by Jonah Schueller on 12.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class OverviewDetailTaskCell: UICollectionViewCell {
    
    var task: Task? {
        didSet{
            if let task = task {
                reload(task: task)
            }
        }
    }
    
    
    lazy var userLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.bold)
        label.textColor = .gray
        
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.bold)
        label.textColor = .gray
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    private var taskLabelHeightConstraint: NSLayoutConstraint!
    
    lazy var taskLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        label.textColor = .black
        
        return label
    }()
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.gray.cgColor
        layer.cornerRadius = 5
        backgroundColor = .white
        
        setupUserInterface()
    }
    
    private func setupUserInterface(){
        addSubviews()
        
        setupTopBar()
        setupTaskLabel()
    }
    
    private func addSubviews(){
        [taskLabel, dateLabel, userLabel, tableView].forEach { (element) in
            self.addSubview(element)
            element.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupTopBar(){
        userLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        userLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35).isActive = true
        
    }
    
    private func setupTaskLabel(){
        taskLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 15).isActive = true
        taskLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        taskLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        taskLabelHeightConstraint = taskLabel.heightAnchor.constraint(equalToConstant: 100)
        taskLabelHeightConstraint.isActive = true
    }
    
    
    
    private func reload(task: Task) {
        
        let text = task.task
        
        let constraintRect = CGSize(width: frame.width - 30, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: taskLabel.font], context: nil)
        
        let height = ceil(boundingBox.height)
        
        taskLabelHeightConstraint.constant = height
        
        taskLabel.text = text
        
        userLabel.text = task.userID
        
        dateLabel.text = "Posted on:\n" + task.timestamp.dateValue().format(with: "dd.MM.yy")
        
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
