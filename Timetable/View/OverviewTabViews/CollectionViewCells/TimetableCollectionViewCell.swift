//
//  TimetableCollectionViewCell.swift
//  Timetable
//
//  Created by Jonah Schueller on 05.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class TimetableCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var timetableDay: TimetableDay? {
        didSet{
            if let day = timetableDay{
                reload(day: day)
            }
        }
    }
    
    let lessonCount: UILabel = {
        let label = UILabel()
        label.font = .robotoBold(20)
        label.tintColor = .background
        return label
    }()
    
    let today: UILabel = {
        let label = UILabel()
        label.font = .robotoBold(14)
        label.textAlignment = .right
        label.tintColor = .interaction
        return label
    }()
    
    let lessonTable = UITableView(frame: .zero, style: .grouped)
    let cellIdentifier = "TimetableCollectionViewCellIdentifer"
    
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
        setupBarLabel()
        setupTableView()
    }
    
    private func setupBarLabel(){
        addSubview(lessonCount)
        addSubview(today)
        
        lessonCount.translatesAutoresizingMaskIntoConstraints = false
        today.translatesAutoresizingMaskIntoConstraints = false
        
        lessonCount.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        lessonCount.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        lessonCount.trailingAnchor.constraint(equalTo: centerXAnchor).isActive = true
        lessonCount.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        today.topAnchor.constraint(equalTo: topAnchor).isActive = true
        today.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 5).isActive = true
        today.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        today.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    private func setupTableView(){
        addSubview(lessonTable)
        
        lessonTable.translatesAutoresizingMaskIntoConstraints = false
        lessonTable.backgroundColor = .white
        lessonTable.topAnchor.constraint(equalTo: lessonCount.bottomAnchor, constant: 10).isActive = true
        lessonTable.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lessonTable.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lessonTable.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        lessonTable.register(TimetableLessonCellTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        lessonTable.separatorColor = .clear
        
        lessonTable.layer.cornerRadius = layer.cornerRadius
        
        lessonTable.delegate = self
        lessonTable.dataSource = self
    }
    
    func reload(day: TimetableDay){
        day.sort()
        let count = day.lessons.count
        
        lessonCount.text = String(count) + " " + (count == 1 ? Language.translate("Lesson") : Language.translate("Lessons"))
        
        lessonTable.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let day = timetableDay {
            return day.lessons.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TimetableLessonCellTableViewCell
        
        if let lesson = timetableDay?.lessons[indexPath.row] {
            cell.lesson = lesson
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
