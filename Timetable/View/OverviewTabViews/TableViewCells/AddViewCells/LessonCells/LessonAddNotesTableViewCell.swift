//
//  LessonAddNotesTableViewCell.swift
//  Timetable
//
//  Created by Jonah Schueller on 20.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit


var LessonAddNotesTableViewCellHeight: CGFloat = 75
let LessonAddNotesTableViewCellIdentifier = "LessonAddNotesTableViewCell"

class LessonAddNotesTableViewCell: AddBodyTableViewCell, UITextViewDelegate {
    
    lazy var notesImage: UIImageView = {
        let imageView =  UIImageView(image: #imageLiteral(resourceName: "Notes").withRenderingMode(.alwaysOriginal))
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        
        return imageView
    }()
    
    lazy var notesTextView: TextView = {
        let tf = TextView()
        tf.textColor = .lightGray
        tf.text = "Notiz hinzufügen"
        tf.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        tf.textAlignment = .left
        tf.isScrollEnabled = false
        tf.delegate = self
        
        return tf
    }()
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.textColor = .gray
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Notiz hinzufügen"
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.last == "\n" {
            recalcualteTextViewHeight()
        }
    }
    
    
    private func recalcualteTextViewHeight(){
        let maxSize = CGSize(width: notesTextView.frame.width, height: .greatestFiniteMagnitude)
        let size = notesTextView.sizeThatFits(maxSize)
        
        LessonAddNotesTableViewCellHeight = size.height + 50 // + top and bottom offset
        
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        UIView.setAnimationsEnabled(true)
        
        tableView.layoutIfNeeded()
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(notesImage)
        notesImage.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(notesTextView)
        notesTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    override func setupUserInterface() {
        super.setupUserInterface()
        
        notesImage.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
        notesImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        notesImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        notesImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
       
        notesTextView.topAnchor.constraint(equalTo: notesImage.topAnchor).isActive = true
        notesTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 65).isActive = true
        notesTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        notesTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
        
        let maxSize = CGSize(width: notesTextView.frame.width, height: .greatestFiniteMagnitude)
        let size = notesTextView.sizeThatFits(maxSize)
        
        LessonAddNotesTableViewCellHeight = size.height + 50 // + top and bottom offset
        
    }
}
