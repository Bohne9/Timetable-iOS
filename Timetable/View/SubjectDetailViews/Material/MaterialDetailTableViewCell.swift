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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
