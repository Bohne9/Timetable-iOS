//
//  MasterDetailTableView.swift
//  Timetable
//
//  Created by Jonah Schueller on 05.07.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class MasterDetailTableView<DataType: LocalData>: UIView, UIGestureRecognizerDelegate {
    
//    let scrollView = UIScrollView()
//    let stackView = UIStackView()
    //    var safeArea: UILayoutGuide!
    
    // Change the dismiss image
    var dismissImage: UIImage? {
        get{ return self.dismiss.imageView?.image }
        set{ self.dismiss.setImage(newValue?.withRenderingMode(.alwaysTemplate), for: .normal) }
    }
    
    lazy var dismiss: UIButton = {
        let btn = UIButton()
        btn.setImage( #imageLiteral(resourceName: "Cross").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView!.tintColor = .appWhite
        btn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(btn)
        btn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        btn.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        btn.titleEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        return btn
    }()
    
    // TableView cell identifier
    var cellIdentifier: String = "undefined"
    let tableView = UITableView()
    
    var data: [DataType] = [] {
        didSet{
            reload()
        }
    }
    
    var detailView: MasterDetailView<DataType>?
    
    // Set title
    var title: String? {
        get{ return titleLabel.text }
        set{ titleLabel.text = newValue }
    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoBold(30)
        label.textColor = .appWhite
        label.textAlignment = .center
        label.numberOfLines = -1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    
    // Dismiss stuff
    var panGesture: UIPanGestureRecognizer!
    var direction: DragDirection = .none
    var animator: UIViewPropertyAnimator!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.0
//        layer.shadowOffset = CGSize(width: 0, height: 20)
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
        backgroundColor = .background
        
        
        dismiss.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        setupUserInterface()
        
        setupPanGesture()
    }
    
    private func setupPanGesture(){
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    private func setupUserInterface(){
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        //        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        //        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15).isActive = true
        
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        
        tableView.separatorColor = UIColor.appWhite.withAlphaComponent(0.4)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
        
    }

    @objc func handleDismiss(){
//        let duration: Double = Double(delegate?.dismissAnimationDuration(self) ?? 0.25)
        let duration = 0.25
        UIView.animate(withDuration: duration, animations: {
            self.fadeOutLayoutChanges()
            self.layoutIfNeeded()
        }) { (result) in
//            self.delegate?.didDissmisDetailView(self, result)
        }
    }
    
    
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        let velocity = gesture.velocity(in: self)
        
        switch gesture.state {
        case .began:
            direction = DragDirection.getDirection(for: velocity)
            print(direction)
            beginDismiss()
        case .changed:
            changeDismiss(gesture)
        case .ended:
            endDismiss(gesture)
            
        default:
            print("DEFAULT")
        }
    }
    
    
    private func beginDismiss(){
        switch direction {
        case .right:
            beginHorizontalDismiss()
        case .up, .down:
            break
        default:
            print("DEFault")
        }
    }
    
    
    
    private func beginHorizontalDismiss(){
        if direction == .right {
            animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.7, animations: {
                self.fadeOutLayoutChanges()
                self.superview!.layoutIfNeeded()
            })
            animator.startAnimation()
            animator.pauseAnimation()
        }
    }
    
    
    private func changeDismiss(_ gesture: UIPanGestureRecognizer){
        switch direction {
        case .right:
            changeHorizontalDismiss(gesture)
        case .up, .down:
            break
        default:
            print("DEfault")
        }
    }
    
    private func changeHorizontalDismiss(_ gesture: UIPanGestureRecognizer){
        let percent = gesture.translation(in: self).x / frame.width
        animator.fractionComplete = percent
    }
    
    private func endDismiss(_ gesture: UIPanGestureRecognizer){
        switch direction {
        case .right:
            endHorizontalDismiss(gesture)
        case .up, .down:
            break
        default:
            print("DEfault")
        }
    }
    
    private func endHorizontalDismiss(_ gesture: UIPanGestureRecognizer){
        let velX = gesture.velocity(in: self).x
        let percent = gesture.translation(in: self).x / frame.width
        
        if velX <= 0 || percent < 0.05{
            animator.isReversed = true
            animator.addAnimations {
                self.layer.shadowOpacity = 0.7
            }
        }else {
            animator.addCompletion { (_) in
                self.layer.shadowOpacity = 0.0
            }
        }
        animator.continueAnimation(withTimingParameters: nil, durationFactor: 1)
    }
    
    func fadeIn(){
//        let duration: Double = Double(delegate?.fadeInAnimationDuration(self) ?? 0.25)
        let duration = 0.25
        UIView.animate(withDuration: duration, animations: {
            self.fadeInLayoutChanges()
            self.layoutIfNeeded()
        }) { (result) in
//            self.delegate?.didShowDetailView(self)
        }
    }
    
    func reload(){
        
    }
    
    func fadeInLayoutChanges(){
        layer.shadowOpacity = 0.0
        transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    func fadeOutLayoutChanges(){
        layer.shadowOpacity = 0.7
        transform = CGAffineTransform(translationX: frame.width, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
}
