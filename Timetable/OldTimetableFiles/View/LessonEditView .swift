//
//  LessonEditView.swift
//  Timetable
//
//  Created by Jonah Schueller on 31.03.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

protocol LessonEditViewDelegate {
    
    func detailCancel()
    
    func detailSave(_ lesson: TimetableLesson)
    
    func detailEdit()
    
    func detailDelete(_ lesson: TimetableLesson)
    
}



class LessonEditViewController : CardPopupViewController{
    
    var lesson: TimetableLesson! {
        didSet{
            setLabelValues()
        }
    }
    
    var lessonDelegate: LessonEditViewDelegate?
    
    let lessonName = DescribtedTextField(Language.translate("AddLesson_Lesson"))
    let roomNumber = DescribtedTextField(Language.translate("AddLesson_Room"))
    let startTime = DescribtedTextField(Language.translate("AddLesson_Start"))
    let endTime = DescribtedTextField(Language.translate("AddLesson_End"))
    let delete = UIButton()
    
    override func setupUserInterface() {
        super.setupUserInterface()
        
        constraintUIView(view: lessonName, anchor: scrollContent.topAnchor, offset: 25)
        constraintUIView(view: roomNumber, anchor: lessonName.bottomAnchor)
        constraintUIView(view: startTime, anchor: roomNumber.bottomAnchor)
        constraintUIView(view: endTime, anchor: startTime.bottomAnchor)
        constraintUIView(view: delete, anchor: endTime.bottomAnchor)
        
        roomNumber.textField.placeholder = "-"
        
        delete.setTitle(Language.translate("Delete").uppercased(), for: .normal)
        delete.setTitleColor(.error, for: .normal)
        delete.setTitleColor(UIColor.error.withAlphaComponent(0.5), for: .highlighted)
        delete.titleLabel!.font = UIFont.robotoBold(16)
        delete.titleEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
        delete.addTarget(self, action: #selector(handleDelete(_:)), for: .touchUpInside)
        
        setupButtons()
        
        constraintContentBottom(lastView: delete)
    }
    
    
    @objc func handleDelete(_ btn: UIButton) {
        _ = OldViewController.controller?.presentAlertView(title: Language.translate("DeleteLesson"), message: Language.translate("Confirm Delete"), dismiss: Language.translate("Cancel"), confirm: Language.translate("Delete"), { (result) in
            if result {
                Database.database.removeLesson(self.map())
                self.dismiss()
            }
        })
    }
    
    
    
    private func setupButtons(){

        let done = UIBarButtonItem(title: Language.translate("Save").uppercased(), style: .done, target: self, action: #selector(handleDone))
        let close = UIBarButtonItem(title: Language.translate("Cancel").uppercased(), style: .done, target: self, action: #selector(handleCancel))
        let item = UINavigationItem(title: "")
        close.tintColor = .interaction
        done.tintColor = .interaction
        close.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.robotoBold(16)], for: .normal)
        done.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.robotoBold(16)], for: .normal)
        item.rightBarButtonItem = done
        item.leftBarButtonItem = close
        
        navigationBar.setItems([item], animated: false)
    
    }
    
    
    @objc func handleDone(){
        let newLessonName = lessonName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        print("NewLessonName = \(newLessonName!)")
    
        if newLessonName != lesson.lessonName {
            let data = map()
            Database.database.updateLesson(data)
            // Shows an alert view so the user can decide between changing all lesson names or just this one
           _ = OldViewController.controller.presentAlertView(title: "Update", message: Language.translate("UpdateAll"), dismiss: Language.translate("ForThis"), confirm: Language.translate("ForAll")) { (result) in
                if result {
                    Database.database.mapSubject(newName: newLessonName!, oldName: self.lesson.lessonName)
                }
                self.dismiss()
            }
            
        }else {
            Database.database.updateLesson(map())
            dismiss()
        }
        
    }
    
    
    private func map() -> [String : String] {
        
        var data = lesson.map
        data["lessonName"] = lessonName.text!
        data["room"] = roomNumber.text ?? ""
        data["startTime"] = Time(startTime.text!).database
        data["endTime"] = Time(endTime.text!).database
        
        return data
    }
    
    
    @objc func handleCancel(){
        dismiss()
    }
    
