//
//  MasterDetailView.swift
//  Timetable
//
//  Created by Jonah Schueller on 03.07.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

protocol MasterDetailViewDelegate{
    
    func didDissmisDetailView<DataType>(_ detailView: MasterDetailView<DataType>, _ completion: Bool)
    
    func didShowDetailView<DataType>(_ detailView: MasterDetailView<DataType>)
    
    func didReloadData<DataType>(_ detailView: MasterDetailView<DataType>, data: DataType)
    
    func dismissAnimationDuration<DataType>(_ detailView: MasterDetailView<DataType>) -> CGFloat
 
    func fadeInAnimationDuration<DataType>(_ detailView: MasterDetailView<DataType>) -> CGFloat
}

extension MasterDetailViewDelegate {
    func dismissAnimationDuration<DataType>(_ detailView: MasterDetailView<DataType>) -> CGFloat{
        return 0.25
    }
    
    func fadeInAnimationDuration<DataType>(_ detailView: MasterDetailView<DataType>) -> CGFloat{
        return 0.25
    }
}

enum DragDirection{
    case up
    case down
    case left
    case right
    case none
    
    static func getDirection(for velocity: CGPoint) -> DragDirection{
        let x = velocity.x
        let y = velocity.y
        
        if abs(x) > abs(y){
            if x > 0 {
                return .right
            }else if x < 0{
                return .left
            }
        }else if abs(x) < abs(y) {
            if y > 0 {
                return .down
            }else if x < 0{
                return .up
            }
        }
        
        // Velocity is equal to (0.0, 0.0)
        return .none
    }
}

class MasterDetailView<DataType: LocalData>: UIView, UIGestureRecognizerDelegate {
    
    var data: DataType? {
        didSet{
            if let d = data {
                reload(d)
            }
        }
    }
    
    var delegate: MasterDetailViewDelegate?
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
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
    
    // Change the header image
    var headerImage: UIImage? {
        get{ return self.imageHeader.image }
        set{ self.imageHeader.image = newValue?.withRenderingMode(.alwaysTemplate) }
    }
    
    lazy var imageHeader: UIImageView = {
        let img = UIImageView(image: #imageLiteral(resourceName: "task").withRenderingMode(.alwaysTemplate))
        img.contentMode = .scaleAspectFit
        img.tintColor = .appWhite
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
    }()
    
    // Set title
    var title: String? {
        get{ return titleLabel.text }
        set{ titleLabel.text = newValue }
    }
    let titleLabel = UILabel()
    
    // Dismiss stuff
    var panGesture: UIPanGestureRecognizer!
    var direction: DragDirection = .none
    var animator: UIViewPropertyAnimator!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.safeArea = safeArea
        
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.0
//        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
        backgroundColor = .background
        
        
        // Setup superviews
        translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        scrollView.constraint(to: self)
        
        // Add and constraint stackview to scrollview
        stackView.addAndConstraint(to: scrollView)
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        stackView.backgroundColor = .background
        
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        
        dismiss.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        stackView.addArrangedSubview(imageHeader)
        imageHeader.widthAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
        imageHeader.heightAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
        
        addStackedView(titleLabel)
        
        titleLabel.font = UIFont.robotoBold(30)
        titleLabel.textColor = .appWhite
        titleLabel.textAlignment = .center
        
        setupPanGesture()
    }
    
    
    
    private func setupPanGesture(){
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
    
    func addStackedView(_ view: UIView, horizontalBounds: CGFloat = 20, height: CGFloat? = 50) {
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(view)
        
//        view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalBounds).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalBounds).isActive = true
        
        
        if let height = height {
            view.heightAnchor.constraint(lessThanOrEqualToConstant: height).isActive = true
        }
        
        stackView.layoutIfNeeded()
        scrollView.contentSize = stackView.frame.size
    }
    
    @objc func handleDismiss(){
        let duration: Double = Double(delegate?.dismissAnimationDuration(self) ?? 0.25)
        
        UIView.animate(withDuration: duration, animations: {
            self.fadeOutLayoutChanges()
            self.layoutIfNeeded()
        }) { (result) in
            self.delegate?.didDissmisDetailView(self, result)
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
        let duration: Double = Double(delegate?.fadeInAnimationDuration(self) ?? 0.25)
        
        UIView.animate(withDuration: duration, animations: {
            self.fadeInLayoutChanges()
            self.layoutIfNeeded()
        }) { (result) in
            self.delegate?.didShowDetailView(self)
        }
    }
    
    func reload(_ data: DataType){
        
    }
    
    func fadeInLayoutChanges(){
        layer.shadowOpacity = 0.0
    }
    
    func fadeOutLayoutChanges(){
        layer.shadowOpacity = 0.7
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
