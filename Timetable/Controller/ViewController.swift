//
//  ViewController.swift
//  Timetable
//
//  Created by Jonah Schueller on 27.02.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit
//import GoogleMobileAds
import Firebase
//import FBAudienceNetwork

//Lies die Intergrationsanweisungen und lade das SDK herunter:
//https://developers.facebook.com/docs/audience-network/ios
//Plattform:    iOS-App
//Format:    Nativ
//Placement ID:    602091090165655_602103216831109



class ViewController : UIViewController, DataUpdateDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate{
    
    static var controller: ViewController!
    
    var timetableView: TimetableView!
//    var dayIndicator:r DayIndicator!
    var homeView = UIView()
    
    var lessonEditView: LessonEditViewController?
    var lessonAddView:  LessonAddViewController?
    
    var panGesture: UIPanGestureRecognizer!
    var animator: UIViewPropertyAnimator!
    
    // Top Bar (Menu Button, Title, Search)
    var homeTop = UIView()
    var menu = UIButton()
    var closeMenu = UIButton()
    var titleLabel = UILabel()
    var search = UIButton()
    
    // Menu Section View
    var subjectMenuSectoinView = SubjectMenuSectionView()
    var taskMenuSectionView = TaskMenuSectionView()
    
    // SubjectViewController
    var subjectViewController = SubjectViewController()
    
    
    
