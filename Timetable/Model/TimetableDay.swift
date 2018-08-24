//
//  TimetableDay.swift
//  Timetable
//
//  Created by Jonah Schueller on 03.03.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import Foundation

enum Day: Int{
    case Monday = 1
    case Tuesday = 2
    case Wednesday = 3
    case Thursday = 4
    case Friday = 5
    case Saturday = 6
    case Sunday = 7
    
    
}

class TimetableDay : Equatable{
    

    static func ==(lhs: TimetableDay, rhs: TimetableDay) -> Bool {
        return lhs.day == rhs.day
    }
    static func ==(lhs: TimetableDay, rhs: Day) -> Bool {
        return lhs.day == rhs
    }
    static func ==(lhs: Day, rhs: TimetableDay) -> Bool {
        return lhs == rhs.day
    }
    
    
    var lessons: [TimetableLesson] = []
    let day: Day
    
    init(day: Day) {
        self.day = day
    }
    init(day: Int) {
        self.day = Day.init(rawValue: day)!
    }
    
    func sort(){
        lessons.sort { (lhs, rhs) -> Bool in
            return lhs.startValue < rhs.startValue
        }
    }
    
    func removeLesson(withId: String) -> Bool{
        
        for (i, lesson) in lessons.enumerated()  {
            if lesson.id == withId {
                lessons.remove(at: i)
                return true
            }
        }
        return false
    }
    
    
    
}









