//
//  LessonAddViewController.swift
//  Timetable
//
//  Created by Jonah Schueller on 14.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//


import UIKit

class LessonAddViewController: AddViewController, UINavigationBarDelegate {
    
    private lazy var titleView = LessonAddTopTableViewHeader(superview: self.navigationController!.navigationBar)
    
    override func setupUserInterface() {
        topSectionPlaceholder = "Subject name"
        topSectionColor = UIColor(hexString: "#6a89cc")
        
        topSectionHeader = titleView
        
        titleView.backgroundColor = UIColor(hexString: "#6a89cc")
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        let navBar = self.navigationController!.navigationBar
        
        titleView.topAnchor.constraint(equalTo: navigationController!.view.topAnchor).isActive = true
        titleView.leadingAnchor.constraint(equalTo: navBar.leadingAnchor).isActive = true
        titleView.trailingAnchor.constraint(equalTo: navBar.trailingAnchor).isActive = true
        titleView.bottomAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        titleView.delegate = self
        
//        titleView.heightConstraint = titleView.heightAnchor.constraint(equalToConstant: navigationController!.navigationBar.frame.height + AddTopTableViewHeader.topOffset)
//        titleView.heightConstraint.isActive = true
//
//
        super.setupUserInterface()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        switch section {
        case 0:
            let cell = deqeueTimeCell(for: indexPath)
            return cell
        case 1:
            let cell = deqeueSubjectIdentifierCell(for: indexPath)
            
            return cell
        case 2:
            let cell = deqeueNotesCell(for: indexPath)
            
            return cell
        case 3, 4:
            let cell = deqeueSubjectIdentifierCell(for: indexPath)
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    private var timeCell: LessonAddTimeTableViewCell?
    private func deqeueTimeCell(for indexPath: IndexPath) -> LessonAddTimeTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LessonAddTimeCollectionViewCellIdentifer, for: indexPath) as! LessonAddTimeTableViewCell
        cell.selectionStyle = .none
        timeCell = cell
        cell.tableView = tableView
        return cell
    }
    
    var subjectIdentiferCell: LessonAddSubjectIdentifierTableViewCell?
    private func deqeueSubjectIdentifierCell(for indexPath: IndexPath) -> LessonAddSubjectIdentifierTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LessonAddSubjectIdentifierTableViewCellIdentifer, for: indexPath) as! LessonAddSubjectIdentifierTableViewCell
        cell.selectionStyle = .none
        cell.tableView = tableView
        cell.textFieldDelegate = self
        subjectIdentiferCell = cell
        return cell
    }
    
    var notesCell: LessonAddNotesTableViewCell?
    private func deqeueNotesCell(for indexPath: IndexPath) -> LessonAddNotesTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LessonAddNotesTableViewCellIdentifier, for: indexPath) as! LessonAddNotesTableViewCell
        cell.selectionStyle = .none
        cell.notesTextView.delegate = self
        cell.tableView = tableView
        notesCell = cell
        return cell
    }
    
    override func registerCellClasses() {
        
//        register(LessonAddTopTableViewHeader.self, header: LessonAddTopCollectionViewCellIdentifer)
        register(LessonAddTimeTableViewCell.self, with: LessonAddTimeCollectionViewCellIdentifer)
        register(LessonAddSubjectIdentifierTableViewCell.self, with: LessonAddSubjectIdentifierTableViewCellIdentifer)
        register(LessonAddNotesTableViewCell.self, with: LessonAddNotesTableViewCellIdentifier)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        
        switch section {
        case 0:
            return LessonAddTimeCollectionViewCellHeight
        case 1:
            return LessonAddSubjectIdentifierTableViewCellHeight
        case 2:
            return LessonAddNotesTableViewCellHeight
        case 3,4:
            return LessonAddSubjectIdentifierTableViewCellHeight
        default:
            return 100
        }
    }
    
    override func reset(){
        titleView.titleTextField.text = ""
        tableView.reloadData()
        tableView.reloadRows(at: tableView.indexPathsForVisibleRows ?? [], with: UITableViewRowAnimation.none)
    }
    
    
    func createTimetableLesson() -> TimetableLesson? {
        guard let subjectName = titleView.titleTextField.text,
              let info = notesCell?.notesTextView.text,
              let startTime = timeCell?.getStartTime(),
              let endTime = timeCell?.getEndTime(),
            let day = timeCell?.getDay() else{
                // ERROR SOME DATA IS MISSING!
            return nil
        }
        
        // CREATE TIMETABLE OBJECT
        
        let lesson = TimetableLesson("", subjectName, info, startTime, endTime, day)
        
        return lesson
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.textColor = .gray
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Notiz hinzufügen"
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.last == "\n" {
            notesCell?.recalcualteTextViewHeight()
            keyboardWillShow(keyboardSize: keyboardSize)
        }
    }
    
//    init(_ id: String, _ ln: String, _ rn: String, _ start: Time, _ end: Time, _ d: Day) {
//        self.id = id
//        lessonName = ln
//        info = rn
//        startTime = start
//        endTime = end
//        day = d
//    }
}


extension LessonAddViewController: AddTopHeaderActionDelegate {
    
    func save(_ header: AddTopTableViewHeader, isValid: Bool) {
        guard let lesson = createTimetableLesson() else {
            return
        }
        
        Database.database.addLesson(lesson.map)
        
        self.navigationController?.dismiss(animated: true) {
            self.reset()
        }
    }
    
    func cancel(_ header: AddTopTableViewHeader) {
        self.navigationController?.dismiss(animated: true) {
            self.reset()
        }
    }
}