    var statusBarStyle: UIStatusBarStyle = .lightContent{
        didSet{
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get{
            return statusBarStyle
        }
    }
    
    // Lock to portrait mode
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewController.controller = self
        
        Database.database.delegate = self
        
        view.backgroundColor = .background
        
        homeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(homeView)
        homeView.constraint(to: view)
        
        TimetableView.detailView = homeView
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanSwipeDown(_:)))
        homeView.addGestureRecognizer(panGesture)
        panGesture.delegate = self
        
        setupTimetableView()
        setupTopBar()
        

        setupMenuSectionViews()
        
        toCurrentDay()
        
        view.translatesAutoresizingMaskIntoConstraints = true
    
    }
    
    private func setupTimetableView(){
        // Setup essential things
        timetableView = TimetableView()
        timetableView.delegate = self
        homeView.addSubview(timetableView)
        timetableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup ui constraints
        timetableView.topAnchor.constraint(equalTo: homeView.centerYAnchor, constant: -100).isActive = true
        timetableView.bottomAnchor.constraint(equalTo: homeView.bottomAnchor, constant: -30).isActive = true
        timetableView.leadingAnchor.constraint(equalTo: homeView.leadingAnchor, constant: 30).isActive = true
        timetableView.trailingAnchor.constraint(equalTo: homeView.trailingAnchor, constant: -30).isActive = true
        
    }
    
    
    private func setupTopBar(){
        
        homeView.addSubview(homeTop)
        homeTop.translatesAutoresizingMaskIntoConstraints = false
        
        homeTop.constraint(topAnchor: view.safeAreaLayoutGuide.topAnchor, leading: homeView.leadingAnchor, trailing: homeView.trailingAnchor, bottom: homeView.centerYAnchor, topOffset: 0, leadingOff: 0, trailingOff: 0, bottomOff: -100)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        homeTop.addSubview(titleLabel)
        
        titleLabel.text = "Timetable"
        titleLabel.textColor = .appWhite
        titleLabel.font = UIFont.robotoBold(23)
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .center
        
        titleLabel.topAnchor.constraint(equalTo: homeTop.topAnchor, constant: 15).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: homeTop.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let imageSize: CGFloat = 25
        // Setup Menu Hamburger Button
        menu.translatesAutoresizingMaskIntoConstraints = false
        homeTop.addSubview(menu)
        
        menu.topAnchor.constraint(equalTo: homeTop.topAnchor, constant: 15).isActive = true
        menu.leadingAnchor.constraint(equalTo: homeTop.leadingAnchor, constant: 15).isActive = true
        menu.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        menu.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        menu.addTarget(self, action: #selector(animateOpenMenu), for: .touchUpInside)
        
        menu.setImage(UIImage(cgImage: #imageLiteral(resourceName: "Menu").cgImage!, scale: 1.0, orientation: UIImageOrientation.upMirrored).withRenderingMode(.alwaysTemplate), for: .normal)
        menu.imageView!.tintColor = .appWhite
        
        menu.titleEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        // Setup menu hide (cross) button
        closeMenu.translatesAutoresizingMaskIntoConstraints = false
        homeTop.addSubview(closeMenu)
        
        closeMenu.bottomAnchor.constraint(equalTo: menu.topAnchor).isActive = true
        closeMenu.leadingAnchor.constraint(equalTo: homeTop.leadingAnchor, constant: 15).isActive = true
        closeMenu.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        closeMenu.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        closeMenu.addTarget(self, action: #selector(animateCloseMenu), for: .touchUpInside)
        
        closeMenu.setImage(#imageLiteral(resourceName: "Cross").withRenderingMode(.alwaysTemplate), for: .normal)
        closeMenu.imageView!.tintColor = .appWhite
        closeMenu.titleEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        closeMenu.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        closeMenu.alpha = 0.0
        
        // Setup search hide button
        search.translatesAutoresizingMaskIntoConstraints = false
        homeTop.addSubview(search)
        
        search.topAnchor.constraint(equalTo: homeTop.topAnchor, constant: 15).isActive = true
        search.trailingAnchor.constraint(equalTo: homeTop.trailingAnchor, constant: -15).isActive = true
        search.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        search.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        search.setImage(UIImage(cgImage: #imageLiteral(resourceName: "search").cgImage!, scale: 1.0, orientation: UIImageOrientation.upMirrored).withRenderingMode(.alwaysTemplate), for: .normal)
        search.imageView!.tintColor = .appWhite
        
    }

    
    private func setupMenuSectionViews(){
        homeView.addSubview(subjectMenuSectoinView)
        subjectMenuSectoinView.translatesAutoresizingMaskIntoConstraints = false
        
        subjectMenuSectoinView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        subjectMenuSectoinView.leadingAnchor.constraint(equalTo: homeView.leadingAnchor, constant: 10).isActive = true
        subjectMenuSectoinView.trailingAnchor.constraint(equalTo: homeView.trailingAnchor, constant: -10).isActive = true
        subjectMenuSectoinView.heightAnchor.constraint(equalTo: homeView.heightAnchor, multiplier: 0.25).isActive = true
        
        subjectMenuSectoinView.alpha = 0.0
        
        
        homeView.addSubview(taskMenuSectionView)
        taskMenuSectionView.translatesAutoresizingMaskIntoConstraints = false
        
        taskMenuSectionView.topAnchor.constraint(equalTo: subjectMenuSectoinView.bottomAnchor, constant: 25).isActive = true
        taskMenuSectionView.leadingAnchor.constraint(equalTo: homeView.leadingAnchor, constant: 10).isActive = true
        taskMenuSectionView.trailingAnchor.constraint(equalTo: homeView.trailingAnchor, constant: -10).isActive = true
        taskMenuSectionView.heightAnchor.constraint(equalTo: homeView.heightAnchor, multiplier: 0.25).isActive = true
        
        taskMenuSectionView.alpha = 0.0
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5.0
    }


    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let gesture = gestureRecognizer as! UIPanGestureRecognizer
        let vel = gesture.velocity(in: view)
        return abs(vel.y) > abs(vel.x) && ((vel.y > 0 && state == 0) || (vel.y < 0 && state == 1))
    }
    
    // 0: TimetableView visable, 1: MenuSection visible
    private var state: Int = 0
    
    @objc func handlePanSwipeDown(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        var swipePercent = (translation.y * (self.state == 1 ? -1.0 : 1.0)) / 200.0
        swipePercent = max(swipePercent, -0.05)
        swipePercent = min(swipePercent, 1.05)
        
        
        switch gesture.state {
            
        case .began:
            
            animator?.pauseAnimation()
            
            animator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 0.75, animations: {
                if self.state == 0 {
                    self.animate()
                }else {
                    self.animateReversed()
                }
            })
            animator.addCompletion { (_) in
                self.state = self.state == 0 ? 1 : 0
//                print("Complete animation: \(self.state)")
            }
            animator.startAnimation()
            animator.pauseAnimation()
            
        case .changed:
            
            animator.fractionComplete = swipePercent
            
        case .ended:
            let vel = gesture.velocity(in: gesture.view).y
            
            // Swipe up
            if (vel < 0 && state == 0) || (vel > 0 && state == 1) {
//                print("Reverse animation")
                animator.isReversed = true
            }
            
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 1)
            
        default:
            print("Some other case occured TimetableDetailView.handlePan")
        }
    }
    
    
    func animate(){
        timetableView.transform = CGAffineTransform(translationX: 0, y: 100)
        timetableView.alpha = 0
        
        menu.transform = CGAffineTransform(translationX: 0, y: 25).scaledBy(x: 1.0, y: 0.5)
//        menu.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        menu.alpha = 0.0
        closeMenu.transform = CGAffineTransform(translationX: 0, y: 25).scaledBy(x: 1.0, y: 1.0)
//        closeMenu.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        closeMenu.alpha = 1.0
        
        self.subjectMenuSectoinView.alpha = 1.0
        self.taskMenuSectionView.alpha = 1.0
        
        homeTop.layoutIfNeeded()
        homeView.layoutIfNeeded()
    }
    
    func animateReversed(){
        timetableView.transform = CGAffineTransform(translationX: 0, y: 0)
        timetableView.alpha = 1.0
        
        menu.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: 1.0, y: 1.0)
//        menu.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        menu.alpha = 1.0
        closeMenu.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: 1.0, y: 0.5)
//        closeMenu.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        closeMenu.alpha = 0.0
        
        self.subjectMenuSectoinView.alpha = 0.0
        self.taskMenuSectionView.alpha = 0.0
        
        homeTop.layoutIfNeeded()
        homeView.layoutIfNeeded()
    }
    
    @objc func animateOpenMenu(){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.animate()
        }) { _ in
            self.state = self.state == 0 ? 1 : 0
//            print("Complete animation: \(self.state)")
        }
        
    }
    
    @objc func animateCloseMenu(){
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.animateReversed()
        }){ _ in
            self.state = self.state == 0 ? 1 : 0
//            print("Complete animation: \(self.state)")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset.y = 0
        }
