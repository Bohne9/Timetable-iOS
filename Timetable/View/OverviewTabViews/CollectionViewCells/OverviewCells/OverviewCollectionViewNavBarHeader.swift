//
//  OverviewCollectionViewNavBarHeader.swift
//  Timetable
//
//  Created by Jonah Schueller on 14.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class OverviewCollectionViewNavBarHeader: OverviewCollectionViewHeader {
    
    let plusButton: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setImage(#imageLiteral(resourceName: "Plus").withRenderingMode(.alwaysTemplate), for: .normal)
//        btn.tintColor = UIColor(hexString: "#6a89cc")
//        btn.tintColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(plusButton)
        
        plusButton.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        plusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        plusButton.contentEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10)
        plusButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
