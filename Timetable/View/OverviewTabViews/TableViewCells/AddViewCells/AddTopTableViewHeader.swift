//
//  AddTopCollectionViewCell.swift
//  Timetable
//
//  Created by Jonah Schueller on 14.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

let AddTopCollectionViewCellIdentifer = "AddTopCollectionViewCell"

protocol AddTopHeaderActionDelegate {
    func save(_ header: AddTopTableViewHeader, isValid: Bool)
    func cancel(_ header: AddTopTableViewHeader)
    func isValid(_ header: AddTopTableViewHeader) -> Bool
}

extension AddTopHeaderActionDelegate {
    func isValid(_ header: AddTopTableViewHeader) -> Bool {
        return true
    }
}

class AddTopTableViewHeader: UIView {
    
    static var topOffset: CGFloat = 20 {
        didSet{
            print("topOffset set")
        }
    }
    
    static var subjectColor: UIColor = .white
    
    var delegate: AddTopHeaderActionDelegate?
    
    var save: UIButton!
    var dismiss: UIButton!
    
    var tableView: UITableView!
    
    lazy var titleTextField: TextField = {
        let tf = TextField()
        
        tf.textColor = .white
        tf.placeholderColor(UIColor.white.withAlphaComponent(0.7))
        tf.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        
        tf.placeholder = "Subject name"
        
        return tf
    }()
    
    init(superview: UIView) {
        super.init(frame: .zero)
        superview.addSubview(self)
        
        setupUserInterface()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var heightConstraint: NSLayoutConstraint!

    internal func setupUserInterface(){
        addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        save = UIButton()
        dismiss = UIButton()
        
        print(AddTopTableViewHeader.topOffset)
        setupButton(save, with: Language.translate("Save"), target: #selector(handleSave))
        setupButton(dismiss, with: Language.translate("Cancel"), target: #selector(handleCancel))
        
        titleTextField.topAnchor.constraint(equalTo: dismiss.bottomAnchor, constant: 10).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        
        dismiss.topAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        dismiss.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        
        save.topAnchor.constraint(equalTo: dismiss.topAnchor).isActive = true
        save.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        
        save.contentHorizontalAlignment = .right
        dismiss.contentHorizontalAlignment = .left
        
    }
    
    private func setupButton(_ button: UIButton, with title: String, target: Selector) {
        button.setTitle(title.uppercased(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        button.addTarget(self, action: target, for: .touchUpInside)
    }
    
    @objc func handleSave(){
        if let delegate = delegate {
            delegate.save(self, isValid: delegate.isValid(self))
        }
    }
    
    @objc func handleCancel(){
        delegate?.cancel(self)
    }
}
