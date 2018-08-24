//
//  LessonAddTopCollectionViewCell.swift
//  Timetable
//
//  Created by Jonah Schueller on 15.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

let LessonAddTopCollectionViewCellIdentifer = "LessonAddTopCollectionViewCellIdentfier"
class LessonAddTopTableViewHeader: AddTopTableViewCell {
    
    lazy var identifierTextField: TextField = {
        let tf = TextField()
        
        tf.textColor = .white
        tf.placeholderColor(UIColor.white.withAlphaComponent(0.7))
        tf.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        tf.isEnabled = false
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        
        return tf
    }()
    
    
    override func setupUserInterface() {
        super.setupUserInterface()
        
        addSubview(identifierTextField)
        identifierTextField.translatesAutoresizingMaskIntoConstraints = false
        
        identifierTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 15).isActive = true
        identifierTextField.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor).isActive = true
        identifierTextField.widthAnchor.constraint(equalTo: titleTextField.widthAnchor).isActive = true
        identifierTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    

}
