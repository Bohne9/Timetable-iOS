//
//  Task.swift
//  Timetable
//
//  Created by Jonah Schueller on 28.06.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import FirebaseFirestore

class Task : Data, Equatable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.taskID == rhs.taskID
    }
    
    
    /// Firebase Path ID of the subject
    var subjectIdentifier = ""
    
    /// Content of the task
    var task = "loading..."
    
    /// Firebase ID of the user
    var userID = ""
     
    /// Name of the user
    var userName = ""
    
    /// Firebase ID of the Task Document
    var taskID = ""
    
    /// Timestamp when the message was written
    var timestamp: Timestamp!
    
    
    var map: [String : String] {
        get{
            let data: [String : String] = [
                "taskID": taskID,
                "userID" : userID,
                "subjectID" : subjectIdentifier,
                "task" : task,
                "timestamp" : "\(timestamp.seconds)"
            ]
            return data
        }
        set{
            if isValid(newValue){
                taskID = newValue["taskID"] ?? ""
                userID = newValue["userID"]!
                subjectIdentifier = newValue["subjectID"]!
                task = newValue["task"]!
                let timeInterval = TimeInterval(newValue["timestamp"]!)!
                let date = Date(timeIntervalSince1970: timeInterval)
                timestamp = Timestamp(date: date)
            }
        }
    }
    
    init() {
        
    }
    
    func isValid(_ data: [String : Any]) -> Bool {
        // Check if any of the required data is missing in the data dictionary
        if  (data["userID"] as? String) == nil ||
            (data["subjectID"] as? String) == nil ||
            (data["task"] as? String) == nil ||
            (data["timestamp"] as? String) == nil{
            
                print("INVALID TASK DATA! Data: \(data)")
                return false
        }
        
        // No data is misssing you're good to go!
        return true
    }
    
    convenience init(document: QueryDocumentSnapshot) {
        let data = document.data()
        self.init(data)
        
        taskID = document.documentID
    }
    
    init(_ data: [String : Any]) {
        if !isValid(data) {
            return
        }
        taskID = data["taskID"] as? String ?? ""
        userID = data["userID"] as! String
        subjectIdentifier = data["subjectID"] as! String
        task = data["task"] as! String
        let timeInterval = TimeInterval(data["timestamp"] as! String)!
        let date = Date(timeIntervalSince1970: timeInterval)
        timestamp = Timestamp(date: date)
    }
    
}
