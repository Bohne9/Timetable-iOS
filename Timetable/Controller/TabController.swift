//
//  TabController.swift
//  Timetable
//
//  Created by Jonah Schueller on 31.07.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.


import UIKit

class TabController: UITabBarController, DataUpdateDelegate {
    
    var overviewController: OverviewController!
    var timetableController: TimetableController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database.delegate = self
        setupTabItems()
    

        // Do any additional setup after loading the view.
        
//        lessonName = data["lessonName"] ?? ""
//        roomNumber = data["room"] ?? ""
//        startTime = Time(data["startTime"] ?? "")
//        endTime = Time(data["endTime"] ?? "")
//        day = Day(rawValue: Int(data["day"] ?? "1")!)!
//
//        let data = ["lessonName" : "Deutsch",
//                    "room" : "216",
//                    "startTime" : Time("12:00").database,
//                    "endTime" : Time("13:30").database,
//                    "day" : String(Day.Monday.rawValue)]
//        
//        let data2 = ["lessonName" : "Englisch",
//                    "room" : "314",
//                    "startTime" : Time("14:30").database,
//                    "endTime" : Time("15:15").database,
//                    "day" : String(Day.Monday.rawValue)]
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//            Database.database.addLesson(data)
//            Database.database.addLesson(data2)
//        }
    }
    
    
    
    
    private func setupTabItems(){
        
        tabBar.isTranslucent = true
        view.layer.cornerRadius = 5
        
        let overviewItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "Home").scaledImage(maximumWidth: 30), tag: 0)
        overviewItem.imageInsets = UIEdgeInsetsMake(0, 0, -6, 0)
        
        overviewController = OverviewController()
        overviewController.tabBarItem = overviewItem
        
//        let overviewNavigation = UINavigationController(rootViewController: overviewController)
//        overviewNavigation.tabBarItem = overviewItem
        
        let timetableBarItem = UITabBarItem(title: "Timetable", image: nil, tag: 1)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        timetableController = TimetableController()
        timetableController.tabBarItem = timetableBarItem
        tabBar.tintColor = .background
        
        self.viewControllers = [overviewController, timetableController]
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func lessonAdd(reason: DataUpdateType, _ data: [String : String]) {
        let days = Database.database.timetableDays
        timetableController.reload(days)
        overviewController.reload(Array(Database.database.lessons))
    }
    
    func lessonChange(reason: DataUpdateType, _ data: [String : String]) {
        let days = Database.database.timetableDays
        timetableController.reload(days)
        overviewController.reload(Array(Database.database.lessons))
    }
    
    func lessonRemove(reason: DataUpdateType, _ data: [String : String]) {
        let days = Database.database.timetableDays
        timetableController.reload(days)
        overviewController.reload(Array(Database.database.lessons))
    }
    
    func subjectAdd(reason: DataUpdateType, _ data: [String : String]) {
        
    }
    
    func subjectChange(reason: DataUpdateType, _ data: [String : String]) {
        
    }
    
    func subjectRemove(reason: DataUpdateType, _ data: [String : String]) {
        
    }
    
    func profileChange(reason: DataUpdateType, _ data: [String : String]) {
        
    }
    
    func taskAdd(reason: DataUpdateType, _ data: [String : String]) {
        
    }
    
    func taskChange(reason: DataUpdateType, _ data: [String : String]) {
        
    }
    
    func taskRemove(reason: DataUpdateType, _ data: [String : String]) {
        
    }
}
