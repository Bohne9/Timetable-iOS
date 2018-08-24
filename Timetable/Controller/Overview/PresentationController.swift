//
//  OverviewDetailAnimationController.swift
//  Timetable
//
//  Created by Jonah Schueller on 10.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.4
    var presenting = true
    var originFrame = CGRect.zero
    
    var dismissCompletion: (()->Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let lessonView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        let initialFrame = presenting ? originFrame : lessonView.frame
        let finalFrame = presenting ? lessonView.frame : originFrame
        
//        let xScaleFactor = presenting ?
//            initialFrame.width / finalFrame.width :
//            finalFrame.width / initialFrame.width
//
//        let yScaleFactor = presenting ?
//            initialFrame.height / finalFrame.height :
//            finalFrame.height / initialFrame.height
//
//        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        let newFrame = presenting ? initialFrame.size : finalFrame.size
        
        if presenting {
//            lessonView.transform = scaleTransform
            
            lessonView.frame.size = newFrame
            lessonView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            lessonView.clipsToBounds = true
        }else {
            transitionContext.view(forKey: .from)?.backgroundColor = .clear
        }
    
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: lessonView)
        
//        lessonView.layer.cornerRadius = 5
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, animations: {
            lessonView.frame.size = finalFrame.size
            //                        lessonView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
            lessonView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            lessonView.layer.cornerRadius = self.presenting ? 5 : 10
            
            if !self.presenting {
                //                            lessonView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
//                lessonView.alpha = 0.0
            }
        }) { (_) in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        }
    }
}


class DragDownInteraction: UIPercentDrivenInteractiveTransition {
    
    
    private var viewController: UIViewController!
    
    init(for vc: UIViewController) {
        viewController = vc
        super.init()
        
        setupGesture(for: viewController.view)
    }
    
    private func setupGesture(for view: UIView){
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        
        (viewController as! OverviewDetailController).collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translate = gesture.translation(in: viewController.view)
        
        let percent = max(0.0, min(1.0, translate.y / 400.0))
        
        switch gesture.state {
        case .began:
            viewController.dismiss(animated: true, completion: nil)
        case .changed:
            print("fewio \(percent)")
            update(percent)
        case .ended, .cancelled:
            if percent > 0.5 {
                finish()
            }else {
                cancel()
            }
        default:
            print("DragDownInteraction.handlePanGesture(_:) Default case. GestureRecognizer state: \(gesture.state)")
        }
        
    }

   
}


class DragAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.4
    var presenting = true
    var originFrame = CGRect.zero
    
    var interationController: UIPercentDrivenInteractiveTransition?
    
    var dismissCompletion: (()->Void)?
    
    init(interaction: UIPercentDrivenInteractiveTransition) {
        interationController = interaction
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        let containerView = transitionContext.containerView
//        if self.type == .navigation {
//            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
//        }
        
        let animations = {
            fromViewController.view.frame = containerView.bounds.offsetBy(dx: 0, dy: containerView.frame.size.height)
            toViewController.view.frame = containerView.bounds
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       delay: 0,
                       options: [.curveEaseOut],
                       animations: animations) { _ in
                        
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let containerView = transitionContext.containerView
//        let toView = transitionContext.view(forKey: .to)!
//        let lessonView = presenting ? toView : transitionContext.view(forKey: .from)!
//
//        let initialFrame = presenting ? originFrame : lessonView.frame
//        let finalFrame = presenting ? lessonView.frame : originFrame
//
//        //        let xScaleFactor = presenting ?
//        //            initialFrame.width / finalFrame.width :
//        //            finalFrame.width / initialFrame.width
//        //
//        //        let yScaleFactor = presenting ?
//        //            initialFrame.height / finalFrame.height :
//        //            finalFrame.height / initialFrame.height
//        //
//        //        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
//
//        let newFrame = presenting ? initialFrame.size : finalFrame.size
//
//        if presenting {
//            //            lessonView.transform = scaleTransform
//
//            lessonView.frame.size = newFrame
//            lessonView.center = CGPoint(
//                x: initialFrame.midX,
//                y: initialFrame.midY)
//            lessonView.clipsToBounds = true
//        }else {
//            transitionContext.view(forKey: .from)?.backgroundColor = .clear
//        }
//
//        containerView.addSubview(toView)
//        containerView.bringSubview(toFront: lessonView)
//
//        //        lessonView.layer.cornerRadius = 5
//
//
//        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, animations: {
//            lessonView.frame.size = finalFrame.size
//            //                        lessonView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
//            lessonView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
//            lessonView.layer.cornerRadius = self.presenting ? 5 : 10
//
//            if !self.presenting {
//                //                            lessonView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
//                //                lessonView.alpha = 0.0
//            }
//        }) { (_) in
//            if !self.presenting {
//                self.dismissCompletion?()
//            }
//            transitionContext.completeTransition(true)
//        }
//    }
}



