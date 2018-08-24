//
//  OverviewDetailTopCell.swift
//  Timetable
//
//  Created by Jonah Schueller on 11.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class OverviewDetailTopCell: UICollectionViewCell{
    
    static var topOffset: CGFloat = 0
    static var subjectColor: UIColor = .white
    
    var lesson: TimetableLesson? {
        didSet{
            if let lesson = lesson {
                reload(lesson: lesson)
            }
        }
    }
    
    lazy var titleTextField: TextField = {
        let tf = TextField()
        
        tf.textColor = .white
        tf.placeholderColor(UIColor.white.withAlphaComponent(0.7))
        tf.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        tf.isEnabled = false
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        
        return tf
    }()
    
    lazy var identifierTextField: TextField = {
        let tf = TextField()
        
        tf.textColor = .white
        tf.placeholderColor(UIColor.white.withAlphaComponent(0.4))
        tf.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        tf.placeholder = "Tap to add a subject identifer..."
        tf.isEnabled = false
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        
        return tf
    }()
    
    lazy var timeStartTextField: TextField = {
        let tf = TextField()
        
        tf.textColor = grayColor
        tf.placeholderColor(UIColor.white.withAlphaComponent(0.7))
        tf.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.bold)
        tf.isEnabled = false
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        
        tf.textAlignment = .center
        
        return tf
    }()
    
    lazy var timeEndTextField: TextField = {
        let tf = TextField()
        
        tf.textColor = grayColor
        tf.placeholderColor(UIColor.white.withAlphaComponent(0.7))
        tf.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.bold)
        tf.isEnabled = false
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        tf.textAlignment = .center
        
        return tf
    }()
    
    lazy var dayTextField: TextField = {
        let tf = TextField()
        
        tf.textColor = grayColor
        tf.placeholderColor(UIColor.white.withAlphaComponent(0.7))
        tf.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.bold)
        tf.isEnabled = false
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        
        tf.textAlignment = .right
        
        return tf
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUserInterface()
    }

    
    private func setupUserInterface(){
        addUIElements()
        
        setupTimeElements()
        setupTitleLabel()
    }
    
    private func addUIElements(){
        [titleTextField, timeStartTextField, timeEndTextField, dayTextField, identifierTextField].forEach { (element) in
            self.addSubview(element)
            element.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupTimeElements(){
        timeStartTextField.topAnchor.constraint(equalTo: topAnchor, constant: 20 + OverviewDetailTopCell.topOffset).isActive = true
        timeStartTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        timeStartTextField.widthAnchor.constraint(equalToConstant: 80).isActive = true
        timeStartTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        timeEndTextField.topAnchor.constraint(equalTo: timeStartTextField.topAnchor).isActive = true
        timeEndTextField.leadingAnchor.constraint(equalTo: timeStartTextField.trailingAnchor, constant: 15).isActive = true
        timeEndTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeEndTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        dayTextField.topAnchor.constraint(equalTo: timeStartTextField.topAnchor).isActive = true
        dayTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        dayTextField.widthAnchor.constraint(equalToConstant: 150).isActive = true
        dayTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setupTitleLabel(){
        titleTextField.topAnchor.constraint(equalTo: timeStartTextField.bottomAnchor, constant: 25).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        identifierTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 25).isActive = true
        identifierTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        identifierTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        identifierTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func edit(){
        
        [titleTextField, timeStartTextField, timeEndTextField, dayTextField].forEach { (element) in
            element.isEnabled = true
            element.backgroundColor = UIColor(hexString: "#eb2f06")
        }
    }
    
    
    
    private func reload(lesson: TimetableLesson) {
        titleTextField.text = lesson.lessonName
        
        timeStartTextField.text = lesson.startTime.description.uppercased()
        timeEndTextField.text = lesson.endTime.description.uppercased()
        
        dayTextField.text = Language.translate("Day_\(lesson.day)").uppercased()
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
