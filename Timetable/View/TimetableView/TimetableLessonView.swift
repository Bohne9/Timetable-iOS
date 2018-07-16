//
//  TimeCell.swift
//  Timetable
//
//  Created by Jonah Schueller on 28.02.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit
import FirebaseFirestore



class TimetableLessonView : UITableViewCell {
    
    var lesson: TimetableLesson! {
        didSet{
            nameTextField.text = lesson.lessonName
            time.text = "\(lesson.startTime.description) - \(lesson.endTime.description)"
            room.text = lesson.roomNumber == "" ? "-" : lesson.roomNumber
        }
    }
    
    let cellView = UIView()
    
    let nameTextField = UILabel()
    let time = UILabel()
    let room = UILabel()
    let delete = UIButton()
    let edit = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        cellView.layer.masksToBounds = false
        cellView.layer.cornerRadius = 5
        
        addSubview(cellView)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cellView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        setupUI(nameTextField, time, room)
        backgroundColor = .clear
        constraintUserInterface()
        
        nameTextField.adjustsFontSizeToFitWidth = true
        //        time.adjustsFontSizeToFitWidth = true
        //        room.adjustsFontSizeToFitWidth = true
        //
        nameTextField.textColor = .background
        nameTextField.font = .robotoMedium(16)
        
        time.textColor = .gray
        time.font = .robotoMedium(14)
        
        room.textColor = .gray
        room.font = .robotoMedium(14)
        
        room.textAlignment = .right
        
    }
    
    
    
    private func constraintUserInterface(){

        nameTextField.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 5).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10).isActive = true
//        nameTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: cellView.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true

        time.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        time.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10).isActive = true
        time.heightAnchor.constraint(equalToConstant: 25).isActive = true
        time.trailingAnchor.constraint(equalTo: cellView.centerXAnchor).isActive = true

        room.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        room.leadingAnchor.constraint(equalTo: cellView.centerXAnchor).isActive = true
        room.heightAnchor.constraint(equalToConstant: 25).isActive = true
        room.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10).isActive = true

    }
    
    /// Sets up a bunch of views
    ///
    /// - Parameter views: view to set up
    private func setupUI(_ views: UILabel...) {
        views.forEach { (v) in
            self.setupEssentials(v)
        }
    }
    
    
    /// Sets up the general ui things... add to superview, translatesAuto...
    ///
    /// - Parameter view: view
    private func setupEssentials(_ view: UILabel) {
        cellView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}






























class TimeCell: UIView, UIGestureRecognizerDelegate{

    let titleLabel: UILabel = {
       let l = UILabel()
        //l.font = UIFont.boldSystemFont(ofSize: 20)//(ofSize: 20, weight: .heavy)
        l.font = UIFont.robotoBold(20)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let contentLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = -1
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var blur: UIVisualEffectView?
    var lesson: TimetableLesson
    var expandView: OldLessonDetails?
    var getLessonDetails: ((TimetableLesson) -> OldLessonDetails)?
    var detail: OldLessonDetails?
    
    var topConstraint, bottomConstraint: NSLayoutConstraint!
    
    var sizeConstraint: NSLayoutConstraint?
    
    private var isTapable = true
   
    init(lesson: TimetableLesson) {
        self.lesson = lesson
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        
        backgroundColor = .contrast
        
        layer.masksToBounds = false
        layer.cornerRadius = 6
        
        titleLabel.text = lesson.lessonName
        titleLabel.textColor = .background
        
        
        contentLabel.text = "Room: \(lesson.roomNumber)\n\(lesson.time())"
        
        translatesAutoresizingMaskIntoConstraints = false
       
        addSubview(titleLabel)
        addSubview(contentLabel)
        
        contentLabel.isHidden = true

        [titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7),
         titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7)
         ].forEach { (con) in
            con.isActive = true
        }
        
        contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7).isActive = true
        contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(expand))
        tap.delegate = self
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }

    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return isTapable
    }
    
    
    func loadLessonDetail(){
//        let controller = ViewController.controller!
//        
////        controller.lessonDetailViewController.lessonEdit.lesson = self.lesson
////        controller.presentLessonDetailViewConroller({
////            self.isHidden = false
////            self.detail?.downScale()
////        })
//
//        isHidden = false
//        detail?.downScale()
//        controller.loadLessonEditView(lesson)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            // On 3D touch started
            
            if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                isHidden = true
                let percentage = touch.force / touch.maximumPossibleForce
                isTapable = (percentage < 0.05) && isTapable
                createLessonDetail()
                detail?.updateAnchors(percentage)
            }else {
                print("no Force Touch... Load lesson detail view")
                loadLessonDetail()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            // 3D touch pressed harder
            // Scale detail view by percent or scale it to max size
            if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                // 3d touch
                
                let percentage = touch.force / touch.maximumPossibleForce

                // Decide wheather the TapGesture should be available -> when force was less than 5% and never was higher
                isTapable = (percentage < 0.05) && isTapable
                
                detail?.updateAnchors(percentage)

                if (detail!.scaleState == 3 && percentage > 0.5) {
//                    detail?.fullScreen({ _ in
//                        self.loadLessonDetail()
//                    })
                    // Vibrate
                    let taptic = UIImpactFeedbackGenerator(style: .medium)
                    taptic.prepare()
                    taptic.impactOccurred()
                    self.loadLessonDetail()
                    detail?.scaleState = 4
                }
            }
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // touch cancelled (out of bounds or so)
        // Remove detail view and show this cell
        isTapable = true
        if let d = detail {
            isHidden = false
            d.downScale()
            detail = nil
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // touch released
        // Remove detail view and show this cell
        if let touch = touches.first {
            isTapable = true
            if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                // 3d touch
                isHidden = false
                detail?.downScale()
                detail = nil
            }
            
        }
    }
    
    private func createLessonDetail() {
        let scroll = superview!.superview! as! UIScrollView
//        let view = ViewController.controller!.view!
//
        let frame = scroll.convert(self.frame, to: nil)
        
        detail = OldLessonDetails(lesson: lesson, frame: frame)
//        view.addSubview(detail!)
        detail?.prepare()
            
        detail?.top = detail?.topAnchor.constraint(equalTo: topAnchor, constant: 0)
            
        detail?.leading = detail?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
            
        detail?.bottom = detail?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
            
        detail?.trailing = detail?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
            
        detail?.activateConstraints()
    
    }

    @objc func expand(_ sender: UITapGestureRecognizer){

        loadLessonDetail()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
