//
//  LessonAddSubjectIdentifierTableViewCell.swift
//  Timetable
//
//  Created by Jonah Schueller on 18.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

var LessonAddSubjectIdentifierTableViewCellIdentifer = "LessonAddSubjectIdentifierTableViewCell"
var LessonAddSubjectIdentifierTableViewCellHeight: CGFloat = 150
class LessonAddSubjectIdentifierTableViewCell: AddBodyTableViewCell {

    
    lazy var groupImage: UIImageView = {
        let imageView =  UIImageView(image: #imageLiteral(resourceName: "Group").withRenderingMode(.alwaysOriginal))
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        
        return imageView
    }()
    
    
    lazy var identifierTextField: TextField = {
        let tf = TextField()
        tf.autocorrectionType = .no
        tf.textColor = .gray
        tf.placeholderColor(.lightGray)
        tf.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        tf.textAlignment = .left
        
        tf.placeholder = "Group Identifier"
        
        return tf
    }()
    
    lazy var helpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("HELP", for: .normal)
        
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return btn
    }()
    
    lazy var createGroup: UIButton = {
       let btn = UIButton(type: .system)
        btn.setTitle("CREATE NEW GROUP", for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return btn
    }()
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(groupImage)
        groupImage.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(helpButton)
        helpButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(createGroup)
        createGroup.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(identifierTextField)
        identifierTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
    override func setupUserInterface() {
        super.setupUserInterface()
        
        groupImage.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
        groupImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        groupImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        groupImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        helpButton.centerYAnchor.constraint(equalTo: groupImage.centerYAnchor).isActive = true
        helpButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        helpButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        helpButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        identifierTextField.centerYAnchor.constraint(equalTo: groupImage.centerYAnchor).isActive = true
        identifierTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 65).isActive = true
        identifierTextField.trailingAnchor.constraint(equalTo: helpButton.leadingAnchor, constant: -10).isActive = true
        identifierTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        createGroup.topAnchor.constraint(equalTo: identifierTextField.bottomAnchor, constant: 25).isActive = true
        createGroup.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 65).isActive = true
        createGroup.widthAnchor.constraint(equalToConstant: 200).isActive = true
        createGroup.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    
    
    
}
