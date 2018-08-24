//
//  TimetableLessonStack.swift
//  Timetable
//
//  Created by Jonah Schueller on 08.06.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class TimetableLessonStack: UIScrollView {

    private let stack = UIStackView()
    var day: Day
    var lessons = [TimetableLessonView]()
    
    init(day d: Day) {
        day = d
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        
        setupStackView()
    }
    
    private func setupStackView(){
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    func reload(){
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
