//
//  TimetableLesson.swift
//  Timetable
//
//  Created by Jonah Schueller on 03.03.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import Foundation
import Firebase

class TimetableLesson: LocalData, CustomStringConvertible, Comparable, Hashable{
    var hashValue: Int {
        return id.hashValue
    }
    
    static func > (lhs: TimetableLesson, rhs: Double) -> Bool {
        return lhs.endValue > rhs
    }
    
    static func < (lhs: TimetableLesson, rhs: Double) -> Bool {
        return lhs.startValue < rhs
    }
    
    static func == (lhs: TimetableLesson, rhs: Double) -> Bool {
        return lhs.startValue <= rhs && lhs.endValue >= rhs
    }
    
    static func > (lhs: TimetableLesson, rhs: Time) -> Bool {
        return lhs.endValue > rhs.value
    }
    
    static func < (lhs: TimetableLesson, rhs: Time) -> Bool {
        return lhs.startValue < rhs.value
    }
    
    static func == (lhs: TimetableLesson, rhs: Time) -> Bool {
        return lhs.startValue <= rhs.value && lhs.endValue >= rhs.value
    }
    
    static func > (lhs: TimetableLesson, rhs: TimetableLesson) -> Bool {
        return lhs.startValue > rhs.startValue
    }
    
    static func < (lhs: TimetableLesson, rhs: TimetableLesson) -> Bool {
        return lhs.startValue < rhs.startValue
    }
    
    static func == (lhs: TimetableLesson, rhs: TimetableLesson) -> Bool {
        return lhs.startValue == rhs.startValue && lhs.endValue == rhs.endValue
    }
    
    var description: String {
        return "Id: \(id), \(lessonName), \(info), \(startTime), \(endTime), \(day)"
    }
    
    var id: String = ""
    
    static func map(_ data: [String : Any]) -> [String : String]{
        var data = [
            "id" : data["id"] as? String ?? "",
            "user" : Database.userID,
            "lessonName" : data["lessonName"] as! String,
            "room" : data["room"] as! String,
            "startTime" : data["startTime"] as! String,
            "endTime" : data["endTime"] as! String,
            "day" : data["day"] as? String ?? ""
        ]
        
        if data["day"] == "" {
            print("No day found!! remove lesson: \(data)")
            Database.database.removeLesson(data)
        }
        return data
    }
    
    
    
    var map: [String : String] {
        get{
            return [
                "id" : id,
                "user" : Database.userID,
                "lessonName": lessonName,
                "room": info,
                "startTime" : startTime.database,
                "endTime" : endTime.database,
                "day": String(day.rawValue)
                
            ]
        }
        set{
            
        }
    }
    
    var startValue: Double {
        get{
            return 24.0 * Double(day.rawValue - 1) + startTime.value
        }
    }
    
    var endValue: Double {
        get {
            return 24.0 * Double(day.rawValue - 1) + endTime.value
        }
    }
    
    var info: String
    var lessonName: String
    var startTime: Time, endTime: Time
    var day: Day
    
    var taskTargets: [Task] = []
    var materialTargets: [Material] = []
    var subject: Subject!
    
    init(_ id: String, _ ln: String, _ rn: String, _ start: Time, _ end: Time, _ d: Day) {
        self.id = id
        lessonName = ln
        info = rn
        startTime = start
        endTime = end
        day = d
    }
    
    init(_ data: [String : String]) {
//        print("Create Timetable lesson")
        self.id = data["id"] ?? ""
//        subject = Database.database.getSubject(data["lessonName"]!)
        lessonName = data["lessonName"] ?? ""
        info = data["room"] ?? ""
        startTime = Time(data["startTime"] ?? "")
        endTime = Time(data["endTime"] ?? "")
        day = Day(rawValue: Int(data["day"] ?? "1")!)!
    }
    
    init(_ d: [String : Any]) {
        let data = TimetableLesson.map(d)
//        print("Create Timetable lesson")
        self.id = data["id"] ?? ""
//        print(data)
//        subject = Database.database.getSubject(data["lessonName"]!)
        lessonName = data["lessonName"] ?? ""
        info = data["room"] ?? ""
        startTime = Time(data["startTime"] ?? "")
        endTime = Time(data["endTime"] ?? "")
        day = Day(rawValue: Int(data["day"] ?? "1")!)!
    }
    
    func updateValues(_ data: [String : String]) {
        lessonName = data["lessonName"] ?? ""
        info = data["room"] ?? ""
        startTime = Time(data["startTime"] ?? "")
        endTime = Time(data["endTime"] ?? "")
        day = Day(rawValue: Int(data["day"] ?? "1")!)!
    }
    
    
    func loadTargetTasks(){
        taskTargets = Database.database.getTasksWithLesson(target: id)
    }
    
    func time() -> String {
        return "Start: \(startTime.description)\nEnd: \(endTime.description)"
    }
  
}