//
//        let percentage = scrollView.contentOffset.x / scrollView.contentSize.width
////        dayIndicator.scroll(percentage)
//
    }
    
    
    func lessonAdd(reason: DataUpdateType, _ data: [String : String]) {
        let lesson = TimetableLesson(data)
        timetableView.addTimetableLesson(lesson)
        print("New Lesson: \(data)")
    }
    
    func lessonChange(reason: DataUpdateType, _ data: [String : String]) {
        if reason == .LessonChange {
            timetableView.updateTimetableLesson(data)
        }
    }
    
    func lessonRemove(reason: DataUpdateType, _ data: [String : String]) {
        if reason == .LessonRemove {
            timetableView.removeTimetableLesson(data)
        }
    }
    
    func subjectAdd(reason: DataUpdateType, _ data: [String : String]) {
        subjectMenuSectoinView.reload()
    }
    
    func subjectChange(reason: DataUpdateType, _ data: [String : String]) {
        subjectMenuSectoinView.reload()
    }
    
    func subjectRemove(reason: DataUpdateType, _ data: [String : String]) {
        subjectMenuSectoinView.reload()
    }
    
    func profileChange(reason: DataUpdateType, _ data: [String : String]) {
        
    }
    
    func taskAdd(reason: DataUpdateType, _ data: [String : String]) {
        taskMenuSectionView.reload()
        subjectViewController.reloadData()
    }
    
    func taskChange(reason: DataUpdateType, _ data: [String : String]) {
        taskMenuSectionView.reload()
        subjectViewController.reloadData()
        
    }
    
    func taskRemove(reason: DataUpdateType, _ data: [String : String]) {
        taskMenuSectionView.reload()
        subjectViewController.reloadData()
    }
    
    /// - Returns: The Number in the week (Monday: 1, Tuesday: 2, ...)
    func getCurrentDayNumber() -> Int{
        let num = Calendar.current.dateComponents([.weekday], from: Date()).weekday! - 1
        print("D \(num)")
        return num == 0 ? 7 : num
    }
    
    /// Scrolls the day scrollview to a given day
    ///
    /// - Parameter day: target day
    func toDayView(_ day: Day) {
        view.layoutIfNeeded()
        timetableView.scrollToDay(day: day)
    }
    
    
    /// Scrolls the day scrollView to the current day
    @objc func toCurrentDay(){
        let num = getCurrentDayNumber()
        toDayView(Day(rawValue: num)!)
    }

    
    /// Scales down the homeView (view with the timetable views) by a given percent
    ///
    /// - Parameter factor: Percent how much the view should be scaled down (0.0 = No scale down)
    func scaleDown(_ factor: CGFloat){
        
        let tr = CGAffineTransform(scaleX: 1.0 - factor * 0.1, y: 1.0 - factor * 0.1)
        homeView.transform = tr
        
        homeView.layer.masksToBounds = true
        homeView.layer.cornerRadius = 10 * factor
    }
    
    func presentCardPopupViewController(_ vc: CardPopupViewController){
        if !childViewControllers.contains(vc) {
            setupCardPopupViewController(vc)
        }
        
        vc.view.isHidden = false
        UIView.animate(withDuration: 0.35, animations: {
            ViewController.controller.scaleDown(0.8)
            vc.fadeIn()
//            vc.bottomConstraint.isActive = false
//            vc.topConstraint.isActive = true
            vc.view.layoutIfNeeded()
            self.view.layoutIfNeeded()
        })
    }
    
    func dismissCardPopupViewController(_ vc: CardPopupViewController){
        
        UIView.animate(withDuration: 0.35, animations: {
            ViewController.controller.scaleDown(0)
            vc.fadeOut()
            vc.view.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }){ _ in
            vc.view.isHidden = true
        }
        
    }
    
    func presentEditViewController(_ lesson: TimetableLesson) {
        if lessonEditView == nil {
            lessonEditView = LessonEditViewController()
        }
        lessonEditView!.lesson = lesson
        presentCardPopupViewController(lessonEditView!)
    }
    
    func presentAddViewController() {
        if lessonAddView == nil {
            lessonAddView = LessonAddViewController()
        }
        presentCardPopupViewController(lessonAddView!)
    }
    
    func presentChild(viewController: UIViewController) {
        if childViewControllers.contains(viewController) {
            return
        }
        
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        let v = viewController.view!
        v.translatesAutoresizingMaskIntoConstraints = false

        v.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        v.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        v.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        v.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.layoutIfNeeded()
        viewController.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        viewController.view.layoutIfNeeded()
        
        print("SAFE AREA: \(viewController.view.safeAreaInsets)")
    }
    
    func setupCardPopupViewController(_ viewController: CardPopupViewController) {
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        let v = viewController.view!
        v.translatesAutoresizingMaskIntoConstraints = false
        
        v.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        viewController.bottomConstraint = v.topAnchor.constraint(equalTo: view.bottomAnchor)
        v.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        v.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        v.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.layoutIfNeeded()
    }
    
    
    func presentAlertView(title: String, message: String, dismiss: String, confirm: String, _ completion: @escaping (_ result: Bool) -> Void) -> AlertViewConroller{
        let alert = AlertViewConroller()
        
        alert.build(title: title, message: message, dismiss: dismiss, confirm: confirm, completion)
        presentAlertView(alert)
        return alert
    }
    
    func presentAlertView(title: String, message: String, confirm: String, _ completion: @escaping (_ result: Bool) -> Void) -> AlertViewConroller{
        let alert = AlertViewConroller()
        
        alert.build(title: title, message: message, confirm: confirm, completion)
        presentAlertView(alert)
        return alert
    }
    
    func presentAlertView(title: String, message: String, dismiss: String, confirm: String) -> AlertViewConroller{
        let alert = AlertViewConroller()
        
        alert.build(title: title, message: message, confirm: confirm, nil)
        presentAlertView(alert)
        return alert
    }
    
    func presentAlertView(title: String, message: String, confirm: String) -> AlertViewConroller{
        let alert = AlertViewConroller()
        alert.build(title: title, message: message, confirm: confirm, nil)
        presentAlertView(alert)
        return alert
    }
    
    private func presentAlertView(_ alert: AlertViewConroller) {
        alert.rootViewController = self
        addChildViewController(alert)
        view.addSubview(alert.view)
        
        alert.view.frame = view.frame
        alert.view.constraint(to: view)
        view.layoutIfNeeded()
        alert.show()
    }
    
    
    
    
    
    
    
    // Facebook ad stuff
    
    
    
    //        adView = AdView()
    //
    //        view.addSubview(adView)
    //
    //        adView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
    //        adView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    //        adView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    //        adView.heightAnchor.constraint(equalToConstant: 280).isActive = true
    //
    //        let nativeAd = FBNativeAd(placementID: "602091090165655_602103216831109")
    //        nativeAd.delegate = self
    //        nativeAd.loadAd()
    
    
    
    //    var adView: AdView!
    //
    //    func nativeAdDidLoad(_ nativeAd: FBNativeAd) {
    //
    //        nativeAd.registerView(forInteraction: adView, mediaView: adView.adCoverMediaView, iconView: adView.adIconImageView, viewController: self, clickableViews: [adView.adCallToActionButton, adView.adCoverMediaView])
    //
    //        adView.adTitleLabel.text = nativeAd.advertiserName;
    //        adView.adBodyLabel.text = nativeAd.bodyText;
    //        adView.adSocialContext.text = nativeAd.socialContext;
    //        adView.sponsoredLabel.text = nativeAd.sponsoredTranslation;
    //        adView.adCallToActionButton.setTitle(nativeAd.callToAction, for: .normal)
    //        adView.adChoiceView.nativeAd = nativeAd;
    //        adView.adChoiceView.corner = UIRectCorner.topRight
    //    }
}




























