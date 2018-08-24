//
//  AddBodyCollectionViewCell.swift
//  Timetable
//
//  Created by Jonah Schueller on 15.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

let AddBodyCollectionViewCellIdentifier = "AddBodyCollectionViewCell"
class AddBodyTableViewCell: UITableViewCell {
    
    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.gray.cgColor
        layer.cornerRadius = 5
        backgroundColor = .white
        
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupUserInterface(){
        addSubviews()
    }
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    internal func addSubviews(){
        
    }
    
    
}
