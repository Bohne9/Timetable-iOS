//
//  SubjectMenuSectionView.swift
//  Timetable
//
//  Created by Jonah Schueller on 25.06.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class SubjectMenuSectionViewCell : UICollectionViewCell {
    
    var image: UIImageView = {
        var img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.tintColor = .white
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = #imageLiteral(resourceName: "informatik").withRenderingMode(.alwaysTemplate)
        return img
    }()
    
    var label: UILabel = {
        let l = UILabel()
        l.font = UIFont.robotoBold(15)
        l.textColor = .white
        l.textAlignment = .center
        l.numberOfLines = -1
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = false
        layer.cornerRadius = 5
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.5
        
        backgroundColor = .backgroundContrast
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(image)
        
        image.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        image.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        image.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class SubjectMenuSectionView: MenuSectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let cellIdentifier = "subjectCell"
    
    override init() {
        super.init()
        
        setTitle(translate: "Lessons")
        
        collectionView.register(SubjectMenuSectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        set(delegate: self, dataSource: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Database.database.subjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SubjectMenuSectionViewCell
        
        let subject = getSubject(for: indexPath)
        cell.label.text = subject.lessonName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let viewController = ViewController.controller!
        viewController.subjectViewController.subject = getSubject(for: indexPath)
//        viewController.present(viewController.subjectViewController, animated: true, completion: nil)
        viewController.presentChild(viewController: viewController.subjectViewController)
        viewController.subjectViewController.present()
        
    }
    
    func getSubject(for indexPath: IndexPath) -> Subject {
        return Database.database.subjects[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.layoutIfNeeded()
        
        let height = 100.0 // collectionView.frame.height
        let width = height * 1.3
        
        return CGSize(width: width, height: height)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
