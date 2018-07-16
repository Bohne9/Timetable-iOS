//
//  Subject.swift
//  Timetable
//
//  Created by Jonah Schueller on 27.04.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import FirebaseFirestore

class Subject: Data, Equatable, Hashable{
    
    var hashValue: Int
    
    static func == (lhs: Subject, rhs: Subject) -> Bool {
        return lhs.lessonName == rhs.lessonName
    }
    
    var id: String = ""
    var globalIdentifier: String!
    var lessonName: String
    var tasks = [Task]()
    
    var map: [String : String] {
        get {
            return [
                "lessonName" : lessonName,
                "user" : Database.userID,
                "identifier" : globalIdentifier ?? "",
                "id" : id
            ]
        }
        set{
            
        }
    }
    
    
    init(_ lessonName: String) {
        self.lessonName = lessonName
        hashValue = lessonName.hashValue
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
    
}
