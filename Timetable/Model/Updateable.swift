//
//  Updateable.swift
//  Timetable
//
//  Created by Jonah Schueller on 29.04.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import Foundation

enum DataUpdateType {
    
    case LessonAdd
    case LessonChange
    case LessonRemove
    case SubjectAdd
    case SubjectChange
    case SubjectRemove
    case ProfileChange
    case TaskAdd
    case TaskChange
    case TaskRemove
    
}


protocol DataUpdateDelegate{
    
    func lessonAdd(reason: DataUpdateType, _ data: [String : String])
    
    func lessonChange(reason: DataUpdateType, _ data: [String : String])
    
    func lessonRemove(reason: DataUpdateType, _ data: [String : String])
    
    func subjectAdd(reason: DataUpdateType, _ data: [String : String])
    
    func subjectChange(reason: DataUpdateType, _ data: [String : String])
    
    func subjectRemove(reason: DataUpdateType, _ data: [String : String])
    
    func profileChange(reason: DataUpdateType, _ data: [String: String])
    
    func taskAdd(reason: DataUpdateType, _ data: [String : String])
    
    func taskChange(reason: DataUpdateType, _ data: [String : String])
    
    func taskRemove(reason: DataUpdateType, _ data: [String : String])
}
