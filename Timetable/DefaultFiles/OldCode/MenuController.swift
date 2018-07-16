//
//  MenuController.swift
//  Timetable
//
//  Created by Jonah Schueller on 16.04.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit


//class MenuController: UIViewController {
//
//    private var window: UIWindow?
//    
//    
////    let menu = MenuView()
//    
//    func constraint() {
////        view.isUserInteractionEnabled = true
////        view.isExclusiveTouch = false
////        menu.isUserInteractionEnabled = true
////
////        menu.backgroundColor = .contrast
////        menu.translatesAutoresizingMaskIntoConstraints = false
////        view.addSubview(menu)
////
////        menu.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
////        menu.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
////        menu.widthAnchor.constraint(equalToConstant: 250).isActive = true
////        menu.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
////
////        view.layoutIfNeeded()
////
//    
//        
//    }
//    
//    @objc func handleEdgePan(_ sender: UIScreenEdgePanGestureRecognizer) {
//        
//        
//        print("Edge detected")
//        
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            menu.fadeOut()
//        }
//    }
//    
//    func loadAndFadeIn() {
//        
//        if let window = self.window {
//            window.isHidden = false
//            menu.frame.origin.x = -view.frame.width
////            menu.layer.shadowRadius = 15
//            menu.fadeIn()
//        }else {
//            window = UIWindow(frame: UIScreen.main.bounds)
//            window?.windowLevel = UIWindowLevelStatusBar
//            window?.rootViewController = self
//            window?.makeKeyAndVisible()
//            window?.isHidden = true
//        }
//        
//    }
//
//    func load(){
//        if let window = self.window {
//            window.isHidden = false
//            menu.frame.origin.x = -view.frame.width
//            
//        }else {
//            window = UIWindow(frame: UIScreen.main.bounds)
//            window?.windowLevel = UIWindowLevelStatusBar
//            window?.rootViewController = self
//            window?.makeKeyAndVisible()
//            window?.isHidden = true
//        }
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//}
