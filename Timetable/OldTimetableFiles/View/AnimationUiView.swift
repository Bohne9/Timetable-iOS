//
//  AnimationUiView.swift
//  Timetable
//
//  Created by Jonah Schueller on 01.06.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

struct AnimatedConstraint{
    var constraint: NSLayoutConstraint
    var startValue: CGFloat
    var endValue: CGFloat
    
    var constant: CGFloat{
        get{
            return constraint.constant
        }
        set{
            constraint.constant = newValue
        }
    }
    
    func update(_ value: CGFloat){
        constraint.constant = startValue + value * (endValue - startValue)
    }
    
    func start(){
        constraint.constant = startValue
    }
    
    func end(){
        constraint.constant = endValue
    }
}


class AnimatedProperty{
    
    var property: CGFloat
    var startValue: CGFloat
    var endValue: CGFloat
    
    init(_ property: inout CGFloat, startValue: CGFloat, endValue: CGFloat) {
        self.property = property
        self.startValue = startValue
        self.endValue = endValue
    }
    
    func setProperty(_ property: inout CGFloat) {
        self.property = property
    }
    
    func update(_ value: CGFloat){
        property = startValue + value * (endValue - startValue)
    }
    
    func start(){
        property = startValue
    }

    func end(){
        property = endValue
    }
}


class AnimationUIView: UIView {

    var animatedConstraints = [AnimatedConstraint]()
    var animatedProperties = [AnimatedProperty]()
    var animationFunctions = [(value: CGFloat) -> Void]()
    
    var animator: UIViewPropertyAnimator = UIViewPropertyAnimator()
    
    var displayLink: CADisplayLink?
    var animationDuration = 1.0 {
        didSet{
            if animationDuration == 0.0 {
                fatalError("AnimationDuration must not be equal to 0! (AnimationUIView.animationDuration)")
            }
        }
    }
    private var animationStart = Date()
    
    var isReversed: Bool{
        set{
            animator.isReversed = newValue
        }
        get{
            return animator.isReversed
        }
    }
    
    
    private var percentage: Double = 0
    
    private var lastTime: Date?
    var isPaused: Bool = false{
        didSet{
            animationStart = Date()
            displayLink?.isPaused = isPaused
        }
    }
    
    init() {
        super.init(frame: .zero)
        
    }
    
    
    
    func startDisplayLink(pause: Bool = false){
        if displayLink != nil {
            displayLink?.remove(from: .main, forMode: .defaultRunLoopMode)
        }
        
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkHandle))
        lastTime = Date()
        animationStart = Date()
        displayLink?.add(to: .main, forMode: .defaultRunLoopMode)
//        isPaused = pause
    }
    
    
    
    func update(_ value: CGFloat){
        for constraint in animatedConstraints {
            constraint.update(value)
        }
        for property in animatedProperties {
            property.update(value)
        }
        for function in animationFunctions {
            function(value)
        }
    }
    
    
    @objc func displayLinkHandle(){
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStart)
        
        
//        handleDisplayLink(elapsedTime!)
//
        
        if elapsedTime <= animationDuration {

            handleDisplayLink(percentage)
        }else {
            handleDisplayLink(percentage)
            displayLink?.remove(from: .main, forMode: .defaultRunLoopMode)
            displayLink = nil
        }
    }
    
    
    func handleDisplayLink(_ percentage: Double) {
//        print("(Override AnimationUIView.handleDisplayLink(_:) to remove this message) Handle DisplayLink: \(percentage)")
       
    }
    
    
    
    func updateFunctions(_ value: CGFloat) {
        for function in animationFunctions {
            function(value)
        }
    }
    
    func addAnimationConstraint(anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, equalTo: NSLayoutAnchor<NSLayoutYAxisAnchor>, start: CGFloat = 0, end: CGFloat = 0) {
        let constraint = anchor.constraint(equalTo: equalTo, constant: start)
        constraint.isActive = true
        let animatedConstrait = AnimatedConstraint(constraint: constraint, startValue: start, endValue: end)
        animatedConstraints.append(animatedConstrait)
    }
    
    func addAnimationConstraint(anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, equalTo: NSLayoutAnchor<NSLayoutXAxisAnchor>, start: CGFloat = 0, end: CGFloat = 0) {
        let constraint = anchor.constraint(equalTo: equalTo, constant: start)
        constraint.isActive = true
        let animatedConstrait = AnimatedConstraint(constraint: constraint, startValue: start, endValue: end)
        animatedConstraints.append(animatedConstrait)
    }
    
    func addAnimationConstraint(anchor: NSLayoutAnchor<NSLayoutDimension>, equalTo: NSLayoutAnchor<NSLayoutDimension>, start: CGFloat = 0, end: CGFloat = 0) {
        let constraint = anchor.constraint(equalTo: equalTo, constant: start)
        constraint.isActive = true
        let animatedConstrait = AnimatedConstraint(constraint: constraint, startValue: start, endValue: end)
        animatedConstraints.append(animatedConstrait)
    }
    
    func addAnimationProperty(property: inout CGFloat, start: CGFloat = 0, end: CGFloat = 0) {
        let animatedProperty = AnimatedProperty(&property, startValue: start, endValue: end)
        animatedProperties.append(animatedProperty)
    }
    
    func addAnimationFunction(_ function: @escaping (_ value: CGFloat) -> Void) {
        animationFunctions.append(function)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
