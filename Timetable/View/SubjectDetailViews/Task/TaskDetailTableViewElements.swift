//
//  TaskDetailTableViewElements.swift
//  Timetable
//
//  Created by Jonah Schueller on 29.07.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

enum TaskTimeIntervall: String{
    typealias RawValue = String
    
    case today = "Today"
    case week = "This week"
    case previous = "MoreThanAWeek"
}


class TaskDetailTableViewCellHeader: UITableViewHeaderFooterView {
    
    var titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .background
        
        titleLabel.addAndConstraint(to: self)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .appWhite
        titleLabel.font = UIFont.robotoBold(20)
        
        let lp = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        addGestureRecognizer(lp)
    }
    
    @objc func longPress(){
        print("longpress")
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "DELETE", style: .default) { (action) in
            print("DELETED")
        }
        actionSheet.addAction(deleteAction)
        
        ViewController.controller.present(actionSheet, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TaskDetailTableViewCell: UITableViewCell {
    
    var taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoBold(15)
        label.textColor = .appWhite
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoMedium(13)
        label.textAlignment = .right
        label.numberOfLines = 0
        label.textColor = UIColor.appWhite.withAlphaComponent(0.75)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoMedium(13)
        label.numberOfLines = 0
        label.textColor = UIColor.appWhite.withAlphaComponent(0.75)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    var nextImg: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "next").withRenderingMode(.alwaysTemplate)
        img.tintColor = UIColor.appWhite.withAlphaComponent(0.75)
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(taskLabel)
        addSubview(dateLabel)
        addSubview(infoLabel)
        addSubview(nextImg)
        
        nextImg.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nextImg.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nextImg.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        nextImg.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        taskLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -2).isActive = true
        taskLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        taskLabel.trailingAnchor.constraint(equalTo: nextImg.leadingAnchor, constant: -4).isActive = true
        taskLabel.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.45).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: nextImg.leadingAnchor, constant: -4).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        dateLabel.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.45).isActive = true
        
        infoLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -2).isActive = true
        infoLabel.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.45).isActive = true
        
        backgroundColor = .background
        
    }
    
    
    func setValues(task: Task, type: TaskTimeIntervall) {
        taskLabel.text = task.task
        
        if type == .today {
            dateLabel.text = task.timestamp.dateValue().format(with: "hh:mm")
        }else {
            dateLabel.text = task.timestamp.dateValue().format(with: "dd.MM.yy")
        }
        let materialCount = task.materials.count
        
        if materialCount != 0{
            infoLabel.text = "+ \(materialCount) " + (materialCount == 1 ? Language.translate("Material") : Language.translate("Materials"))
        }else {
            infoLabel.text = "\u{25CF} \(Language.translate("ZeroWord")) \(Language.translate("Materials"))"
        }
        taskLabel.sizeToFit()
        dateLabel.sizeToFit()
        infoLabel.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
