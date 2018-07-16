//
//  DayIndicator.swift
//  Timetable
//
//  Created by Jonah Schueller on 13.05.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class DayIndicator: UIScrollView {

    private var labels = [(label: UILabel, day: Day)]()
    
    init() {
        super.init(frame: .zero)
        var anchor = leadingAnchor
        for day in 1...7 {
            let day = Day(rawValue: day)!
            let text = Language.translate("Day_\(day)")
            
            let label = UILabel()
            setupLabel(label, anchor)
            label.text = text
            anchor = label.centerXAnchor
            labels.append((label: label, day: day))
        }
        layer.masksToBounds = false
        scroll(0.0)
        contentSize = CGSize(width: 125 * 7, height: frame.height)
    }
    
    func toDay(_ day: Day) {
        let index = day.rawValue - 1
        scroll(CGFloat(index))
    }
    
    
    private var lastOffset: CGFloat = 0
    
    /// Adjustst day indicator
    ///
    /// - Parameter perc: Percentage of timetable view scroll. Between 0-6
    func scroll(_ perc: CGFloat) {
        
        // 1400 = total width of all 7 labels, 7 * 200
        let offset = perc * 125 * 7
        setContentOffset(CGPoint(x: offset, y: 0), animated: false)
        
        for label in labels {
            let alpha = calcAlpha(forDay: label.day.rawValue - 1, offset: offset)
            label.label.alpha = alpha
        }
    }
    
    private func calcAlpha(forDay: Int, offset: CGFloat) -> CGFloat {
        
        let value = exp(-pow(((offset - 125.0 * CGFloat(forDay)) / 50.0), 2))
        
        return value
    }
    
    

    private func setupLabel(_ label: UILabel, _ anchor: NSLayoutXAxisAnchor) {
        
        label.font = UIFont.robotoRegular(45)
        label.textColor = UIColor.contrast
        label.textAlignment = .left
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: anchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 250).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
