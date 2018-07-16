//
//  TestView.swift
//  Timetable
//
//  Created by Jonah Schueller on 08.06.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

extension CGRect {
    
    func scale(facor f: CGFloat) -> CGRect {
        return CGRect(x: minX * f, y: minY * f, width: width * f, height: height * f)
    }
    
}

class TestView: UIView {
    
    var views = [UIView]()
    

    init() {
        super.init(frame: .zero)
        
        for day in 0...6 {
            
            let view = UIView()
            view.backgroundColor = .red
            
            view.frame = frame.scale(facor: 0.6)
            
            
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