//    private func toTime(_ timeChooser: TimeChooser)
    
    private func setLabelValues(){
        if let lesson = self.lesson {
            lessonName.text = lesson.lessonName
            roomNumber.text = lesson.info
            startTime.text = lesson.startTime.description
            endTime.text = lesson.endTime.description
        }
    }
    
    private func constraintUIView(view: UIView, anchor: NSLayoutYAxisAnchor, offset: CGFloat = 40, height: CGFloat = 60) {
        scrollContent.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.topAnchor.constraint(equalTo: anchor, constant: offset).isActive = true
        view.leadingAnchor.constraint(equalTo: scrollContent.leadingAnchor, constant: 35).isActive = true
        view.trailingAnchor.constraint(equalTo: scrollContent.trailingAnchor, constant: -35).isActive = true
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
  
    
}




















//
//class OldLessonEditMenu: AbstractMenu {
//    
//    let title = UILabel()
//    var delegate: LessonEditViewDelegate? {
//        didSet{
//            cancel.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
//        }
//    }
//    
//    
//    let cancel = UIButton(type: .system)
//    let edit = UIButton(type: .system)
//    let delete = UIButton(type: .system)
//    
//    let editView: OldLessonEditView
//    
//    private var state = 0
//    
//    init(_ edit: OldLessonEditView) {
//        editView = edit
//        super.init(frame: .zero)
//        
//        title.translatesAutoresizingMaskIntoConstraints = false
//        translatesAutoresizingMaskIntoConstraints = false
//        
////        backgroundColor = .appWhite
//        addSubview(title)
//        
//        title.text = "Details"
//        title.font = UIFont.robotoMedium(18)
//        
//        title.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        title.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        title.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        title.topAnchor.constraint(equalTo: topAnchor).isActive = true
//
//        setupBarButton(button: cancel, #imageLiteral(resourceName: "Cross"), trailingAnchor: trailingAnchor, constant: 5, #selector(handleCancel))
//        setupBarButton(button: self.edit, #imageLiteral(resourceName: "edit"), trailingAnchor: cancel.leadingAnchor, constant: 15, #selector(handleEditSave(_:)))
//        setupBarButton(button: delete, #imageLiteral(resourceName: "delete"), trailingAnchor: self.edit.leadingAnchor, constant: 15, #selector(handleDelete))
//
//    }
//    
//    
//    private func setupBarButton(button: UIButton, _ image: UIImage, trailingAnchor: NSLayoutXAxisAnchor, constant: CGFloat, _ action: Selector){
//        addSubview(button)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        
//        button.setImage(image, for: .normal)
//        button.tintColor = UIColor(displayP3Red: 30 / 255, green: 30 / 255, blue: 30 / 255, alpha: 1)
//        
//        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constant).isActive = true
//        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
//        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        
//        button.addTarget(self, action: action, for: .touchUpInside)
//    }
// 
//    @objc func handleCancel() {
////        delegate?.detailCancel()
//        editView.fadeOut()
//    }
//    
//    
//    @objc func handleEditSave(_ sender: UIButton) {
//        
//        switch state {
//
//        // Edit State
//        case 0:
//            edit.setImage(#imageLiteral(resourceName: "Check"), for: .normal)
//            editView.editable = true
//            state = 1
//        // Save State
//        case 1:
//            updateLesson()
//        default:
//            print("Handle Profile Edit/Save Button default case! Check for any errors")
//        }
//    }
//    
//    private func updateLesson() {
//        let lesson = editView.lesson
//        Database.database.updateLesson(lesson)
//        
//        if editView.didLessonNameChange() {
////            _ = ViewController.controller?.presentAlertView(title: "Update", message: Language.translate("UpdateAll"), dismiss: Language.translate("ForThis"), confirm: Language.translate("ForAll"), { (result) in
////                
////                if result {
////                    Database.database.mapSubject(newName: lesson["lessonName"]!, oldName: self.editView.inputLessonName)
////                }
////                
////                self.edit.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
////                self.editView.editable = false
////                self.handleCancel()
////                self.state = 0
////            })
//            
//            
//        }else{
//            edit.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
//            editView.editable = false
//            handleCancel()
//            state = 0
//        }
//        
//    }
//    
//    
//    @objc func handleDelete() {
////        delegate?.detailDelete(editView.lesson)
//        
////        _ = ViewController.controller?.presentAlertView(title: Language.translate("DeleteLesson"), message: Language.translate("Confirm Delete"), dismiss: Language.translate("Cancel"), confirm: Language.translate("Delete"), { (result) in
////            if result {
////                Database.database.removeLesson(self.editView.lesson)
////                self.editView.fadeOut()
////            }
////        })
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//
////class OldLessonEditView: AbstractView, UITextFieldDelegate, TimeChooserDelegate {
////    
////    var lessonId = ""
////    fileprivate var inputLessonName: String!
////    var lesson: [String : String] {
////        get{
////            let split = startTime.text!.components(separatedBy: " - ")
////            
////            let day = ["\(Day.Monday)", "\(Day.Tuesday)", "\(Day.Wednesday)", "\(Day.Thursday)", "\(Day.Friday)", "\(Day.Saturday)", "\(Day.Sunday)"]
////            let ind = day.filter { $0 == split[0]}.first!
////            
////            let start = Time(split[1]).database
////            let end = Time(endTime.text!.components(separatedBy: " - ")[1]).database
////            
////            let les = TimetableLesson.map(["id" : lessonId, "lessonName" : lessonName.text!, "room" : roomNumber.text!, "startTime": start, "endTime": end, "day": "\(day.index(of: ind)! + 1)"])
////            return les
////        }
////        
////        set {
////            lessonId = newValue["id"]!
////            
////            inputLessonName = newValue["lessonName"]!
////            
////            lessonName.text = newValue["lessonName"]!
////            roomNumber.text = newValue["room"]!
////            
////            let day = "\(Day(rawValue: Int(newValue["day"]!)!)!)"
////            
////            startTime.text = "\(day) - \(newValue["startTime"]!)"
////            endTime.text = "\(day) - \(newValue["endTime"]!)"
////            
////        }
////    }
////    
////    var editable: Bool{
////        get{
////            return true
////        }
////        set{
////            [self.lessonName, self.roomNumber, self.startTime, self.endTime].forEach({ (e) in
////                UIView.animate(withDuration: 0.1, animations: {
////                    e.transform = CGAffineTransform(scaleX: 1.1, y: 1)
////                    e.layoutIfNeeded()
////                }) { _ in
////                    UIView.animate(withDuration: 0.1, animations: {
////                        e.transform = CGAffineTransform(scaleX: 1.0, y: 1)
////                        e.layoutIfNeeded()
////                    })
////                }
////            })
////            
////            [self.lessonName, self.roomNumber, self.startTime, self.endTime].forEach({ (e) in
////                e.textField.isEnabled = newValue
////                e.alpha = newValue ? 1.0 : 0.7
////            })
////        }
////    }
////    
////    
////    let lessonName = DescribtedTextField(Language.translate("AddLesson_Lesson"))
////    let roomNumber = DescribtedTextField(Language.translate("AddLesson_Room"))
////    let startTime = DescribtedTextField(Language.translate("AddLesson_Start"))
////    let endTime = DescribtedTextField(Language.translate("AddLesson_End"))
////    
////    let stack = UIStackView()
////    
////    override init() {
////        super.init()
////        
////        translatesAutoresizingMaskIntoConstraints = false
////        stack.translatesAutoresizingMaskIntoConstraints = false
////        
////        stack.axis = .vertical
////        stack.alignment = .center
////        stack.distribution = .equalSpacing
////        stack.spacing = 50
////        
////        stack.backgroundColor = .background
////        backgroundColor = .background
////        
////        setupTextFields(lessonName, roomNumber, startTime, endTime)
////        
////        roomNumber.textField.placeholder = "-"
////        
////        setContent(stack)
////        
////        editable = false
////    }
////    
////    override func open(_ data: Any?) {
////        if let data = data{
////            let l = data as! TimetableLesson
////            lesson = l.map
////        }
////    }
////    
////    
////    
////    private func setupTextFields(_ views: DescribtedTextField...){
////        
////        for view in views {
////            
////            stack.addArrangedSubview(view)
////            view.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
////            view.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = true
////            view.heightAnchor.constraint(equalToConstant: 60).isActive = true
////            view.textField.delegate = self
////            
////        }
////    }
////    
////    
////    
////    func timeChooser(_ timeChooser: TimeChooser, _ day: Day, _ time: Time) -> Bool {
////        return true
////    }
////    
////    func timeChooser(_ timeChooser: TimeChooser, finished: Bool) {
////        
////    }
////    
////    func didLessonNameChange() -> Bool{
////        return inputLessonName != lessonName.text!
////    }
////    
////    // Reset the addView
////    func reset(){
////        [self.lessonName, self.roomNumber, self.startTime, self.endTime].forEach({ (e) in
////            e.transform = CGAffineTransform(translationX: 0, y: 0)
////            e.alpha = 1.0
////        })
////    }
////    
////    // When 'return' was hit on the keyboard
////    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
////        textField.resignFirstResponder()
////        return true
////    }
////    
////    
////    required init?(coder aDecoder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
////}
////
