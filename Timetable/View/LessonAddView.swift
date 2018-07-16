//
//  LessonAddView.swift
//  Timetable
//
//  Created by Jonah Schueller on 15.03.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit
import Firebase


class LessonAddViewController : CardPopupViewController, UITextFieldDelegate{

    var lessonDelegate: LessonEditViewDelegate?
    var day: Day?
    let lessonName = DescribtedTextField(Language.translate("AddLesson_Lesson"))
    private var setupParts = [DescribtedTextField]()
    private var progress = 0
    
    private let stack = UIStackView()
    
    let courseTextField = DescribtedTextField(translate: "WhichLessonAdd")
    let roomNumber = DescribtedTextField(translate: "AddLesson_Room")
    let startTime = DescribtedTextField(translate: "AddLesson_Start")
    let endTime = DescribtedTextField(translate: "AddLesson_End")
    
//    var adView: GADBannerView!
    
    override func setupUserInterface() {
        super.setupUserInterface()
        
        content.layoutIfNeeded()
        
        scrollContent.addSubview(stack)
        
//        loadAd()
        
        stack.constraint(topAnchor: scrollContent.topAnchor, leading: scrollContent.leadingAnchor, trailing: scrollContent.trailingAnchor, bottom: scrollContent.bottomAnchor, topOffset: 15, leadingOff: 35, trailingOff: -35, bottomOff: 15)
        
//        stack.addAndConstraint(to: scrollContent, topOffset: 50, leading: 35, trailing: -35, bottom: 0)
        stack.axis = .vertical
        stack.spacing = 50
        
        constraintSetupPart(view: courseTextField, height: 80)
        constraintSetupPart(view: roomNumber)
        constraintSetupPart(view: startTime)
        constraintSetupPart(view: endTime)
        
        courseTextField.setTextFieldFont(size: 22)
        
        setupParts = [courseTextField, roomNumber, startTime, endTime]
        setupParts.forEach { $0.textField.delegate = self }
        
        setupButtons()
    }
    
//    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
//        print("ERROR WHILE LOADING AN AD: \(error)")
//    }
//
//    private func loadAd(){
//        adView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
//        adView.rootViewController = self
////        adView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        adView.adUnitID = "ca-app-pub-4090633946148380/1818556045"
//        adView.delegate = self
//
//        adView.translatesAutoresizingMaskIntoConstraints = false
//
//        scrollContent.addSubview(adView)
//
//        scrollContent.layoutIfNeeded()
//
//        adView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        adView.bottomAnchor.constraint(equalTo: scrollContent.bottomAnchor).isActive = true
//        adView.leadingAnchor.constraint(equalTo: scrollContent.leadingAnchor).isActive = true
//        adView.trailingAnchor.constraint(equalTo: scrollContent.trailingAnchor).isActive = true
//
//        scrollContent.layoutIfNeeded()
//
//        let request = GADRequest()
//        request.testDevices = ["c434183d62d7efd2c75682afe89f7ffc"]
//        adView.load(request)
//
//    }
//
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    
    override func becomeFirstResponder() -> Bool {
        setupParts.forEach { (part) in
            _ = part.resignFirstResponder()
        }
        return super.becomeFirstResponder()
    }
    
    @objc func handleDone(){
    
        let data = map()
        Database.database.addLesson(data)
        reset()
        dismiss()
    }
    
   
    
    
    private func map() -> [String : String] {
        var data = [String : String]()
        data["lessonName"] = courseTextField.text!
        data["room"] = roomNumber.text ?? ""
        data["startTime"] = Time(startTime.text!).database
        data["endTime"] = Time(endTime.text!).database
        data["day"] = "\(day!.rawValue)"
        return data
    }
    
    
    @objc func handleCancel(){
        reset()
        dismiss()
    }
    
    
    func reset(){
        setupParts.forEach { (part) in
            part.text = ""
        }
        fadeTextFieldsOut()
    }
    
    
    private func constraintSetupPart(view: UIView, height: CGFloat = 60) {
        stack.addArrangedSubview(view)

        view.heightAnchor.constraint(equalToConstant: height).isActive = true
//        view.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: 35).isActive = true
//        view.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: -35).isActive = true
        view.alpha = 0.0
        view.transform = CGAffineTransform(translationX: 0, y: 100)
    }
    
    
    
    private func fadeTextFieldsIn() {
        
        for (i, element) in setupParts.enumerated() {
            UIView.animate(withDuration: 0.15, delay: TimeInterval(CGFloat(i + 1) * 0.05), options: .curveEaseOut, animations: {
                element.alpha = 1.0
                element.transform = .identity
            }, completion: nil)
        }
    }
   
