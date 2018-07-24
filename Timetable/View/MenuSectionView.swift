//
//  MenuSectionView.swift
//  Timetable
//
//  Created by Jonah Schueller on 24.06.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class MenuSectionView: UIView, UIGestureRecognizerDelegate{
    
    let title = UILabel()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    init() {
        super.init(frame: .zero)
        
        constraintUserInterface()
        
        collectionView.panGestureRecognizer.accessibilityLabel = "SectionView"
        
    }
    
    func setTitle(_ str: String) {
        title.text = str
//        title.attributedText = NSAttributedString(string: str, attributes: [.underlineStyle : NSUnderlineStyle.styleSingle.rawValue])
    }
    
    func setTitle(translate: String) {
        setTitle(Language.translate(translate))
    }
    
    func reload(){
        collectionView.reloadData()
    }
    
    
    private func constraintUserInterface(){
        addSubview(title)
        addSubview(collectionView)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        title.font = UIFont.robotoBold(20)
        title.textColor = .appWhite
        
        title.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        title.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        collectionView.backgroundColor = .clear
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
        
        collectionView.layer.masksToBounds = false
    }
    
    
    func set(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}






