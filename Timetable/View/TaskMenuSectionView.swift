//
//  TaskMenuSectionView.swift
//  Timetable
//
//  Created by Jonah Schueller on 01.07.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit


class TaskMenuSectionViewCell: UICollectionViewCell {
    
    var subject: Subject?
    var task: Task?
    
    var subjectLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.robotoBold(15)
        l.textColor = .white
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var date: UILabel = {
        let l = UILabel()
        l.font = UIFont.robotoBold(15)
        l.textColor = .white
        l.textAlignment = .center
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
        addSubview(date)
        addSubview(subjectLabel)
        
        date.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        date.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        date.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        date.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        subjectLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        subjectLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subjectLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subjectLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TaskMenuSectionView: MenuSectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    let cellIdentifier = "taskCell"
    
    override init() {
        super.init()
        
        setTitle(translate: "Tasks")
        
        collectionView.register(TaskMenuSectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        set(delegate: self, dataSource: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Database.database.tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TaskMenuSectionViewCell
    
        let task = getTask(for: indexPath)
        cell.date.text = task.timestamp.dateValue().format(with: "dd.MM.yyyy")
        let subject = Database.database.getSubject(globalIdentifier: task.subjectIdentifier)!
        cell.subjectLabel.text = subject.lessonName
        
        cell.task = task
        cell.subject = subject
        
        return cell
    }
    
    override func reload() {
        Database.database.tasks.sort { (lhs, rhs) -> Bool in
            return lhs.timestamp.dateValue() > rhs.timestamp.dateValue()
        }
        super.reload()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.layoutIfNeeded()
        
        let height = 100.0 // collectionView.frame.height
        let width = height * 1.3
        
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! TaskMenuSectionViewCell
        ViewController.controller.subjectViewController.open(task: cell.task!, subject: cell.subject!)
//        ViewController.controller.present(ViewController.controller.subjectViewController, animated: true, completion: nil)
        ViewController.controller.presentChild(viewController: ViewController.controller.subjectViewController)
        ViewController.controller.subjectViewController.present()
        
    }
    

    func getTask(for indexPath: IndexPath) -> Task {
        return Database.database.tasks[indexPath.row]
    }
    

}