    private func fadeTextFieldsOut() {
        
        for (i, element) in setupParts.reversed().enumerated() {
            UIView.animate(withDuration: 0.3, delay: TimeInterval(CGFloat(i) * 0.1), options: .curveEaseOut, animations: {
                element.alpha = 1.0
                element.transform = CGAffineTransform(translationX: 0, y: 100)
            }, completion: nil)
        }
    }
    
    override func fadeIn() {
        super.fadeIn()
        fadeTextFieldsIn()
    }
    
    override func fadeOut() {
        super.fadeOut()
        setupParts.forEach { (part) in
            part.resignFirstResponder()
        }
        
    }
    
}



















































//
//class LessonAddMenu: AbstractMenu {
//    
//    let title = UILabel()
//    
//    let add = UIButton(type: .system)
//    
//    private let view: OldLessonAddView
//    
//    init(view: OldLessonAddView) {
//        self.view = view
//        super.init(frame: .zero)
//        
//        title.translatesAutoresizingMaskIntoConstraints = false
//        translatesAutoresizingMaskIntoConstraints = false
//        add.translatesAutoresizingMaskIntoConstraints = false
//        
//        addSubview(title)
//        
//        title.text = Language.translate("LessonControl_AddLesson")
//        title.font = UIFont.robotoMedium(18)
//        
//        title.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        title.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        title.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        title.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        
//        
//        addSubview(add)
//        
//        add.setImage(#imageLiteral(resourceName: "Check"), for: .normal)
//        add.tintColor = UIColor(displayP3Red: 30 / 255, green: 30 / 255, blue: 30 / 255, alpha: 1)
//        
//        add.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        add.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        add.widthAnchor.constraint(equalToConstant: 25).isActive = true
//        add.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        
//        add.addTarget(self, action: #selector(handleAdd(_:)), for: .touchUpInside)
//        
//        close()
//        
//    }
//    
//    @objc func handleAdd(_ sender: UIButton) {
//        
//        if view.isValid() {
////            delegate?.addViewAddLesson(view.map)
//            Database.database.addLesson(view.map)
//            view.reset()
////            ViewController.controller?.loadView(key: "default")
//        }
//        
//    }
//    
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
//
//
//// +++++++++++++++++++++++++++++++++++
////                                   +
////                                   +
////      START LESSONADDVIEW CLASS    +
////                                   +
////                                   +
//// +++++++++++++++++++++++++++++++++++
//
//class OldLessonAddView: AbstractView, UITextFieldDelegate, TimeChooserDelegate {
//    
//    let stack = UIStackView()
//    
//    let lessonName = DescribtedTextField(Language.translate("AddLesson_Lesson"))
//    let roomNumber = DescribtedTextField(Language.translate("AddLesson_Room") + " (Optional)")
//    let startTime = TimeChooser(Language.translate("AddLesson_Start"))
//    let endTime = TimeChooser(Language.translate("AddLesson_End"))
//    
////    var startTimeChooser, endTimeChooser: TimeChooser
//    
//    var map: [String : String] {
//        get{
////            let start = startTimeChooser.time
////            let end = endTimeChooser.time
////            let day = startTimeChooser.day
////
////            let les = TimetableLesson(lessonName.text ?? "", roomNumber.text ?? "", teacherName.text ?? "", start, end, day)
////
//            
//            return [
//                "user" : Database.userID,
//                "lessonName": lessonName.text ?? "",
//                "room": roomNumber.text ?? "",
//                "startTime" : startTime.time.database,
//                "endTime" : endTime.time.database,
//                "day": "\(startTime.day.rawValue)"
//            ]
//        }
//    }
//    
//    
//    override init() {
////        startTimeChooser = TimeChooser(startTime)
////        endTimeChooser = TimeChooser(endTime)
//        
//        super.init()
//        
//        translatesAutoresizingMaskIntoConstraints = false
//        backgroundColor = .background
//    
////        isUserInteractionEnabled = true
////        stack.isUserInteractionEnabled = true
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(stack)
//        
//        stack.axis = .vertical
//        stack.alignment = .center
//        stack.distribution = .equalSpacing
//        stack.spacing = 50
//        
//        stack.backgroundColor = .background
//        backgroundColor = .background
//        
////        startTimeChooser.delegate = self
////        endTimeChooser.delegate = self
//    
////        _ = constraintTimeChooser(startTimeChooser)
////        _ = constraintTimeChooser(endTimeChooser)
////        startTimeChooser.isHidden = true
////        endTimeChooser.isHidden = true
//        
//        
//        stackViews(lessonName, startTime, endTime, roomNumber)
//        stack.layoutIfNeeded()
//        setContent(stack)
//        
//        lessonName.textField.delegate = self
//        roomNumber.textField.delegate = self
//        
//        let tap1 = UITapGestureRecognizer(target: self, action: #selector(timeTap(_:)))
//        let tap2 = UITapGestureRecognizer(target: self, action: #selector(timeTap(_:)))
//        startTime.textField.addGestureRecognizer(tap1)
//        endTime.textField.addGestureRecognizer(tap2)
//        
//    }
//    
//    
//    // Stack the setting textfields vertically
//    private func stackViews(_ views: UIView...) {
//       
//        for view in views {
//            stack.addArrangedSubview(view)
//            
////            view.textField.delegate = self
////            view.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
////            view.topAnchor.constraint(equalTo: anchor, constant: offset).isActive = true
//            view.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
//            view.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = true
//            view.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
//        }
//        
//    }
//    
//    
//    @objc func timeTap(_ gesture: UITapGestureRecognizer) {
//        print("Tap")
//        let t = gesture.view == startTime.textField ? startTime : endTime
//        t.expanded = !t.expanded
//        
//    }
//    
//    
//    // When one of the time labels was triggered
//    @objc func timeChooserEvent(_ sender: UITapGestureRecognizer){
//
//    }
//    
//    private func fadeOut(_ completion: @escaping ((Bool)-> Void)){
//        
//        let elements: [UIView] = [lessonName, roomNumber, startTime, endTime]
//        
//        
//        
//        elements.forEach { (element) in
//            let i = elements.index(of: element)!
//            UIView.animateKeyframes(withDuration: 0.3, delay: Double(i) / 50.0, options: UIViewKeyframeAnimationOptions.calculationModeCubic, animations: {
//                element.transform = CGAffineTransform(translationX: 0, y: -200)
//                element.alpha = 0
//            }, completion: nil)
//        }
//        
//    }
//    
//    // Constraint the timeChoosers in superview
//    private func constraintTimeChooser(_ chooser: TimeChooser) -> TimeChooser {
//    
//        addSubview(chooser)
//        
//        chooser.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
//        chooser.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
//        chooser.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        chooser.bottomAnchor.constraint(equalTo: chooser.topAnchor, constant: 60).isActive = true
//        
//        return chooser
//    }
//    
//    // When one of the timeChoosers hit 'add'
//    func timeChooser(_ timeChooser: TimeChooser, _ day: Day, _ time: Time) -> Bool {
////        if (timeChooser == startTime){
////            startTime.text = "\(day) - \(time.description)"
////        }else if(timeChooser == endTime){
////            endTime.text = "\(day) - \(time.description)"
////        }
//        return true
//    }
//    
//    // Hide the timeChooser in view
//    func timeChooser(_ timeChooser: TimeChooser, finished: Bool) {
//        if (finished){
//            timeChooser.isHidden = true
//        }
//    }
//    
//    // Reset the addView
//    func reset(){
//        [lessonName, roomNumber].forEach { $0.text = "" }
//        startTime.text = ""
//        endTime.text = ""
//        
//        [ self.lessonName, self.roomNumber, self.startTime, self.endTime].forEach({ (e) in
//            e.transform = CGAffineTransform(translationX: 0, y: 0)
//            e.alpha = 1.0
//        })
//    }
//    
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        print("start")
//        
//    }
//    
//    // When 'return' was hit on the keyboard
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    
//    func isValid() -> Bool {
//        
//        var valid = true
//        
//        if lessonName.text == nil || lessonName.text == "" {
//            lessonName.shake()
//            valid = false
//        }
//        
//        if startTime.textField.text == nil || startTime.textField.text == "" {
//            startTime.textField.shake()
//            valid = false
//        }
//        
//        if endTime.textField.text == nil || endTime.textField.text == "" {
//            endTime.textField.shake()
//            valid = false
//        }
//        
//        return valid
//    }
//    
//    
//    override func open(_ data: Any?) {
//        super.open(data)
//        UIView.animate(withDuration: 0.25, animations: {
//            [ self.lessonName, self.roomNumber, self.startTime, self.endTime].forEach { (element) in
//                element.transform = CGAffineTransform(scaleX: 1, y: 1)
//                element.alpha = 1.0
//            }
//            self.layoutIfNeeded()
//        })
//    }
//    
//    
//    
//    override func close() {
//        super.close()
//        UIView.animate(withDuration: 0.2, animations: {
//            [ self.lessonName, self.roomNumber, self.startTime, self.endTime].forEach { (element) in
//                element.transform = CGAffineTransform(scaleX: 0.4, y: 1)
//                element.alpha = 0.0
//            }
//            self.layoutIfNeeded()
//        })
//    
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//// +++++++++++++++++++++++++++++++++++
////                                   +
////                                   +
////      END LESSONADDVIEW CLASS      +
////                                   +
////                                   +
//// +++++++++++++++++++++++++++++++++++
//
//
//
