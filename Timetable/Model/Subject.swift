//
//  Subject.swift
//  Timetable
//
//  Created by Jonah Schueller on 27.04.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import FirebaseFirestore

// Firebase:
//
// subjects
//    |_ {userID}
//          |_ subjects
//                 |_ {subjectID}
//                          |_ id : String
//                          |_ userID: String
//                          |_ globalIdentifier: String
//                          |_ subjectName: String
//                          |_ timestamp: Timestamp
//                          |_ subjectColor: String (hex)
//                          |_ lessons
//                                 |_ {lessonID}
//                          |_ groupRequest
//                                  |_ {requestID}

class Subject: JSONRepresentation, Equatable, Hashable{
    
    var hashValue: Int {
        return lessonName.hashValue
    }
    
    override var pathPrefix: String{
        return "subjects"
    }
    
    static func == (lhs: Subject, rhs: Subject) -> Bool {
        return lhs.lessonName == rhs.lessonName
    }
    
    var globalIdentifier: String!{
        get{ return getOptionalString(for: "globalIdentifier") }
        set{ setValue(for: "globalIdentifier", with: newValue) }
    }
    
    var lessonName: String{
        get{ return getString(for: "lessonName") }
        set{ setValue(for: "lessonName", with: newValue) }
    }
    
    
    
    var tasks = [Task]()
    var material = [Material]()
    
    override func fromJSON(_ data: [String : Any]) {
        super.fromJSON(data)
        id = getIdentifier() ?? ""
        globalIdentifier = getOptionalString(for: "globalIdentifier") ?? id
        lessonName = getString(for: "lessonName")
        
    }
    
    init(_ lessonName: String) {
        self.lessonName = lessonName
        userID = Database.userID
    }
    
    
    /// Removes a task from the subject object
    /// In case the task doesn't exist nothing happens
    /// - Parameter task: Task that should be removed
    func removeTask(task: Task) {
        for (i, t) in tasks.enumerated() {
            if task.taskID == t.taskID {
                tasks.remove(at: i)
                return
            }
        }
    }
    
    /// Sets the values of a existing task.
    /// In case the task does not exitst, it will be added via Subject.addTask(task: Task).
    /// - Parameter task: Task object with the update values.
    func setTask(task: Task){
        var successful = false
        // Look for the task and update the values of the task
        for t in tasks {
            if task.taskID == t.taskID {
                t.map = task.map
                successful = true
            }
        }
        // In case the task doesn't exist -> add the task to the subject.
        if !successful {
            addTask(task: task)
        }
    }
    
    func addTask(task: Task) {
        tasks.append(task)
    }
    
    func hasIdentifier() -> Bool {
        return globalIdentifier == nil
    }
    
    override func firestorePath() -> String? {
        guard let id = self.id else {
            return nil
        }
        let path = self.path(firestoreCollectionPath(), id)
        return path
    }
    
    override func firestoreCollectionPath() -> String {
        let pathPrefix = self.pathPrefix
        let path = self.path(pathPrefix, userID, pathPrefix)
        return path
    }
    
}
