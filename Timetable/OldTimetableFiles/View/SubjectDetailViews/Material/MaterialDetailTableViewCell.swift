//
//  MaterialDetailTableViewCell.swift
//  Timetable
//
//  Created by Jonah Schueller on 22.07.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit
import PDFKit

class MaterialDetailTableViewCell: UITableViewCell {

    var pdf = PDFView()
    
    
    var materialLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoBold(15)
        label.textColor = .appWhite
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoMedium(13)
        label.textAlignment = .right
        label.numberOfLines = 0
        label.textColor = UIColor.appWhite.withAlphaComponent(0.75)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoMedium(13)
        label.numberOfLines = 0
        label.textColor = UIColor.appWhite.withAlphaComponent(0.75)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    var nextImg: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "next").withRenderingMode(.alwaysTemplate)
        img.tintColor = .gray
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(materialLabel)
        addSubview(dateLabel)
        addSubview(infoLabel)
        addSubview(nextImg)
        
        nextImg.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nextImg.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nextImg.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        nextImg.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        materialLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -2).isActive = true
        materialLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        materialLabel.trailingAnchor.constraint(equalTo: nextImg.leadingAnchor, constant: -4).isActive = true
        materialLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: nextImg.leadingAnchor, constant: -4).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45).isActive = true
        
        infoLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -2).isActive = true
        infoLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45).isActive = true
        
        backgroundColor = .background
        
    }
    
    
    func setValues(material: Material, type: MaterialTimeInterval) {
        materialLabel.text = material.dataName
        
        if type == .today {
            dateLabel.text = material.timestamp.dateValue().format(with: "hh:mm")
        }else {
            dateLabel.text = material.timestamp.dateValue().format(with: "dd.MM.yy")
        }
        infoLabel.text = "by user XY"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class MaterialDetailTableViewCellHeader: UITableViewHeaderFooterView {
    
    var titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .background
        
        titleLabel.addAndConstraint(to: self)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .appWhite
        titleLabel.font = UIFont.robotoBold(20)
        
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
