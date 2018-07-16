//
//  LessonControl.swift
//  Timetable
//
//  Created by Jonah Schueller on 15.03.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit


class LessonControl: UIStackView {
    
    let today, add: UIButton
    
    init() {
        today = UIButton(type: .system)
        add = UIButton(type: .system)
        
        super.init(frame: .zero)
        
        backgroundColor = .background
        
        today.setTitle(Language.shared.getTranslation("LessonControl_Today"), for: .normal)
        add.setTitle(Language.shared.getTranslation("LessonControl_AddLesson"), for: .normal)
        
        today.backgroundColor = .background
        add.backgroundColor = .background
        
        today.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        add.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        
        today.setTitleColor(.contrast, for: .normal)
        add.setTitleColor(.contrast, for: .normal)
        
        distribution = .fillEqually
        axis = .horizontal
        
        addArrangedSubview(today)
        addArrangedSubview(add)
        
        
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
