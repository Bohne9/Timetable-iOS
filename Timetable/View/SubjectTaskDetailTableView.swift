//
//  SubjectTaskDetailView.swift
//  Timetable
//
//  Created by Jonah Schueller on 01.07.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

enum TaskTimeIntervall: String{
    typealias RawValue = String
    
    case today = "Today"
    case week = "This week"
    case previous = "Previous"
}

class SubjectTaskDetailTableViewCellHeader: UITableViewHeaderFooterView {
    
    var titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .appWhite
        contentView.backgroundColor = .appWhite
        
        titleLabel.addAndConstraint(to: self)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .background
        titleLabel.font = UIFont.robotoBold(30)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SubjectTaskDetailTableViewCell: UITableViewCell {
    
    var taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoBold(18)
        label.textColor = .background
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoBold(15)
        label.textAlignment = .right
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoBold(15)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        addSubview(taskLabel)
        addSubview(dateLabel)
        addSubview(infoLabel)
        
        taskLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -2).isActive = true
        taskLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        taskLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95).isActive = true
        taskLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45).isActive = true
        
        infoLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.66).isActive = true
        infoLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45).isActive = true
        
        backgroundColor = .appWhite
    }
    
    func setValues(task: Task, type: TaskTimeIntervall) {
        taskLabel.text = task.task
        
        if type == .today {
            dateLabel.text = task.timestamp.dateValue().format(with: "hh:mm")
        }else {
            dateLabel.text = task.timestamp.dateValue().format(with: "dd.MM.yy")
        }
        infoLabel.text = "still working on it..."
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class SubjectTaskDetailTableView: MasterDetailTableView<Task>, UITableViewDelegate, UITableViewDataSource{

//    let stackView = UIStackView()
////    var safeArea: UILayoutGuide!
//
//    lazy var dismiss: UIButton = {
//        let btn = UIButton()
//        btn.setImage(#imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate), for: .normal)
//        btn.imageView!.tintColor = .gray
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(btn)
//        btn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
//        btn.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
//        btn.widthAnchor.constraint(equalToConstant: 25).isActive = true
//        btn.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        btn.titleEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
//        return btn
//    }()
//
//    lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.robotoBold(30)
//        label.textColor = .background
//        label.textAlignment = .center
//        label.numberOfLines = -1
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.adjustsFontSizeToFitWidth = true
//
//        return label
//    }()
    
//    let cellIdentifier = "taskTableViewIdentifier"
//    var taskTableView = UITableView()
    
    var subject: Subject? {
        didSet{
            if let subject = subject {
                titleLabel.text = "\(subject.lessonName)\n\(Language.translate("Tasks"))"
                reloadData(subject.tasks)
            }
        }
    }
    
//    var tasks = [Task]()
    
    private var todayTasks = [Task]()
    private var weekTasks = [Task]()
    private var previousTasks = [Task]()
    
    // 0: TaskTimeIntervall type, 1: tasks
    private var dataStorage = [(TaskTimeIntervall, [Task])]()
    
    
    lazy var subjectTaskDetailView: SubjectTaskDetailView = {
        let view = SubjectTaskDetailView()
        view.addAndConstraint(to: self)
        layoutIfNeeded()
        view.fadeOutLayoutChanges()
        return view
    }()
    
    var headerIdentifier = "subjectTaskTableViewHeaderIdentifier"
    
    
    init() {
        super.init(frame: .zero)
        
//        if let view = safeArea.owningView {
//            view.addSubview(self)
//        }
//        
//        self.safeArea = safeArea
        _ = dismiss
        dismissImage = #imageLiteral(resourceName: "back")
        cellIdentifier = "taskTableViewIdentifier"
        
        backgroundColor = .appWhite
        
//        setupUserInterface()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SubjectTaskDetailTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(SubjectTaskDetailTableViewCellHeader.self, forHeaderFooterViewReuseIdentifier: headerIdentifier)
    }
    
    
//    private func setupUserInterface(){
//        translatesAutoresizingMaskIntoConstraints = false
//        addSubview(titleLabel)
//        addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//
////        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
////        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
//        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35).isActive = true
//        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35).isActive = true
//        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15).isActive = true
//
//        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
//        taskTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
//        taskTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
//        taskTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//
//        taskTableView.backgroundColor = .clear
//        taskTableView.tableFooterView = UIView()
//        taskTableView.separatorColor = .background
//
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        let totalTasks = todayTasks.count + weekTasks.count + previousTasks.count
//        return totalTasks > 3 ? 3 : totalTasks
        return dataStorage.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStorage[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SubjectTaskDetailTableViewCell
        
        let task = dataStorage[indexPath.section].1[indexPath.row]
    
        cell.setValues(task: task, type: dataStorage[indexPath.section].0)
    
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        subjectTaskDetailView.data = dataStorage[indexPath.section].1[indexPath.row]
        subjectTaskDetailView.fadeIn()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return dataStorage[section].0.rawValue
//    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//
//        let header = view as! UITableViewHeaderFooterView
//        header.contentView.backgroundColor = .appWhite
//        if let label = header.textLabel {
//            label.addAndConstraint(to: header)
//            label.textAlignment = .left
//            label.textColor = .background
//            label.font = UIFont.robotoBold(25)
//        }
//    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as! SubjectTaskDetailTableViewCellHeader
        header.titleLabel.text = dataStorage[section].0.rawValue
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    /// Remaps the tasks and reloads the tableView
    func reloadData(_ tasks: [Task]? = nil){
        if let tasks = tasks {
            self.data = tasks
        }
        mapTasks()
        tableView.reloadData()
    }
    
    
    func open(_ task: Task, _ subject: Subject){
        self.subject = subject
        subjectTaskDetailView.data = task
        transform = .identity
        subjectTaskDetailView.fadeInLayoutChanges()
        layoutIfNeeded()
    }
    
    /// Maps the Task objects in the SubjecTaskDetailView.tasks list to today, week, and previous tasks based on their timestamp
    private func mapTasks(){
        let day: Double = 60 * 60 * 24 // 60 seconds * 60 minuntes * 24 hours = 1 day
        let week: Double = day * 7 // 60 seconds * 60 minuntes * 24 hours * 7 days = 1 week
        
        // Clear lists to avoid redunancy
        todayTasks = []
        weekTasks = []
        previousTasks = []
        dataStorage = []
        
        data.forEach { (task) in
            let timeDis = task.timestamp.dateValue().timeIntervalSinceNow
            // Check when the task was added. In the past 24h, past 7 days or before
            // The timeDis value must be negated because if timeIntervalSinceNow is negative when date is before now
            
            if -timeDis < day {
                self.todayTasks.append(task)
            }else if -timeDis < week {
                self.weekTasks.append(task)
            }else {
                self.previousTasks.append(task)
            }
        }
        
        todayTasks.sort { (lhs, rhs) -> Bool in
            return lhs.timestamp.dateValue() > rhs.timestamp.dateValue()
        }
        weekTasks.sort { (lhs, rhs) -> Bool in
            return lhs.timestamp.dateValue() > rhs.timestamp.dateValue()
        }
        previousTasks.sort { (lhs, rhs) -> Bool in
            return lhs.timestamp.dateValue() > rhs.timestamp.dateValue()
        }
        
        // Add the data lists to the data list
        // Purpose: In case a list doesn't contain any elements it won't show up in the tableview and there are no empty sections
        if todayTasks.count != 0 {
            dataStorage.append((.today, todayTasks))
        }
        if weekTasks.count != 0 {
            dataStorage.append((.week, weekTasks))
        }
        if previousTasks.count != 0 {
            dataStorage.append((.previous, previousTasks))
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
