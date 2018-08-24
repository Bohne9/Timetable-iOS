//
//  LessonDetails.swift
//  Timetable
//
//  Created by Jonah Schueller on 05.03.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

enum TimetableDetailViewState : CGFloat {
    case fullscreen = 1
    case small = -1.0
}

extension TimetableDetailViewState{
    
    var oppostite: TimetableDetailViewState {
        get{
            return self == .fullscreen ? .small : .fullscreen
        }
    }
    
}
extension UIImage {
    func scaledImage(maximumWidth: CGFloat) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let cgImage: CGImage = self.cgImage!.cropping(to: rect)!
        return UIImage(cgImage: cgImage, scale: size.width / maximumWidth, orientation: imageOrientation)
    }
}

class TimetableDetailView: AnimationUIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    var day: TimetableDay!{
        didSet{
            reload()
        }
    }
    
    // Detail view items
    let dayLabel = UILabel()
    
    // Normal state (timetable view)
    let todayLabel = UILabel()
    let lessonCount = UILabel()
    let sepataor = UIView()
    var lessonTable: UITableView!
    let cellName = "lessonCell"
    
    var pan: UIPanGestureRecognizer!
    
    var state: TimetableDetailViewState = .small
    
    override init() {
        super.init()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.masksToBounds = false
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.5
        
        addAnimationFunction { (value) in
            self.layer.cornerRadius = 5.0 + 5.0 * (1.0 - pow(value, 3))
        }
        
        
        setupUserInterface()
        addPanGesture()
        
        lessonTable.panGestureRecognizer.accessibilityLabel = "DetailLessonTable"
        
        lessonTable.cellLayoutMarginsFollowReadableWidth = true
        backgroundColor = .backgroundContrast
    }
    
    func setValues(_ day: TimetableDay, _ today: Bool){
        self.day = day
        todayLabel.isHidden = !today
        dayLabel.text = Language.translate("Day_\(day.day)")
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = gestureRecognizer as! UIPanGestureRecognizer
        let vel = gesture.velocity(in: self)
        
        return abs(vel.y) > abs(vel.x) && vel.y > 0
    }
    
    
    private func addPanGesture() {
        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.accessibilityLabel = "DetailGesture"
        pan.delegate = self
        addGestureRecognizer(pan)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer){
        
        let translation = gesture.translation(in: gesture.view)
        var swipePercent = (translation.y * state.rawValue) / 200.0
        swipePercent = max(swipePercent, -0.05)
        swipePercent = min(swipePercent, 1.05)
        
//        print("\(translation.y) - \(swipePercent)")
        
        switch gesture.state {
        
        case .began:
            
            animator.pauseAnimation()
            animationDuration = 0.2
            startDisplayLink(pause: true)
            
            animator = UIViewPropertyAnimator(duration: animationDuration, dampingRatio: 0.75, animations: {
                self.animate()
            })
            animator.startAnimation()
            animator.pauseAnimation()
        case .changed:
            
            animator.fractionComplete = swipePercent
            updateFunctions(swipePercent)
            handleDisplayLink(Double(swipePercent))
            lessonTable.layoutIfNeeded()
            
        case .ended:
            let vel = gesture.velocity(in: gesture.view).y
            
            // Swipe down
            if vel > 0 {
                // Swipes down and comes from small state
                if state == .small {
                    isReversed = true
                    OldViewController.controller.statusBarStyle = .lightContent
                }else {
                    OldViewController.controller.statusBarStyle = .lightContent
                    state = state.oppostite
                }
                animator.addCompletion { (position) in
                    self.isHidden = true
                }
            }
            // Swipe up
            else if vel < 0 {
                // Swipes up and comes from fullscreen state
                if state == .fullscreen {
                    OldViewController.controller.statusBarStyle = .default
                    isReversed = true
                }else {
                    OldViewController.controller.statusBarStyle = .default
                    state = state.oppostite
                }
            }else {
                OldViewController.controller.statusBarStyle = state == .fullscreen ? .default : .lightContent
                
                if state == .fullscreen {
                    animator.addCompletion { (position) in
                        self.isHidden = true
                    }
                }
                state = state.oppostite
            }
            
            
            animator.addCompletion { (p) in
                self.update(self.state == .fullscreen ? 1.0 : 0.0)
            }
            
            
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 1)
            isPaused = false
            
        default:
            print("Some other case occured TimetableDetailView.handlePan")
        }
    }

    
    func animate() {
        if state == .fullscreen {
            self.update(0.0)
            self.dayLabel.transform = .identity
//            self.superview!.layoutIfNeeded()
        }else {
            self.update(1.0)
            self.dayLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//            self.superview!.layoutIfNeeded()
        }
        self.superview!.layoutIfNeeded()
    }
    
    
    
    private func setupUserInterface(){
        setupLessonCountLabel()
        setupTodayLabel()
        setupDayLabel()
        setupNavigationBar()
        setupLessonCollectionView()
    }
    
    
    private func setupLessonCountLabel(){
        addSubview(lessonCount)
        lessonCount.translatesAutoresizingMaskIntoConstraints = false
        
        lessonCount.font = UIFont.robotoMedium(14)
        lessonCount.textColor = .gray
        
        addAnimationConstraint(anchor: lessonCount.topAnchor, equalTo: topAnchor, start: 10, end: 30)
//        lessonCount.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
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
        
        todayLabel.topAnchor.constraint(equalTo: lessonCount.topAnchor).isActive = true
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
        addAnimationConstraint(anchor: dayLabel.leadingAnchor, equalTo: leadingAnchor, start: 10, end: 70)
//        dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        dayLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        let c = dayLabel.heightAnchor.constraint(equalToConstant: 50)
        c.isActive = true
        
        dayLabel.adjustsFontSizeToFitWidth = true
    }
    
    
    private func setupLessonCollectionView(){
        lessonTable = UITableView()
        lessonTable.register(TimetableLessonView.self, forCellReuseIdentifier: cellName)
        lessonTable.separatorStyle = .none
        lessonTable.delegate = self
        lessonTable.dataSource = self
        lessonTable.backgroundColor = .backgroundContrast
        lessonTable.alwaysBounceVertical = false
        
        addSubview(lessonTable)
        lessonTable.translatesAutoresizingMaskIntoConstraints = false
        
        lessonTable.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 40).isActive = true
        lessonTable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        lessonTable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        lessonTable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    
    private func setupNavigationBar(){
        let navigationBar = UINavigationBar()
        
        addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        navigationBar.constraint(topAnchor: dayLabel.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: dayLabel.bottomAnchor, topOffset: 0, leadingOff: 0, trailingOff: 0, bottomOff: 0)
        
//        let add = UIBarButtonItem(title: Language.translate("Add").uppercased(), style: .done, target: self, action: #selector(handleAdd))
        let add = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(handleAdd))
        let item = UINavigationItem(title: "")
        add.tintColor = .lightBlue
        add.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.robotoBold(16)], for: .normal)
        item.rightBarButtonItem = add
        
        navigationBar.setItems([item], animated: false)
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        addAnimationFunction { (value) in
            navigationBar.alpha = value
        }
        
        sendSubview(toBack: navigationBar)
    }
    
    
    @objc func handleAdd(){
        OldViewController.controller.presentAddViewController()
        OldViewController.controller.lessonAddView!.day = day.day
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return day.lessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! TimetableLessonView
        
//        cell.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
//        cell.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        
        cell.lesson = day.lessons[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
   
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let edit = UIContextualAction(style: .normal, title: nil) { (action, view, success) in
            
            OldViewController.controller.presentEditViewController(self.day.lessons[indexPath.row])
            
            success(true)
        }
        
        edit.image = #imageLiteral(resourceName: "edit").scaledImage(maximumWidth: 30)
        edit.backgroundColor = .lightBlue
        
        
        let delete = UIContextualAction(style: .normal, title: nil) { (action, view, success) in
            print("DELETE")
            success(true)
        }
        
        delete.image = #imageLiteral(resourceName: "delete").scaledImage(maximumWidth: 30)
        delete.backgroundColor = .error
        
        return UISwipeActionsConfiguration(actions: [edit, delete])
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        OldViewController.controller.presentEditViewController(self.day.lessons[indexPath.row])
    }
    
    
    
    
    func reload(){
        day.lessons = day.lessons.sorted()
        lessonTable.reloadData()
        let count = day.lessons.count
        if count == 1 {
            lessonCount.text = "\(count) \(Language.translate("Lesson"))"
        }else {
            lessonCount.text = "\(count) \(Language.translate("Lessons"))"
        }
    }
    
    
    
    func createLayoutConstraints(_ view: UIView, rect: CGRect) {
        
        addAnimationConstraint(anchor: topAnchor, equalTo: view.topAnchor, start: rect.minY)
        addAnimationConstraint(anchor: leadingAnchor, equalTo: view.leadingAnchor, start: rect.minX)
        addAnimationConstraint(anchor: trailingAnchor, equalTo: view.trailingAnchor, start: -UIScreen.main.bounds.width + rect.maxX)
        addAnimationConstraint(anchor: bottomAnchor, equalTo: view.bottomAnchor, start: -UIScreen.main.bounds.height + rect.maxY)
        
        update(0.0)
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


























class OldLessonDetails: UIView {
    
    // Shadow view: Not added to this view instead added to this superview
    private let shadow = UIView()
    
    var scaleState = 0
    // Constraints: Set in TimeCell Class when touched in a timeCell (touchBegan Method)
    var top, bottom, leading, trailing: NSLayoutConstraint?
    // If view is scaled to maxsize
    var fullyScaled: Bool = false
    // If view is scaled to full screen
    var isFullScreen: Bool = false
    
    // Size of TimeCell where the detail view comes from
    // Necesarry to calculate the presure sensitive scaling
    let initFrame: CGRect
    
    // Text fields to present lesson information
    let lessonName = DescribtedTextField(Language.translate("AddLesson_Lesson"))
    let roomNumber = DescribtedTextField(Language.translate("AddLesson_Room"))
    let time = DescribtedTextField(Language.translate("Time"))
    
    private var addedViews = [DescribtedTextField]()
    
    init(lesson: TimetableLesson, frame: CGRect) {
        initFrame = frame
        super.init(frame: frame)
        
        backgroundColor = .contrast
        
        
        addedViews = [lessonName, time]
        
        if lesson.info != "" {
            addedViews.append(roomNumber)
        }
        
        layer.masksToBounds = false
        layer.cornerRadius = 8
        translatesAutoresizingMaskIntoConstraints = false
        
        stackViews(addedViews)
        
        clipsToBounds = true
        
        lessonName.text = lesson.lessonName
        roomNumber.text = lesson.info == "" ? "-" : lesson.info
        time.text = "\(lesson.startTime.description) - \(lesson.endTime.description)"
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("moved")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeFromSuperview()
    }
    
    
    private func stackViews(_ views: [DescribtedTextField]) {
        
        var anchor: NSLayoutYAxisAnchor = topAnchor
        for view in views {
            addSubview(view)
            view.textField.isEnabled = false
            view.clipsToBounds = true
//            view.descrLabel.clipsToBounds = true
            view.topAnchor.constraint(equalTo: anchor, constant: 45).isActive = true
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
            view.heightAnchor.constraint(equalToConstant: 60).isActive = true
            anchor = view.bottomAnchor
        }
        
    }
    
    
    func activateConstraints() {
        [top!, leading!, bottom!, trailing!].forEach { $0.isActive = true }
    }
    
    func fullScale() {
        
        if fullyScaled {
            return
        }else {
            fullyScaled = true
        }
        // Taptic Engine feedback
        let taptic = UIImpactFeedbackGenerator(style: .medium)
        taptic.prepare()
        taptic.impactOccurred()
        
        
        UIView.animate(withDuration: 0.2) {
            // Scale to 100%
            self.scale(1)
            // Change background
            self.backgroundColor = .background
            // Update superview
            self.superview!.layoutIfNeeded()
        }
    }
    
    func prepare() {
        let sv = superview!
        shadow.translatesAutoresizingMaskIntoConstraints = false
        shadow.backgroundColor = .background
        
        sv.addSubview(shadow)
        sv.layer.masksToBounds = false
        
        // Setup shadow parameters
        shadow.layer.shadowRadius = 15
        shadow.layer.shadowOpacity = 1
        shadow.layer.shadowColor = UIColor.black.cgColor
        
        // Constraint shadow to match size
        shadow.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        shadow.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        shadow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        shadow.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        sv.bringSubview(toFront: self)
        
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        // Remove shadow when view is removed
        shadow.removeFromSuperview()
    }
    
    func fullScreen(_ com: @escaping ((Bool) -> Void)){
        if isFullScreen{
            return
        }
        
        isFullScreen = true
        
        // Vibrate
        let taptic = UIImpactFeedbackGenerator(style: .heavy)
        taptic.prepare()
        taptic.impactOccurred()
        // Animate to full screen
        UIView.animate(withDuration: 0.05, animations: {
            // Scale to fullscreen
            
            self.top!.constant = -self.initFrame.minY
            
            self.leading!.constant = -self.initFrame.minX
            
            self.bottom!.constant = UIScreen.main.bounds.height - self.initFrame.maxY
            
            self.trailing!.constant = UIScreen.main.bounds.width - self.initFrame.maxX
            
            self.superview?.layoutIfNeeded()
            
        }, completion: com)
    }
    
    func downScale() {
        UIView.animate(withDuration: 0.1, animations: {
            // Scale back to original size
            self.top!.constant = 0
            self.leading!.constant = 0
            self.bottom!.constant = 0
            self.trailing!.constant = 0
            self.superview?.layoutIfNeeded()
//            self.backgroundColor = .appRed
        }) { (b) in
            // When finished -> remove from superview
            self.removeFromSuperview()
        }
    }
    
    func updateAnchors(_ force: CGFloat) {
    
        switch scaleState {
            // Touch started
            case 0:
                if force < 0.35 {
                    scale(force)
                }else {
                    scaleState = 1
                }
            // FullyScalled scaling
            case 1:
                fullScale()
                scaleState = 2
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
                    self.scaleState = 3
                }
            
            // Repress -> smoother user experiance
            case 2:
                if  force < 0.2 {
                    //scale(1 + force / 10)
                    scaleState = 3
                }
            // After fullyScalled
            case 3:
                if  force < 0.5 {
                    scale(1 + force / 10)
                }
            case 4:
                return
            default:
                print("Default switch")
            }
        
    }
    
    // Scales the view by 'force' percentage (changes background color)
    private func scale(_ force: CGFloat){
        self.top!.constant = ( 80 - self.initFrame.minY) * force
        self.leading!.constant = (15 - self.initFrame.minX) * force
        self.bottom!.constant = (UIScreen.main.bounds.height - self.initFrame.maxY - 80) * force
        self.trailing!.constant = (UIScreen.main.bounds.width - self.initFrame.maxX - 15) * force
        
        self.backgroundColor = UIColor.contrast.interpolateRGBColorTo(.background, fraction: adjustedSigmoid(force))
        
        let cl = UIColor.background.interpolateRGBColorTo(.contrast, fraction: self.adjustedSigmoid(force * 1.5))
        addedViews.forEach { (field) in
            field.color(cl!)
        }
        
    }
    
    //Veränderte Sigmoid Funktion. Startet bei x = 0 fast bei 0 und steigt bis x = 0.5 schnell an
    //Kein linearer Verlauf für die Skalierung
    private func adjustedSigmoid(_ x: CGFloat) -> CGFloat {
        return 1.0 / (1 + exp(-7.5 * x + 3.5))
    }
    
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