//
//
//class OldViewController: UIViewController, UIScrollViewDelegate, DataUpdateDelegate, UIGestureRecognizerDelegate, MenuBarDelegate{
//    func taskAdd(reason: DataUpdateType, _ data: [String : String]) {
//        
//    }
//    
//    func taskChange(reason: DataUpdateType, _ data: [String : String]) {
//        
//    }
//    
//    func taskRemove(reason: DataUpdateType, _ data: [String : String]) {
//        
//    }
//    
//    
//    
//    
//    static var  controller: ViewController?
//    
//    var timetableView: OldTimetableView!
//    var stack = UIStackView()
////    var lessonControl = LessonControl()
//
////    var defaultContent = AbstractMenuView()
//    var currentView: AbstractView!
//    var menuBars = [String: (menuBar: AbstractMenu, content: AbstractView)]()
//
//
////    var lessonDetailViewController: LessonDetailViewController = {
////        let c = LessonDetailViewController()
////
////        return c
////    }()
//
////    lazy var lessonViewController: LessonViewController = {
////        let c = LessonViewController()
////        return c
////    }()
////
//    lazy var menuController: MenuController = {
//        let c = MenuController()
//        c.constraint()
//        c.load()
//        return c
//    }()
//
//    var bannerView: GADBannerView!
//
////    var dayControl = DayControl()
//
//    var menuBar: MenuBar = MenuBar()
//
////    var dayView = [TimetableDayView]()
////
//    var currentDay: CGFloat = 0
//
//    override var preferredStatusBarStyle: UIStatusBarStyle{
//        return .default
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        Database.database.configure {
//////            self.loadViews()
////        }
//        Database.database.delegate = self
//
////        TimetableDayView.detailSuperview = view
//
//        currentDay = 0
//
//
//        addBannerToView()
//
//        setupMenuBar()
//
//        setupMenuViews()
//
////        addView("default", (menuBar: menuBar.defaultContent, content: timetableView))
//
//        setupView()
//
//        bannerView.rootViewController = self
//
//        // Google test
////        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        // Timetable
//        bannerView.adUnitID = "ca-app-pub-4090633946148380/1818556045"
//        let request = GADRequest()
//        request.testDevices = ["c434183d62d7efd2c75682afe89f7ffc"]
//        bannerView.load(request)
//
////        if ViewController.controller == nil {
////            ViewController.controller = self
////        }
//
//
//        timetableView.delegate = self
//
//        loadView(key: "default")
////        view.layoutIfNeeded()
//
//        // Connect to Firebase and update ui
//
//
//        view.layoutIfNeeded()
//        timetableView.layoutIfNeeded()
//
//        toCurrentDay()
//
//        timetableView.alwaysBounceHorizontal = false
//
//
//        let edge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
//
//        edge.edges = .left
//        edge.delegate = self
//
//        view.addGestureRecognizer(edge)
//
//    }
//
//
//
//    // Override these 3 gestureRecognizer methods to allow scrollView and gestureRecognizer at the same time
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return false
//    }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
//        return false
//    }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//
//        return true
//    }
//
//
//    /// Handler for draging the side menu into the view
//    ///
//    /// - Parameter sender: Egde Gesture recognizer
//    @objc func handleEdgePan(_ sender: UIScreenEdgePanGestureRecognizer) {
//        if !menuController.menu.isEnabled {
//            return
//        }
//
//        if sender.state == .began {
//            menuController.load()
//            timetableView.isScrollEnabled = false
//        }else if sender.state == .ended{
//            menuController.menu.fadeIn()
//            timetableView.isScrollEnabled = true
//        }
//
//        menuController.menu.handleDrag(sender)
//
//    }
//
//
//    private func setupMenuViews() {
//
//        timetableView = OldTimetableView()
////        self.addView("default", (menuBar: menuBar.defaultContent, content: timetableView))
////
//        let editView = OldLessonEditView()
//        let editMenu = OldLessonEditMenu(editView)
//        editView.menu = editMenu
//        editView.addPanGesture(delegate: self)
//        self.addView("edit", (menuBar: editMenu, content: editView))
//
//        let profileView = ProfileView()
//        let profileMenu = ProfileMenu(view: profileView)
//        profileView.menu = profileMenu
//        profileView.addPanGesture(delegate: self)
//        self.addView("profile", (menuBar: profileMenu, content: profileView))
//
//        let addView = OldLessonAddView()
//        let addMenu = LessonAddMenu(view: addView)
//        addView.menu = addMenu
//        addView.addPanGesture(delegate: self)
//        self.addView("add", (menuBar: addMenu, content: addView))
//
//        let chatView = ChatView()
//        let chatMenu = ChatMenu(view: chatView)
//        chatView.menu = chatMenu
//        self.addView("chat", (menuBar: chatMenu, content: chatView))
//
//    }
//
//
//
//    // Bottom Ad Banner in superview
//    private func addBannerToView() {
//        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
//
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(bannerView)
//
//        bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        bannerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
//
//    }
//
//
//
//    /// Configure the MenuBar
//    private func setupMenuBar() {
//
//        view.addSubview(menuBar)
//
//        menuBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        menuBar.heightAnchor.constraint(equalToConstant: 70).isActive = true
//        menuBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        menuBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
//
//        menuBar.delegate = self
//    }
//
//
//
//    /// Lays out all of the views of the timetable, menubar and side menu
//    private func setupView(){
//        view.backgroundColor = .contrast
//
//        // LEAVE THIS!! YES IT'S DOUBLE SET DOWN BELOW!! -> view.translatesAutoresizingMaskIntoConstraints = false
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        // Consraint timetable content scrollview and timetableviews
//
//        // Setup the menubar items
//        setupMenuItems()
//
//
//        // VERY IMPORTANT!!!!! view.translatesAutoresizingMaskIntoConstraints = TRUE!! superview must have it set to TRUE otherwise layout is broken after viewController change
//        view.translatesAutoresizingMaskIntoConstraints = true
//
//
////        timetableView.contentSize = CGSize(width: CGFloat(timetableView.dayView.count) * UIScreen.main.bounds.width, height: timetableView.frame.height - 1)
////
//    }
//
//
//    /// Menu bar setup
//    ///
//    /// - Parameters:
//    ///   - key: view key
//    ///   - bar: menubar
//    func addView(_ key: String, _ view: (menuBar: AbstractMenu, content: AbstractView)) {
//        let sv = self.view!
//        menuBars[key] = view
//        view.content.isHidden = true
//        menuBar.addMenuBar(key, view.menuBar)
//
//        sv.addSubview(view.content)
//
//        view.content.translatesAutoresizingMaskIntoConstraints = false
//
//        view.content.topAnchor.constraint(equalTo: menuBar.bottomAnchor).isActive = true
//        view.content.leadingAnchor.constraint(equalTo: sv.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        view.content.bottomAnchor.constraint(equalTo: bannerView.topAnchor).isActive = true
//        view.content.trailingAnchor.constraint(equalTo: sv.safeAreaLayoutGuide.trailingAnchor).isActive = true
//
//    }
//
//
//    /// Loads a view based on a key
//    /// Updates the menubar and view content
//    /// - Parameter key: Key for the view
//    func loadView(key: String, data: Any? = nil){
//        if let view = menuBars[key] {
//            currentView?.close()
//            if currentView != timetableView {
//                currentView?.isHidden = true
//            }
//            currentView = view.content
//            view.content.open(data)
//            currentView?.isHidden = false
//            menuBar.loadMenuBar(key: key)
//
//        } else {
//            fatalError("Error while loading a view: Key '\(key)' was not found!")
//        }
//    }
//
//    func getView(key: String) -> AbstractView? {
//
//        for view in menuBars {
//            if view.key == key {
//                return view.value.content
//            }
//        }
//        return nil
//    }
//
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//        currentDay = timetableView.contentOffset.x / timetableView.contentSize.width
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        // Update content offset to fit previous state
//        updateScrollView()
//
//
//        if currentView == timetableView{
//            menuBar.defaultContent.alpha = 1.0
////            currentView.close()
//        }else {
//            currentView.resetLayout()
//            menuBar.defaultContent.alpha = 0.0
//        }
//    }
//
//    func updateScrollView() {
//        // Set new content size
//        timetableView.contentSize.width = UIScreen.main.bounds.width * 7
//
//        // Update content offset to fit previous state
//
//        let pt = CGPoint(x: currentDay * timetableView.contentSize.width, y: 0)
//        timetableView.setContentOffset(pt, animated: false)
//
//
//    }
//
//
//    /// When day scrollView scrolls
//    ///
//    /// - Parameter scrollView: day scrollView
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        // Block vertical scrolling
//        if scrollView.contentOffset.y != 0 {
//            scrollView.contentOffset.y = 0
//        }
//
//        // Calculate percentage how much the scrollView is scrolled
//        let p = ((scrollView.contentOffset.x) / (UIScreen.main.bounds.width))
//
//
//        // 150 -> width of scrollView in the menubar
//        // Update the menuBar day indicator
//        menuBar.scrollView.setContentOffset(CGPoint(x: p * 150, y: 0), animated: false)
//    }
//
//
//
//    ///
//    ///
//    /// - Parameter day: Day which view should be returned
//    /// - Returns: TimetableView corresponding to the day
//    func getTimetableDay(_ day: Day) -> TimetableDayView? {
//
////        for d in timetableView.dayView {
////            if d.day == day {
////                return d
////            }
////        }
//
//        return nil
//    }
//
//
//    ///
//    ///
//    /// - Returns: The name of the day in the week
//    func getCurrentDay() -> String {
//        let date = DateFormatter()
//        date.dateFormat = "EEEE"
//        return date.string(from: Date())
//    }
//
//
//    ///
//    ///
//    /// - Returns: The Number in the week (Monday: 1, Tuesday: 2, ...)
//    func getCurrentDayNumber() -> Int{
//        let num = Calendar.current.dateComponents([.weekday], from: Date()).weekday! - 1
//        print("D \(num)")
//        return num == 0 ? 7 : num
//    }
//
//
//    /// Scrolls the day scrollview to a given day
//    ///
//    /// - Parameter day: target day
//    func toDayView(_ day: Day) {
//        let num = Int(day.rawValue)
//        let point = CGPoint(x: CGFloat((num - 1) * Int(UIScreen.main.bounds.width)), y: timetableView.contentOffset.y)
//        timetableView.setContentOffset(point, animated: true)
//
//    }
//
//
//    /// Scrolls the day scrollView to the current day
//    @objc func toCurrentDay(){
//        let num = getCurrentDayNumber()
//        toDayView(Day(rawValue: num)!)
//    }
//
//
//
//
//    /// Sets up the Side Menu with its items
//    func setupMenuItems() {
//        let menu = menuController.menu
//        menu.addItem(title: "Home", target: self, action: #selector(loadTimetable))
//
//        menu.addItem(title: Language.translate("Profile"), target: self, action: #selector(loadProfileView))
//
//        menu.addSeparator()
//    }
//
//    @objc func loadSubjectView(_ sender: UIButton) {
//        print("taped: \(sender.titleLabel!.text!)")
//        let name = sender.titleLabel!.text!
//        loadView(key: "chat", data: Database.database.getSubject(name))
//        menuController.menu.fadeOut()
//    }
//
//    /// Loads the timetable view and the default menuBar
//    @objc func loadTimetable() {
//        loadView(key: "default")
//        menuController.menu.fadeOut()
//    }
//
//    /// Loads the profile view and the menuBar
//    @objc func loadProfileView() {
//        loadView(key: "profile")
//        menuController.menu.fadeOut()
//    }
//
//
//
//    /// Loads the 'edit' view.
//    ///
//    /// - Parameter lesson: Lesson for the detail/ editing
//    func loadLessonEditView(_ lesson: TimetableLesson) {
//
//        loadView(key: "edit", data: lesson)
//    }
//
//
//    func dismissLessonDetailViewConroller(){
//        dismiss(animated: true, completion: nil)
//    }
//
//
//
//    private func addLesson(_ data: [String : String]) /*-> TimetableLesson */{
////        let lesson = TimetableLesson(data)
////        getTimetableDay(lesson.day)?.addLesson(lesson)
////        return lesson
//    }
//
//
//    private func changeLesson(_ data: [String : String]) {
//
////        let lesson = TimetableLesson(data)
////        let day = getTimetableDay(lesson.day)
////        let cell = day?.getCell(withID: lesson.id)
////
////        if let cell = cell {
////            cell.titleLabel.text = lesson.lessonName
////            cell.lesson = lesson
////            day?.reconstraintCell(cell)
////        }
//    }
//
//    private func removeLesson(_ data: [String : String]){
//        removeLesson(TimetableLesson(data))
//    }
//
//
//    /// Removes the UI of the lesson
//    /// - Parameter lesson: Lesson that will be removed from the timetable
//    func removeLesson(_ lesson: TimetableLesson) {
////        for day in timetableView.dayView {
////            day.removeCell(lesson)
////        }
//    }
//
//
//
//    /// Part of the MenuBarDelegate
//    /// Called when SideMenu Button was hit
//    @objc func sideMenu() {
//        menuController.loadAndFadeIn()
//    }
//
//
//    /// Part of the MenuBarDelegate
//    /// Called when 'today' button was hit on the menuBar
//    @objc func today() {
//        toCurrentDay()
//    }
//
//
//    /// Part of the MenuBarDelegate
//    /// Called when 'add' button was hit on the menuBar
//    /// Loads the add view
//    @objc func add() {
//        loadView(key: "add")
//
//    }
//
//    func lessonAdd(reason: DataUpdateType, _ data: [String : String]) {
////        print("LessonAdd : \(data)")
//        if reason == .LessonAdd{
//            addLesson(data)
//        }
//    }
//
//    func lessonChange(reason: DataUpdateType, _ data: [String : String]) {
////        print("LessonChange : \(data)")
//        if reason == .LessonChange{
//            changeLesson(data)
//        }
//    }
//
//    func lessonRemove(reason: DataUpdateType, _ data: [String : String]) {
////        print("LessonRemove : \(data)")
//        if reason == .LessonRemove {
//            removeLesson(data)
//        }
//    }
//
//    func subjectAdd(reason: DataUpdateType, _ data: [String : String]) {
//        print("SubjectAdd : \(data)")
//        if reason == .SubjectAdd{
//            menuController.menu.addItem(title: data["lessonName"]!, target: self, action: #selector(loadSubjectView(_:)))
//        }
//    }
//
//    func subjectChange(reason: DataUpdateType, _ data: [String : String]) {
//        print("SubjectChange : \(data)")
//        if reason == .SubjectChange{
//            menuController.menu.changeItem(title: data["lessonName"]!)
//        }
//    }
//
//    func subjectRemove(reason: DataUpdateType, _ data: [String : String]) {
//        print("SubjectRemove : \(data)")
//        if reason == .SubjectRemove {
//            menuController.menu.removeItem(title: data["lessonName"]!)
//        }
//    }
//
//    func profileChange(reason: DataUpdateType, _ data: [String : String]) {
//        print("Profile Change: \(data)")
//        if reason == .ProfileChange {
//            if let view = getView(key: "profile") as? ProfileView {
//                view.setValues(data)
//            }
//        }
//    }
//
//    func presentAlertView(title: String, message: String, dismiss: String, confirm: String, _ completion: @escaping (_ result: Bool) -> Void) -> AlertViewConroller{
//        let alert = AlertViewConroller()
//        alert.rootViewController = self
//
//        alert.build(title: title, message: message, dismiss: dismiss, confirm: confirm, completion)
//        alert.view.frame = view.frame
//        addChildViewController(alert)
//        view.addSubview(alert.view)
//        menuController.menu.isEnabled = false
//        return alert
//    }
//
//    func presentAlertView(title: String, message: String, confirm: String, _ completion: @escaping (_ result: Bool) -> Void) -> AlertViewConroller{
//        let alert = AlertViewConroller()
//        alert.rootViewController = self
//
//        alert.build(title: title, message: message, confirm: confirm, completion)
//        alert.view.frame = view.frame
//        addChildViewController(alert)
//        view.addSubview(alert.view)
//        menuController.menu.isEnabled = false
//        return alert
//    }
//
//    func presentAlertView(title: String, message: String, dismiss: String, confirm: String) -> AlertViewConroller{
//        let alert = AlertViewConroller()
//        alert.rootViewController = self
//
//        alert.build(title: title, message: message, confirm: confirm, nil)
//        alert.view.frame = view.frame
//        addChildViewController(alert)
//        view.addSubview(alert.view)
//        menuController.menu.isEnabled = false
//        return alert
//    }
//
//    func presentAlertView(title: String, message: String, confirm: String) -> AlertViewConroller{
//        let alert = AlertViewConroller()
//        alert.rootViewController = self
//
//        alert.build(title: title, message: message, confirm: confirm, nil)
//        alert.view.frame = view.frame
//        addChildViewController(alert)
//        view.addSubview(alert.view)
//        menuController.menu.isEnabled = false
//        return alert
//    }
//
//
//    func presentChildViewController(_ viewController: UIViewController) {
//
//        addChildViewController(viewController)
//        view.addSubview(viewController.view)
//        let v = viewController.view!
//        v.translatesAutoresizingMaskIntoConstraints = false
//
//        v.topAnchor.constraint(equalTo: menuBar.bottomAnchor,constant: 15).isActive = true
//        v.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        v.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        v.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//
//    }
//
//
//
//
//
//
//}
//
