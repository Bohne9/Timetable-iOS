//
//  LessonAddTimeCollectionViewCell.swift
//  Timetable
//
//  Created by Jonah Schueller on 15.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

let LessonAddTimeCollectionViewCellIdentifer = "LessonAddTimeCollectionViewCellIdentifier"

var LessonAddTimeCollectionViewCellHeight: CGFloat = 200

class LessonAddTimeTableViewCell: AddBodyTableViewCell{
    
    lazy var timeStartTextField: UILabel = {
        let tf = UILabel()
        
        tf.text = "Start time"
        tf.textColor = .gray
        tf.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        tf.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleStartTimeTap))
        
        tf.addGestureRecognizer(tap)
        return tf
    }()
    
    lazy var timeEndTextField: UILabel = {
        let tf = UILabel()
        
        tf.text = "End time"
        tf.textColor = .gray
        tf.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        tf.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEndTimeTap))
        
        tf.addGestureRecognizer(tap)
        return tf
    }()
    
    lazy var dayTextField: UILabel = {
        let tf = UILabel()
        tf.text = Language.translate("Day_\(Day(rawValue: Database.database.getCurrentDayNumber())!)")
        tf.textColor = .gray
        tf.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        tf.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDayTap))
        
        tf.addGestureRecognizer(tap)
        return tf
    }()
    
    private var days: [Day] = {
        var days = [Day]()
        
        for i in 1...7 {
            days.append(Day(rawValue: i)!)
        }
        return days
    }()
    
    private var hours: [Int] = {
        var hours = [Int]()
        for h in 0...23 {
            hours.append(h)
        }
        return hours
    }()
    
    private var minutes: [Int] = {
        var minutes = [Int]()
        for m in stride(from: 0, to: 55, by: 5) {
            minutes.append(m)
        }
        return minutes
    }()
    
    lazy var clockImage: UIImageView = {
        let imageView =  UIImageView(image: #imageLiteral(resourceName: "clock").withRenderingMode(.alwaysTemplate))
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        
        return imageView
    }()

    
    var dayPicker = UIPickerView()
    var dayPickerHeightConstraint: NSLayoutConstraint!
    
    var startTimePicker = UIPickerView()
    var startTimePickerHeightConstraint: NSLayoutConstraint!
    
    var endTimePicker = UIPickerView()
    var endTimePickerHeightConstraint: NSLayoutConstraint!
    
    
    var expandedDayPicker: Bool {
        set {
            dayPicker.alpha = newValue ? 1.0 : 0.0
            dayPickerHeightConstraint.constant = newValue ? 200 : 0
            startTimePickerHeightConstraint.constant = 0
            startTimePicker.alpha = 0
            endTimePickerHeightConstraint.constant = 0
            endTimePicker.alpha = 0
            LessonAddTimeCollectionViewCellHeight = 200 + dayPickerHeightConstraint.constant
        }
        get {
            return dayPickerHeightConstraint.constant > 0
        }
    }
    
    var expandedStartTimePicker: Bool {
        set {
            startTimePicker.alpha = newValue ? 1.0 : 0.0
            startTimePickerHeightConstraint.constant = newValue ? 200 : 0
            dayPickerHeightConstraint.constant = 0
            dayPicker.alpha = 0
            endTimePickerHeightConstraint.constant = 0
            endTimePicker.alpha = 0
            LessonAddTimeCollectionViewCellHeight = 200 + startTimePickerHeightConstraint.constant
        }
        get {
            return startTimePickerHeightConstraint.constant > 0
        }
    }
    
    var expandedEndTimePicker: Bool {
        set {
            endTimePicker.alpha = newValue ? 1.0 : 0.0
            endTimePickerHeightConstraint.constant = newValue ? 200 : 0
            dayPickerHeightConstraint.constant = 0
            dayPicker.alpha = 0
            startTimePickerHeightConstraint.constant = 0
            startTimePickerHeightConstraint.constant = 0
            LessonAddTimeCollectionViewCellHeight = 200 + endTimePickerHeightConstraint.constant
        }
        get {
            return endTimePickerHeightConstraint.constant > 0
        }
    }
    
    override func addSubviews() {
        
        addSubview(clockImage)
        addSubview(timeStartTextField)
        addSubview(timeEndTextField)
        addSubview(dayTextField)
        addSubview(dayPicker)
        addSubview(startTimePicker)
        addSubview(endTimePicker)
        
        clockImage.translatesAutoresizingMaskIntoConstraints = false
        timeStartTextField.translatesAutoresizingMaskIntoConstraints = false
        timeEndTextField.translatesAutoresizingMaskIntoConstraints = false
        dayTextField.translatesAutoresizingMaskIntoConstraints = false
        
        dayPicker.translatesAutoresizingMaskIntoConstraints = false
        startTimePicker.translatesAutoresizingMaskIntoConstraints = false
        endTimePicker.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func setupUserInterface() {
        super.setupUserInterface()
        
        dayTextField.centerYAnchor.constraint(equalTo: clockImage.centerYAnchor).isActive = true
        dayTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 65).isActive = true
        dayTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        dayTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        setupDayPickerView()
        
        timeStartTextField.topAnchor.constraint(equalTo: dayPicker.bottomAnchor, constant: 15).isActive = true
        timeStartTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 65).isActive = true
        timeStartTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        timeStartTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        setupStartTimePickerView()
        
        timeEndTextField.topAnchor.constraint(equalTo: startTimePicker.bottomAnchor, constant: 15).isActive = true
        timeEndTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 65).isActive = true
        timeEndTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        timeEndTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        setupEndTimePickerView()
        
        clockImage.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
        clockImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        clockImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        clockImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        var minutes = calendar.component(.minute, from: date)
        
        minutes -= minutes % 5
        
        let currentTime = String(format: "%02d:%02d", hour, minutes)
        let currentPlusOneHour = String(format: "%02d:%02d", min(23, hour + 1), minutes)
        
        timeStartTextField.text = currentTime
        timeEndTextField.text = currentPlusOneHour
        
        startTimePicker.selectRow(hour, inComponent: 0, animated: false)
        startTimePicker.selectRow(minutes / 5, inComponent: 1, animated: false)
        
        endTimePicker.selectRow(min(23, hour + 1), inComponent: 0, animated: false)
        endTimePicker.selectRow(minutes / 5, inComponent: 1, animated: false)
        
        
    }

    
    private func setupDayPickerView(){
        dayPicker.topAnchor.constraint(equalTo: dayTextField.bottomAnchor).isActive = true
        dayPicker.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        dayPicker.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        dayPickerHeightConstraint = dayPicker.heightAnchor.constraint(equalToConstant: 0)
        dayPickerHeightConstraint.isActive = true
    
        dayPicker.dataSource = self
        dayPicker.delegate = self

        dayPicker.selectRow(Database.database.getCurrentDayNumber() - 1, inComponent: 0, animated: true)
    }
    
    
    private func setupStartTimePickerView(){
        startTimePicker.topAnchor.constraint(equalTo: timeStartTextField.bottomAnchor).isActive = true
        startTimePicker.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        startTimePicker.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        startTimePickerHeightConstraint = startTimePicker.heightAnchor.constraint(equalToConstant: 0)
        startTimePickerHeightConstraint.isActive = true
        
        startTimePicker.dataSource = self
        startTimePicker.delegate = self
        
        // Select current time
//        startTimePicker.selectRow(Database.database.getCurrentDayNumber() - 1, inComponent: 0, animated: true)
    }
    
    
    private func setupEndTimePickerView(){
        endTimePicker.topAnchor.constraint(equalTo: timeEndTextField.bottomAnchor).isActive = true
        endTimePicker.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        endTimePicker.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        endTimePickerHeightConstraint = endTimePicker.heightAnchor.constraint(equalToConstant: 0)
        endTimePickerHeightConstraint.isActive = true
        
        endTimePicker.dataSource = self
        endTimePicker.delegate = self
        
//        endTimePicker.selectRow(Database.database.getCurrentDayNumber() - 1, inComponent: 0, animated: true)
    }

    @objc func handleDayTap(){
        self.dayPicker.alpha = self.expandedDayPicker ? 0.0 : 1.0
        self.tableView.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
            
            self.expandedDayPicker = !self.expandedDayPicker
            self.tableView.layoutIfNeeded()
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }, completion: nil)
    }
    
    @objc func handleStartTimeTap(){
        self.startTimePicker.alpha = self.expandedStartTimePicker ? 0.0 : 1.0
        
        self.tableView.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
            
            self.expandedStartTimePicker = !self.expandedStartTimePicker
            self.tableView.layoutIfNeeded()
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }, completion: nil)
    }
    
    @objc func handleEndTimeTap(){
        self.endTimePicker.alpha = self.expandedEndTimePicker ? 0.0 : 1.0
        tableView.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
            
            self.expandedEndTimePicker = !self.expandedEndTimePicker
            self.tableView.layoutIfNeeded()
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }, completion: nil)
    }
}


extension LessonAddTimeTableViewCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == dayPicker {
            return 1
        }
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == dayPicker {
            dayTextField.text = Language.translate("Day_\(days[row])")
        }else if pickerView == startTimePicker {
            timeStartTextField.text = convertToTimeString(pickerView)
        }else if pickerView == endTimePicker {
            timeEndTextField.text = convertToTimeString(pickerView)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == dayPicker {
            return days.count
        }else if pickerView == startTimePicker || pickerView == endTimePicker {
            if component == 0 {
                return hours.count
            }else {
                return minutes.count
            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .gray
        label.textAlignment = .center
        
        
        if pickerView == dayPicker {
            label.text = Language.translate("Day_\(days[row])")
        }else if pickerView == startTimePicker || pickerView == endTimePicker {

            label.textAlignment = component == 0 ? .right : .left
            label.text = component == 0 ? String.init(format: "%02d\t", arguments: [hours[row]]) : String.init(format: "\t%02d", arguments: [minutes[row]])
        }
        
        return label
    }
    
    private func convertToTimeString(_ pickerView: UIPickerView) -> String{
        let hour = hours[pickerView.selectedRow(inComponent: 0)]
        let minute = minutes[pickerView.selectedRow(inComponent: 1)]
        
        return String.init(format: "%02d:%02d", hour, minute)
    }
    
    func getStartTime() -> Time{
        return timePickerToTime(pickerView: startTimePicker)
    }
   
    func getEndTime() -> Time{
        return timePickerToTime(pickerView: endTimePicker)
    }
    
    private func timePickerToTime(pickerView: UIPickerView) -> Time {
        let hour = hours[pickerView.selectedRow(inComponent: 0)]
        let minute = minutes[pickerView.selectedRow(inComponent: 1)]
        return Time(hour, minute)
    }
    
    func getDay() -> Day{
        return Day(rawValue: dayPicker.selectedRow(inComponent: 0) + 1)!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView == dayPicker ? 300 : 80
    }
}


