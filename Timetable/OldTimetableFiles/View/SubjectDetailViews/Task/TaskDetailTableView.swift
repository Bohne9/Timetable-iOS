//
//  SubjectTaskDetailView.swift
//  Timetable
//
//  Created by Jonah Schueller on 01.07.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//
import MobileCoreServices
import UIKit



class TaskDetailTableView: MasterDetailTableView<Task>, UITableViewDelegate, UITableViewDataSource, UIDocumentPickerDelegate, UINavigationControllerDelegate{

    
    var subject: Subject? {
        didSet{
            if let subject = subject {
                titleLabel.text = "\(subject.lessonName)\n\(titleExtension)"
                reloadData(subject.tasks)
            }
        }
    }
    
    private var todayTasks = [Task]()
    private var weekTasks = [Task]()
    private var previousTasks = [Task]()
    
    // 0: TaskTimeIntervall type, 1: tasks
    var dataStorage: [(timeInterval: TaskTimeIntervall, tasks: [Task])] = []
    
    
    lazy var taskDetailView: SubjectTaskDetailView = {
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
        tableView.register(TaskDetailTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(TaskDetailTableViewCellHeader.self, forHeaderFooterViewReuseIdentifier: headerIdentifier)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataStorage.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : dataStorage[section - 1].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TaskDetailTableViewCell
        
        let task = dataStorage[indexPath.section - 1].tasks[indexPath.row]
    
        cell.setValues(task: task, type: dataStorage[indexPath.section - 1].timeInterval)
    
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.background.lighter(by: 0.1)
        cell.selectedBackgroundView = selectedView
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        let task = dataStorage[indexPath.section - 1].tasks[indexPath.row]
        taskDetailView.data = task
//        taskDetailView.reload(task)
        taskDetailView.fadeIn()
        
        
//        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: UIDocumentPickerMode.import)
//        documentPicker.delegate = self
//        ViewController.controller.present(documentPicker, animated: true, completion: nil)
        
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        if let url = urls.first {
            MaterialManager.addMaterial(url: url, source: .task, sourceID: data[0].taskID) { (material) in
                print("Finished")
            }
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let originalImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
//        let url = info[UIImagePickerControllerReferenceURL] as! URL
//        let imageData = UIImageJPEGRepresentation(originalImage, 100) as Data?
//
//        print("Image: \(url.path)")
//
//        let path = MaterialManager.path("materials", Database.userID, "materials")
//
//        MaterialManager.addMaterial(data: imageData!, source: .task, sourceID: (data[0] ).taskID, dataType: ".jpg", firestorePath: path) { (result) in
//
//        }
//
//        picker.dismiss(animated: true, completion: nil)
//
    }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as! TaskDetailTableViewCellHeader
        
        if section == 0 {
            header.makeTitleHeader(title: "\(subject!.lessonName)\n\(titleExtension)")
        }else {
            header.titleLabel.text = Language.translate(dataStorage[section - 1].timeInterval.rawValue)
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return section == 0 ? frame.height * 0.15 : 50
        return section == 0 ? 70 : 40
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
        taskDetailView.data = task
        taskDetailView.reload(task)
        transform = .identity
        taskDetailView.fadeInLayoutChanges()
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
