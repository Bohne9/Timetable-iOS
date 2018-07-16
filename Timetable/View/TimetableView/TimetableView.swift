//
//  TimetableView.swift
//  Timetable
//
//  Created by Jonah Schueller on 25.04.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit


class TimetableView : UIScrollView, UIGestureRecognizerDelegate {
    
    static var detailView: UIView!
    
    var dayViews = [TimetableDayView]()
    
    let view = UIStackView()
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.axis = .horizontal
        view.spacing = 30
        isPagingEnabled = true
        
//        panGestureRecognizer.delegate = self
        
        addSubview(view)
        
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        view.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        view.isLayoutMarginsRelativeArrangement = true
        
        clipsToBounds = false
        view.clipsToBounds = false
        
        setupDays()
        setTodayLabel()
        
//        view.trailingAnchor.constraint(equalTo: dayViews.last!.trailingAnchor).isActive = true
//        view.widthAnchor.constraint(equalToConstant: 1000).isActive = true
        
        contentSize = view.frame.size
    }
    
    
    private func setupDays(){
        let days = Database.database.timetableDays
        
        for day in days {
            
            let timeView = TimetableDayView()
//            timeView.artWorkImg.image = image?.0
//            timeView.artWorkImg.layer.contentsRect = CGRect(x: 0, y: image!.1, width: 1, height: 1)
            timeView.day = day
            dayViews.append(timeView)
            
            view.addArrangedSubview(timeView)
            
            timeView.translatesAutoresizingMaskIntoConstraints = false
            
            timeView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            timeView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            timeView.widthAnchor.constraint(equalTo: widthAnchor, constant: -30).isActive = true
            
            
        }
    }
    
    func scrollToDay(day: Day) {
        setContentOffset(CGPoint(x: (UIScreen.main.bounds.width - 60) * CGFloat(day.rawValue - 1), y: 0), animated: true)
    }
    
    func setTodayLabel(){
        let index = Database.database.getCurrentDayNumber()
        
        for view in dayViews {
            
            view.todayLabel.isHidden = view.day.day.rawValue != index
            
        }
        
    }
    
    func addTimetableLesson(_ lesson: TimetableLesson) {
        let day = getTimetabelDay(lesson.day)
        day?.addLesson(lesson)
    }
    
    func getTimetabelDay(_ day: Day) -> TimetableDayView? {
        
        for view in dayViews {
            if view.day == day {
                return view
            }
        }
        return nil
    }
    
    func updateTimetableLesson(_ data: [String : String]) {
        for day in dayViews.map({ $0.day }) {
            for lesson in day!.lessons {
                
                if lesson.id == data["id"] {
                    // The day object the lesson currently has
                    let currentDay = lesson.day
                    // Update all lesson values but the id (has to be equal already)
                    lesson.updateValues(data)
                    
                    // In case user changed the day of the lesson
                    if currentDay.rawValue != Int(data["day"]!) {
                        _ = day?.removeLesson(withId: lesson.id)
                        addTimetableLesson(lesson)
                    }
                }
            }
        }
        reloadData()
    }
    
    func removeTimetableLesson(_ data: [String : String]) {
        for day in dayViews.map({ $0.day }) {
            for lesson in day!.lessons {
                if lesson.id == data["id"] {
                    _ = day?.removeLesson(withId: lesson.id)
                    
                }
            }
        }
        reloadData()
    }
    
    func reloadData(){
        for (view, data) in zip(dayViews, Database.database.timetableDays) {
            view.day = data
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





















class OldTimetableView: AbstractView {

    var dayView = [OldTimetableDayView]()
    var stack = UIStackView()
    
    override init() {
        super.init()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        isPagingEnabled = true
        
        contentSize = .zero
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        alwaysBounceHorizontal = false
        
        stack.backgroundColor = .red
        setupDayViews()
    
//        setContent(stack)
    
        setupConstraints()
        
        layoutIfNeeded()
        
        updateContentSize()
    }
    
    override func setContent(_ content: UIView) {
        
        addSubview(content)
        
        content.translatesAutoresizingMaskIntoConstraints = false
        self.content = content
        
        content.topAnchor.constraint(equalTo: topAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        content.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        content.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        updateContentSize()
        
    }
    
    func setupDayViews(){
        
        let days = Database.database.timetableDays
        for day in days {
            let timetableView = OldTimetableDayView(day: day)
            dayView.append(timetableView)
            
        }
    }
    
   
    
    
    func setupConstraints(){
        setContent(stack)
        
        alwaysBounceHorizontal = false
        
        stack.axis = .horizontal
        
        
        dayView.forEach { (v) in
            stack.addArrangedSubview(v)
            
            v.topAnchor.constraint(equalTo: topAnchor).isActive = true
            
            v.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            v.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            //            anchor = v.trailingAnchor
        }
    }
    
    func loadViews() {
        
        
        let days = Database.database.timetableDays
        
        for day in days {
            
            let timetableView = getTimetableDay(day.day)
            
            for lesson in day.lessons {
                timetableView?.addLesson(lesson)
            }
            
        }
        
    }
    
    

    override func close() {
        
    }
    
    
    ///
    ///
    /// - Parameter day: Day which view should be returned
    /// - Returns: TimetableView corresponding to the day
    func getTimetableDay(_ day: Day) -> OldTimetableDayView? {
        
        for d in dayView {
            if d.day == day {
                return d
            }
        }
        return nil
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
