//
//  OverviewDetailMaterialCell.swift
//  Timetable
//
//  Created by Jonah Schueller on 13.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class OverviewDetailMaterialCell: UICollectionViewCell {
    
    var material: Material? {
        didSet {
            if let material = material {
                reload(material: material)
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
        return label
    }()
    
    private var taskLabelHeightConstraint: NSLayoutConstraint!
    
    lazy var taskLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        label.textColor = .black
        
        return label
    }()
    
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUserInterface(){
        addSubviews()
        
        setupTopBar()
        setupTaskLabel()
    }
    
    private func addSubviews(){
        [taskLabel, dateLabel, userLabel].forEach { (element) in
            self.addSubview(element)
            element.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupTopBar(){
        userLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        userLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        userLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
        
    }
    
    private func setupTaskLabel(){
        taskLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 15).isActive = true
        taskLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        taskLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        taskLabelHeightConstraint = taskLabel.heightAnchor.constraint(equalToConstant: 100)
        taskLabelHeightConstraint.isActive = true
    }
    
    
    
    private func reload(material: Material) {
        
        let text = material.dataName
        
        let constraintRect = CGSize(width: frame.width - 30, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: taskLabel.font], context: nil)
        
        let height = ceil(boundingBox.height)
        
        taskLabelHeightConstraint.constant = height
        
        taskLabel.text = text
        
        userLabel.text = material.userID
        
        dateLabel.text = "Posted on: " + material.timestamp.dateValue().format(with: "dd.MM.yy")
        
    }
    
    
    
    
}
