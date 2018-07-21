//
//  Material.swift
//  Timetable
//
//  Created by Jonah Schueller on 17.07.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit


class Material {

    var rawData: Data
    var suffix: String
    var url: URL
    var userID: String?
    var materialID: String
    var isLocal: Bool = true
    
    private init(url: URL, data: Data, materialID: String) {
        
        self.url = url
        suffix = url.pathExtension
        rawData = data
        self.materialID = materialID
    }
    
    convenience init(firebase: URL, data: Data, materialID: String) {
        self.init(url: firebase, data: data, materialID: materialID)
        isLocal = false
    }
    
    convenience init(localPath: String, data: Data, materialID: String) {
        self.init(url: URL(fileURLWithPath: localPath), data: data, materialID: materialID)
        isLocal = true
    }
    
    
}

