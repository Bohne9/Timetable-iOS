//
//  SubjectTaskDetailView.swift
//  Timetable
//
//  Created by Jonah Schueller on 01.07.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//
import MobileCoreServices
import UIKit

enum TaskTimeIntervall: String{
    typealias RawValue = String
    
    case today = "Today"
    case week = "This week"
    case previous = "MoreThanAWeek"
}


class SubjectTaskDetailTableViewCellHeader: UITableViewHeaderFooterView {
    
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

class SubjectTaskDetailTableViewCell: UITableViewCell {
    
    var taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoBold(15)
        label.textColor = .appWhite
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoBold(13)
        label.textAlignment = .right
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoBold(13)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    var nextImg: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "next").withRenderingMode(.alwaysTemplate)
        img.tintColor = .gray
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
        taskLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: nextImg.leadingAnchor, constant: -4).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45).isActive = true
        
        infoLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -2).isActive = true
        infoLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45).isActive = true
        
        backgroundColor = .background
        
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


class SubjectTaskDetailTableView: MasterDetailTableView<Task>, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{


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
        
        _ = dismiss
        dismissImage = #imageLiteral(resourceName: "back")
        cellIdentifier = "taskTableViewIdentifier"
        
        titleExtension = Language.translate("Tasks")
        
        backgroundColor = .background
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SubjectTaskDetailTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(SubjectTaskDetailTableViewCellHeader.self, forHeaderFooterViewReuseIdentifier: headerIdentifier)
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataStorage.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStorage[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SubjectTaskDetailTableViewCell
        
        let task = dataStorage[indexPath.section].1[indexPath.row]
    
        cell.setValues(task: task, type: dataStorage[indexPath.section].0)
    
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.background.lighter(by: 0.1)
        cell.selectedBackgroundView = selectedView
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        subjectTaskDetailView.data = dataStorage[indexPath.section].1[indexPath.row]
        subjectTaskDetailView.fadeIn()
        
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        ViewController.controller.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        let url = info[UIImagePickerControllerReferenceURL] as! URL
        let imageData = UIImageJPEGRepresentation(originalImage, 100) as Data?
        
        print("Image: \(url.path)")
        
        let path = MaterialManager.path("materials", Database.userID, "materials")
        MaterialManager.addMaterial(data: imageData!, source: .task, sourceID: (data[0] as! Task).taskID, dataType: ".jpg", firestorePath: path)
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = UIColor.appWhite
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as! SubjectTaskDetailTableViewCellHeader
        header.titleLabel.text = Language.translate(dataStorage[section].0.rawValue)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func reload() {
        super.reload()
        reloadData(subject?.tasks)
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
