//
//  OverviewTableViewCell.swift
//  Timetable
//
//  Created by Jonah Schueller on 01.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

let appBlueColor = UIColor(red: 5.0 / 255.0, green: 44.0 / 255.0, blue: 73.0 / 255.0, alpha: 1.0)
let grayColor: UIColor = UIColor.grayscale(gray: 0.9)

class OverviewCollectionViewCell: UICollectionViewCell {
    
    var lesson: TimetableLesson? {
        didSet{
            if let lesson = lesson {
                reload(lesson)
            }
        }
    }

    
    let clockImageSize: CGFloat = 15
    let titleLabelHeight: CGFloat = 30
    let trailingOffset: CGFloat = -15
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
        label.textColor = .white
        
        return label
    }()
    
    lazy var timeStartLabel: UILabel = {
        let label = UILabel()
    
        label.textColor = grayColor
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.bold)
        
        return label
    }()
    
    lazy var timeEndLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = grayColor
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.bold)
        
        return label
    }()
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = grayColor
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.bold)
        label.textAlignment = .right
        return label
    }()
    
    lazy var clockImage: UIImageView = {
        let imageView =  UIImageView(image: #imageLiteral(resourceName: "clock").withRenderingMode(.alwaysTemplate))
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = grayColor
        
        return imageView
    }()
    
    lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = grayColor
        view.layer.cornerRadius = 2
        view.alpha = 0.8
        
        return view
    }()
    
    // Dot color: #f5635a
    lazy var taskImage: UIImageView = {
        let imageView =  UIImageView(image: #imageLiteral(resourceName: "redDot").withRenderingMode(.alwaysTemplate))
        imageView.alpha = 0.8
        imageView.tintColor = .white
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var taskLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = grayColor
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupUserInterface()
    }

    
    private func setupUserInterface(){
        addSubviews()
        
        constraintClockImage()
        constraintSeparatorLine()
        constraintTimeStartLabel()
        constraintTimeEndLabel()
        constraintDayLabel()
        constraintTitleLabel()
        constraintTaskInformation()
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowRadius = 7.0
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.8
        layer.cornerRadius = 10
        layer.masksToBounds = false
        
    }
    
    
    private func addSubviews(){
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(clockImage)
        clockImage.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(separatorLine)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(timeStartLabel)
        timeStartLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(timeEndLabel)
        timeEndLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(taskImage)
        taskImage.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(taskLabel)
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func constraintTitleLabel(){
        titleLabel.topAnchor.constraint(equalTo: timeStartLabel.bottomAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: clockImage.trailingAnchor, constant: clockImageSize / 2).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingOffset).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: titleLabelHeight).isActive = true
    }
    
    private func constraintClockImage(){
        clockImage.topAnchor.constraint(equalTo: topAnchor, constant: clockImageSize / 2).isActive = true
        clockImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: clockImageSize).isActive = true
        clockImage.widthAnchor.constraint(equalToConstant: clockImageSize).isActive = true
        clockImage.heightAnchor.constraint(equalToConstant: clockImageSize).isActive = true
    }
    
    private func constraintSeparatorLine(){
        separatorLine.centerXAnchor.constraint(equalTo: clockImage.centerXAnchor).isActive = true
        separatorLine.topAnchor.constraint(equalTo: clockImage.bottomAnchor, constant: 3).isActive = true
        separatorLine.widthAnchor.constraint(equalToConstant: 3).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -clockImageSize / 2).isActive = true
    }
    
    private func constraintTimeStartLabel(){
        timeStartLabel.topAnchor.constraint(equalTo: clockImage.topAnchor).isActive = true
        timeStartLabel.leadingAnchor.constraint(equalTo: clockImage.trailingAnchor, constant: clockImageSize / 2).isActive = true
        timeStartLabel.trailingAnchor.constraint(equalTo: centerXAnchor).isActive = true
        timeStartLabel.heightAnchor.constraint(equalTo: clockImage.heightAnchor).isActive = true
    }
    
    private func constraintTimeEndLabel(){
        timeEndLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -clockImageSize / 2).isActive = true
        timeEndLabel.leadingAnchor.constraint(equalTo: clockImage.trailingAnchor, constant: clockImageSize / 2).isActive = true
        timeEndLabel.trailingAnchor.constraint(equalTo: centerXAnchor).isActive = true
        timeEndLabel.heightAnchor.constraint(equalTo: clockImage.heightAnchor).isActive = true
    }
    
    private func constraintDayLabel(){
        dayLabel.topAnchor.constraint(equalTo: clockImage.topAnchor).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: timeStartLabel.trailingAnchor, constant: clockImageSize / 2).isActive = true
        dayLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingOffset).isActive = true
        dayLabel.heightAnchor.constraint(equalTo: clockImage.heightAnchor).isActive = true
    }
    
    private func constraintTaskInformation(){
        taskImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        taskImage.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        taskImage.widthAnchor.constraint(equalToConstant: clockImageSize * 0.75).isActive = true
        taskImage.heightAnchor.constraint(equalTo: taskImage.widthAnchor).isActive = true
        
        taskLabel.centerYAnchor.constraint(equalTo: taskImage.centerYAnchor).isActive = true
        taskLabel.leadingAnchor.constraint(equalTo: taskImage.trailingAnchor, constant: 5).isActive = true
        taskLabel.trailingAnchor.constraint(equalTo: centerXAnchor, constant: 20).isActive = true
        taskLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    
    
    func reload(_ lesson: TimetableLesson) {
        
        titleLabel.text = lesson.lessonName
        
        timeStartLabel.text = lesson.startTime.description.uppercased()
        timeEndLabel.text = lesson.endTime.description.uppercased()
        lesson.loadTargetTasks()
        
        dayLabel.text = Language.translate("Day_\(lesson.day)").uppercased()
        
        let targetTasks = lesson.taskTargets.count
        
        taskImage.isHidden = targetTasks == 0
        taskLabel.isHidden = targetTasks == 0
        
        
        if targetTasks != 0 {
            let text = "\(targetTasks) \(targetTasks == 1 ? "Task" : "Tasks") to do"
            taskLabel.text = text
        }
        
        if lesson.lessonName == "Informatik" {
            backgroundColor = UIColor(hexString: "#6a89cc")
        }else if lesson.lessonName == "Sport" {
            backgroundColor = UIColor(hexString: "#e55039")
        }else if lesson.lessonName == "Deutsch" {
            backgroundColor = UIColor(hexString: "#fa983a")
        }else if lesson.lessonName == "Englisch" {
            backgroundColor = UIColor(hexString: "#38ada9")
        }        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
