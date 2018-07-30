//
//  TimetableVIew.swift
//  Timetable
//
//  Created by Jonah Schueller on 03.03.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class TimetableDayView : UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate{
    
    var day: TimetableDay!{
        didSet{
            reload()
        }
    }
    
    var detailView: TimetableDetailView?
    
    // Normal state (timetable view)
    let dayLabel = UILabel()
    let todayLabel = UILabel()
    let lessonCount = UILabel()
    let sepataor = UIView()
    var lessonTable: UITableView!
    
    let cellName = "lessonCell"
    
    // AutoLayout Constraints
    var pan: UIPanGestureRecognizer!
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.masksToBounds = false
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.5
        
        setupUserInterface()
        addPanGesture()
//        lessonTable.panGestureRecognizer.delegate = self
        backgroundColor = .backgroundContrast
    }
    
    
    
    private func addPanGesture() {
        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        addGestureRecognizer(pan)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let gesture = gestureRecognizer as! UIPanGestureRecognizer
        let vel = gesture.velocity(in: self)
        return abs(vel.y) > abs(vel.x)// && vel.y < 0
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer){
        let velocity = gesture.velocity(in: self)
        
        if velocity.y < 0 {
            if gesture.state == .began {
                loadDetailView()
            }
            
            detailView?.handlePan(gesture)
        }else {
           ViewController.controller.handlePanSwipeDown(gesture)
        }
    }
    
    
    
    func loadDetailView(){
        
        if let detail = detailView {
            detail.setValues(day, !todayLabel.isHidden)
            detail.isHidden = false
//            detail.updateView(0.0)
            layoutIfNeeded()
            
        }else {
            detailView = TimetableDetailView()
            
            print("CREATE A NEW DETAIL VIEW")
            detailView!.setValues(day, !todayLabel.isHidden)
            let view = TimetableView.detailView!
            view.addSubview(detailView!)
            
            let frame = self.superview!.convert(self.frame, to: view)
            detailView!.createLayoutConstraints(view, rect: frame)
            view.layoutIfNeeded()
            
            loadDetailView()
        }
    }
    
    
    
    private func setupUserInterface(){
        setupLessonCountLabel()
        setupTodayLabel()
        setupDayLabel()
        setupLessonCollectionView()
    }
    
    
    private func setupLessonCountLabel(){
        addSubview(lessonCount)
        lessonCount.translatesAutoresizingMaskIntoConstraints = false
        
        lessonCount.font = UIFont.robotoMedium(14)
        lessonCount.textColor = .gray
        
        lessonCount.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        lessonCount.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        lessonCount.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lessonCount.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    
    private func setupTodayLabel(){
        addSubview(todayLabel)
        todayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        todayLabel.text = Language.translate("Today").uppercased()
        todayLabel.font = UIFont.robotoMedium(14)
        todayLabel.textAlignment = .right
        todayLabel.textColor = .lightBlue
        
        todayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        todayLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        todayLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        todayLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        layoutIfNeeded()
    }
    
    
    private func setupDayLabel(){
        addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dayLabel.font = UIFont.robotoMedium(25)
        dayLabel.textColor = .white
        
        dayLabel.topAnchor.constraint(equalTo: lessonCount.bottomAnchor, constant: 5).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        dayLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        dayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    
    
    private func setupLessonCollectionView(){
        lessonTable = UITableView()
        lessonTable.register(TimetableLessonView.self, forCellReuseIdentifier: cellName)
        lessonTable.separatorStyle = .none
        lessonTable.alwaysBounceVertical = false
        lessonTable.delegate = self
        lessonTable.dataSource = self
        lessonTable.backgroundColor = .backgroundContrast
        
        addSubview(lessonTable)
        lessonTable.translatesAutoresizingMaskIntoConstraints = false
        
        lessonTable.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 40).isActive = true
        lessonTable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        lessonTable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        lessonTable.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return day.lessons.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! TimetableLessonView
        cell.selectionStyle = .none
        cell.lesson = day.lessons[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    func reload(){
        dayLabel.text = Language.translate("Day_\(day.day)")
        day.lessons = day.lessons.sorted()
        self.lessonTable.reloadData()
        detailView?.setValues(day, !todayLabel.isHidden)
        let count = day.lessons.count
        if count == 1 {
            lessonCount.text = "\(count) \(Language.translate("Lesson"))"
        }else {
            lessonCount.text = "\(count) \(Language.translate("Lessons"))"
        }
    }
    
    
    func addLesson(_ lesson: TimetableLesson) {
        print("\(day.day) - add lesson")
        day.lessons.append(lesson)
        reload()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


























class OldTimetableDayView: UIScrollView {
    
    static var detailSuperview: UIView?
    
    var timeCells: [TimeCell] = []
    var timeScaling: [UIView] = []
    
    let containter = UIView()
    let day: TimetableDay
    
    init(day: TimetableDay) {
        self.day = day
        super.init(frame: .zero)
        
        backgroundColor = .background
        
        containter.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        
        showsVerticalScrollIndicator = false
        
        
        
        addSubview(containter)
        
        containter.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 1.55).isActive = true
        containter.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        containter.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containter.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        containter.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        containter.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.55).isActive = true
        
        createTimeScaling()
        day.lessons.forEach { _ = addLesson($0) }
        containter.layoutIfNeeded()
        contentSize = containter.frame.size
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containter.constraints.forEach { (con) in
            if con.firstAttribute == .height {
                con.constant = UIScreen.main.bounds.height * 1.55
            } else if con.firstAttribute == .width {
                con.constant = UIScreen.main.bounds.width
            }
        }
        
//        containter.subviews.forEach { (view) in
//            view.removeFromSuperview()
//
        
//    }
        
        timeScaling.forEach { (s) in
            s.removeFromSuperview()
        }
        timeScaling.removeAll()
    
        createTimeScaling()
        
        timeCells.forEach({ (cell) in
            self.reconstraintCell(cell)
            containter.bringSubview(toFront: cell)
        })
        
        
//        day.lessons.forEach { _ = addLesson($0) }
        containter.layoutIfNeeded()
        contentSize = containter.frame.size
                
    }
    
    func reconstraintCell(_ cell: TimeCell) {
        cell.topConstraint.constant = mapTimeToView(cell.lesson.startTime)
        cell.bottomConstraint.constant = mapTimeToView(cell.lesson.endTime)
    }
    
    func addLesson(_ lesson: TimetableLesson) -> TimeCell{
        let cell = TimeCell(lesson: lesson)
        
        containter.addSubview(cell)
        
        cell.topConstraint = cell.topAnchor.constraint(equalTo: containter.topAnchor, constant: mapTimeToView(lesson.startTime))
        cell.topConstraint.isActive = true
        
        cell.leadingAnchor.constraint(equalTo: containter.leadingAnchor, constant: 70).isActive = true
        cell.trailingAnchor.constraint(equalTo: containter.trailingAnchor, constant: -50).isActive = true
        
        cell.bottomConstraint = cell.bottomAnchor.constraint(equalTo: containter.topAnchor, constant: mapTimeToView(lesson.endTime))
        cell.bottomConstraint.isActive = true
        
        cell.getLessonDetails = showLessonDetails(_:)
        
        timeCells.append(cell)
        return cell
    }
    
    private func createTimeScaling(){
        for i in 0...24{
            if i % 2 == 0 {
                createTimeStep(i)
            }
            let line = UIView()
            line.translatesAutoresizingMaskIntoConstraints = false
            containter.addSubview(line)
            line.backgroundColor = .appLightGray
            line.topAnchor.constraint(equalTo: containter.topAnchor, constant: CGFloat(i) * calcTimeScaling() + 13).isActive = true
            line.leadingAnchor.constraint(equalTo: containter.leadingAnchor, constant: 55).isActive = true
            line.heightAnchor.constraint(equalToConstant: 1).isActive = true
            line.trailingAnchor.constraint(equalTo: containter.trailingAnchor, constant: -20).isActive = true
            
            timeScaling.append(line)
        }
    }
    
    private func createTimeStep(_ i: Int) {
        let label = UILabel()
        label.text = Time(i, 0).description
        //label.font = UIFont.boldSystemFont(ofSize: 13)//systemFont(ofSize: 13, weight: .heavy)
        label.font = UIFont.robotoBold(14)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .appLightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        containter.addSubview(label)
        label.topAnchor.constraint(equalTo: containter.topAnchor, constant: CGFloat(i) * calcTimeScaling()).isActive = true
        label.leadingAnchor.constraint(equalTo: containter.leadingAnchor, constant: 5).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        label.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        timeScaling.append(label)
    }
    
    
    private func calcTimeScaling() -> CGFloat{
        return UIScreen.main.bounds.height * 1.5 / 24.0
    }
    
    
    private func mapTimeToView(_ time: Time) -> CGFloat {
       return calcTimeScaling() * CGFloat(CGFloat(time.hours) + CGFloat(time.minutes) / 60.0) + 12.5
    }
    
    func showLessonDetails(_ lesson: TimetableLesson) -> OldLessonDetails{
        let details = OldLessonDetails(lesson: lesson, frame: .zero)
//        TimetableDayView.detailSuperview!.addSubview(details)
//        details.topAnchor.constraint(equalTo: TimetableDayView.detailSuperview!.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
//        details.leadingAnchor.constraint(equalTo: TimetableDayView.detailSuperview!.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
//        details.trailingAnchor.constraint(equalTo: TimetableDayView.detailSuperview!.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
//        details.bottomAnchor.constraint(equalTo: TimetableDayView.detailSuperview!.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
//        
        return details
    }
    
    func removeCell(_ lesson: TimetableLesson) {
        for (i, cell) in timeCells.enumerated() {
            if cell.lesson.id == lesson.id {
                cell.removeFromSuperview()
                timeCells.remove(at: i)
                day.removeLesson(withId: lesson.id)
                return
            }
        }
        
    }
    
    func getCell(withID: String) -> TimeCell? {
        for cell in timeCells {
            if cell.lesson.id == withID {
                return cell
            }
        }
        return nil
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
