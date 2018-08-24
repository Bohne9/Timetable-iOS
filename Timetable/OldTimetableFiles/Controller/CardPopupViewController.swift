//
//  CardPopupViewController.swift
//  Timetable
//
//  Created by Jonah Schueller on 14.06.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//
//import GoogleMobileAds
import UIKit

class CardPopupViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let content = UIView()
    let scroll = UIScrollView()
    let scrollContent = UIView()
    let shadow = UIView()
//    let topBar = UIView()
    let dragIndicator = UIView()
    var topConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    var navigationBar: UINavigationBar = UINavigationBar()
    var panAccuracy: CGFloat = 350.0
    var topOffset: CGFloat = 50.0
    
//    var adView: GADBannerView!
    
    var panGesture: UIPanGestureRecognizer!
    private var scrollViewScrollEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scroll.layer.masksToBounds = true
        scroll.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        scroll.layer.cornerRadius = 10
        
        navigationBar.layer.masksToBounds = true
        navigationBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        navigationBar.layer.cornerRadius = 10
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        shadow.accessibilityIdentifier = "Shadow"
        navigationBar.barTintColor = .contrast
        scroll.backgroundColor = .contrast
        scrollContent.backgroundColor = .contrast
        
        shadow.backgroundColor = .contrast
        view.layer.masksToBounds = false
        shadow.layer.shadowRadius = 30
        shadow.layer.shadowOpacity = 1.0
        shadow.layer.shadowColor = UIColor.black.cgColor
        
        addPanGesture()
        
        setupUserInterface()
        
        scroll.layoutIfNeeded()
        scrollContent.layoutIfNeeded()
        
        scroll.panGestureRecognizer.accessibilityLabel = "scrollPan"
        panGesture.accessibilityLabel = "pan"
        scroll.contentSize = scrollContent.frame.size
    }
    
    func constraintContentBottom(lastView: UIView, offset: CGFloat = 60) {
        scrollContent.bottomAnchor.constraint(equalTo: lastView.bottomAnchor, constant: offset).isActive = true
    }
    
    private func addPanGesture(){
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        content.addGestureRecognizer(panGesture)
        panGesture.delegate = self
    }
    
    func setupUserInterface(){
        // Setup and constraint invisible view. Holds the entire visible view components.
        view.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        
        // Set top and bottom Constraints. Responsible for the drag in and out animation
        topConstraint = content.topAnchor.constraint(equalTo: view.topAnchor, constant: topOffset)
        content.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        content.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomConstraint = content.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        topConstraint.isActive = true
        bottomConstraint.isActive = true
        fadeOut()
        
        
        // Add the shadow effect
        content.addSubview(shadow)
        content.addSubview(scroll)
        shadow.constraint(to: content, topOffset: 10, leading: 10, trailing: -10, bottom: 10)
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        content.addSubview(navigationBar)
        navigationBar.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        navigationBar.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 5).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -5).isActive = true
//        navigationBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
//        loadAd()
        
        // Add Drag Indicator
        
        navigationBar.addSubview(dragIndicator)
        dragIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        dragIndicator.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor).isActive = true
        dragIndicator.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 5).isActive = true
        dragIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        dragIndicator.heightAnchor.constraint(equalToConstant: 6).isActive = true
        
        dragIndicator.backgroundColor = .gray
        dragIndicator.layer.cornerRadius = 3
        dragIndicator.alpha = 0.4
        
        let sep = UIView()
        sep.translatesAutoresizingMaskIntoConstraints = false
        sep.backgroundColor = .gray
        sep.alpha = 0.6
        navigationBar.addSubview(sep)
        
        sep.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor).isActive = true
        sep.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor).isActive = true
        sep.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        sep.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        
        // Add the scrollContent
        scroll.constraint(topAnchor: navigationBar.bottomAnchor, leading: content.leadingAnchor, trailing: content.trailingAnchor, bottom: content.bottomAnchor, topOffset: 0, leadingOff: 5, trailingOff: -5, bottomOff: 0)
        scroll.addSubview(scrollContent)
        scrollContent.translatesAutoresizingMaskIntoConstraints = false
        

        scrollContent.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        scrollContent.leadingAnchor.constraint(equalTo: scroll.leadingAnchor).isActive = true
        scrollContent.trailingAnchor.constraint(equalTo: scrollContent.trailingAnchor).isActive = true
        scrollContent.widthAnchor.constraint(equalTo: scroll.widthAnchor).isActive = true
//        scrollContent.heightAnchor.constraint(equalTo: scroll.heightAnchor).isActive = true
        
//        scroll.bringSubview(toFront: adView)
    }
    
    
//    private func loadAd(){
//        adView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
//        adView.rootViewController = self
//        //        adView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        adView.adUnitID = "ca-app-pub-4090633946148380/1818556045"
//        adView.delegate = self
//
//        adView.translatesAutoresizingMaskIntoConstraints = false
//
//        scroll.addSubview(adView)
//
////        adView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        adView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor).isActive = true
////        adView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: -5).isActive = true
////        adView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: 5).isActive = true
//
//        let request = GADRequest()
//        request.testDevices = ["c434183d62d7efd2c75682afe89f7ffc"]
//        adView.load(request)
//
//    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scroll.contentSize = scrollContent.frame.size
    }
    
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        let transition = gesture.translation(in: view)
        
        if transition.y > 0 {
            topConstraint.constant = topOffset + transition.y
            
            var percent = 1.0 - max(transition.y / panAccuracy, 0.2)
            percent = max(-0.1, percent)
            OldViewController.controller.scaleDown(percent)
        }
        
        if gesture.state == .ended || gesture.state == .cancelled {
            if gesture.velocity(in: view).y >= 0 {
                topConstraint.constant = topOffset
                dismiss()
            }else {
                UIView.animate(withDuration: 0.3) {
                    self.topConstraint.constant = self.topOffset
                    OldViewController.controller.scaleDown(0.8)
                    self.view.superview!.layoutIfNeeded()
                }
            }
        }
    }
    
    
    func fadeIn(){
        topConstraint.constant = topOffset
        bottomConstraint.constant = 0
        OldViewController.controller.statusBarStyle = .lightContent
    }
    
    func fadeOut(){
        topConstraint.constant = view.frame.height
        bottomConstraint.constant = view.frame.height
        OldViewController.controller.statusBarStyle = .default
    }
    
    func present(){
        OldViewController.controller.presentCardPopupViewController(self)
    }
    
    func dismiss(){
        OldViewController.controller.dismissCardPopupViewController(self)
    }
    
}
