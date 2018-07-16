//
//  AbstractMenuView.swift
//  Timetable
//
//  Created by Jonah Schueller on 24.04.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class AbstractView: UIScrollView, UIScrollViewDelegate{

    static var defaultMenu: UIView!
    
    var content: UIView!
    var menu: AbstractMenu?
    private var offY: CGFloat = 0
    private var fadedOut = false
    
    var dragRelease = false
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .background
        
        
    }
    
    func addPanGesture(delegate: UIGestureRecognizerDelegate) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan(_:)))
        
        pan.delegate = delegate
        addGestureRecognizer(pan)
        
        self.delegate = self
        dragRelease = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Block top bouncing
        if contentOffset.y < 0 {
            contentOffset.y = 0
        }
    }

    @objc func pan(_ gesture: UIPanGestureRecognizer){
        
        if gesture.state == .changed {
            // Get the translation (how much the user moved on the y axis)
            let y = gesture.translation(in: self).y
            
            // To avoid that view will go out of bounds at the top
//            print(contentOffset)
            if (contentOffset.y > 0 || y < 0) && transform.ty < 1{
                gesture.setTranslation(.zero, in: self)
                return
            }
            
            contentOffset.y = 0
                // Adjust offset and menu offset
            offY = y < 20 ? 0 : y - 20
            
            let trans = CGAffineTransform(translationX: 0, y: offY)
            transform = trans
            menu?.transform = CGAffineTransform(translationX: 0, y: offY / 2)
            let al = min(max(cos(offY / 50), 0), 1)
            menu?.alpha = al
            AbstractView.defaultMenu.alpha = 1 - al
            
        // When user released touch
        }else if gesture.state == .ended {
            // If user dragged more than 70 pt down
            if offY > 70{
                // Fade out and remove view
                fadeOut()
                // Otherwise: User didnt dragged enough -> more back to top
            }else {
                
                offY = 0
                UIView.animate(withDuration: 0.2) {
                    self.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.menu?.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.menu?.alpha = 1.0
                    AbstractView.defaultMenu.alpha = 0.0
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    func fadeOut(){
        
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
            self.layoutIfNeeded()
        }) { (_) in
            self.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            self.offY = 0
            self.fadedOut = false
            AbstractView.defaultMenu.alpha = 1.0
//            ViewController.controller?.loadView(key: "default")
        }
        
    }
    
    func setContent(_ content: UIView) {
        addSubview(content)

        content.translatesAutoresizingMaskIntoConstraints = false
        self.content = content
        
        content.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        content.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        content.widthAnchor.constraint(equalTo: widthAnchor, constant: -40).isActive = true
        
        updateContentSize()
    }
    
    func updateContentSize(){
        content.layoutIfNeeded()
        contentSize = content.frame.size
    }
    
    func open(_ data: Any?){
        AbstractView.defaultMenu.alpha = 0
        menu?.alpha = 1.0
    }
    
    func close(){
        resetLayout()
        menu?.close()
    }
    
    func resetLayout(){
        offY = 0
        transform = CGAffineTransform(translationX: 0, y: 0)
        menu?.transform = CGAffineTransform(translationX: 0, y: 0)
        setContentOffset(.zero, animated: false)
        menu?.alpha = 1.0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
