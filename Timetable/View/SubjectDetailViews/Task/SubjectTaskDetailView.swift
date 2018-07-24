//
//  SubjectTaskDetailView.swift
//  Timetable
//
//  Created by Jonah Schueller on 03.07.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class SubjectTaskDetailView: MasterDetailView<Task> {
    
    let taskTextView = UITextView()
    
    let materialTitle = UILabel()
    let materialTableView = UITableView()
    
    let creatorLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
//        print("\(safeArea.owningView)")
//        if let view = safeArea.owningView {
//            view.addSubview(self)
//        }
        
        title = Language.translate("Task")
        dismissImage = #imageLiteral(resourceName: "back")
        materialTitle.text = "Materials"
        
        backgroundColor = .background
        
        addStackedView(taskTextView, horizontalBounds: 30, height: 150)
        setupUILabel(materialTitle, fontSize: 20)
        
        taskTextView.isEditable = false
        
        taskTextView.font = UIFont.robotoBold(16)
        taskTextView.textColor = .appWhite
        taskTextView.backgroundColor = .background
        taskTextView.isScrollEnabled = false
        
    }
    
    
    private func setupUILabel(_ label: UILabel, fontSize: CGFloat, height: CGFloat? = nil) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.robotoBold(fontSize)
        label.textColor = .appWhite
        
        addStackedView(label, height: height)
    }
    
    
    override func reload(_ data: Task) {
        super.reload(data)
        
        taskTextView.text = data.task
        layoutIfNeeded()
    }
    
    override func fadeInLayoutChanges() {
        super.fadeInLayoutChanges()
        transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    override func fadeOutLayoutChanges() {
        super.fadeOutLayoutChanges()
        transform = CGAffineTransform(translationX: frame.width, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
