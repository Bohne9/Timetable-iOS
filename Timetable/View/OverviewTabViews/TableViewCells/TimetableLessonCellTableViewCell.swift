//
//  TimetableLessonCellTableViewCell.swift
//  Timetable
//
//  Created by Jonah Schueller on 05.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class TimetableLessonCellTableViewCell: UITableViewCell {

    var lesson: TimetableLesson? {
        didSet{
            if let lesson = lesson {
                reload(lesson: lesson)
            }
        }
    }
    
    let title: UILabel = {
        let label = UILabel()
        label.font = .robotoBold(15)
        label.tintColor = .background
        return label
    }()
    
    let info: UILabel = {
        let label = UILabel()
        label.font = .robotoBold(12)
        label.tintColor = .gray
        return label
    }()
    
    let room: UILabel = {
        let label = UILabel()
        label.font = .robotoBold(12)
        label.tintColor = .gray
        return label
    }()
    
    let now: UILabel = {
        let label = UILabel()
        label.font = .robotoBold(12)
        label.tintColor = .gray
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUserInterface()
        
    }
    
    private func setupUserInterface(){
        setupTitleLabel()
        setupNowLabel()
        setupInfoLabel()
        setupRoomLabel()
    }
    
    private func setupTitleLabel(){
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        title.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true
        title.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
    }
    
    private func setupNowLabel(){
        addSubview(now)
        now.translatesAutoresizingMaskIntoConstraints = false
        now.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
        now.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        now.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15).isActive = true
        now.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
    }
    
    private func setupInfoLabel(){
        addSubview(info)
        info.translatesAutoresizingMaskIntoConstraints = false
        info.topAnchor.constraint(equalTo: centerYAnchor).isActive = true
        info.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        info.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65).isActive = true
        info.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
    }
    
    private func setupRoomLabel(){
        addSubview(room)
        room.translatesAutoresizingMaskIntoConstraints = false
        room.topAnchor.constraint(equalTo: centerYAnchor).isActive = true
        room.trailingAnchor.constraint(equalTo: leadingAnchor, constant: -5).isActive = true
        room.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        room.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload(lesson: TimetableLesson){
        title.text = lesson.lessonName
        room.text = lesson.info
        info.text = lesson.startTime.description + "-" + lesson.endTime.description
        
        let date = Date()
        let formatedDate = date.format(with: "hh:mm")
        let timeValue = Time(formatedDate).value
        
        if timeValue >= lesson.startValue && timeValue <= lesson.endValue {
            now.text = Language.translate("Now").uppercased()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
