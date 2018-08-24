//
//  Material.swift
//  Timetable
//
//  Created by Jonah Schueller on 17.07.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit
import Firebase

class Material: LocalData{
    var map: [String : String] {
        get{
            return [
                "userID" : Database.userID,
                "timestamp" : timestamp != nil ? "\(timestamp.seconds)" : "\(Timestamp(date: Date()).seconds)",
                "storagePath" : url.path
            ]
        }
        set{
            fatalError("Material.map set is not implemented yet! Implement it to remove this error.")
        }
    }
    

    var data: Data?
    var suffix: String
    var dataName: String
    var url: URL
    var userID: String
    var materialID: String
    var timestamp: Timestamp!
    var isLocal: Bool = true
    var temporaryLoacalURL: URL?
    
    var target: String?
    
    private init(url: URL, data: Data, materialID: String, userID: String) {
        self.url = url
        suffix = url.pathExtension
        dataName = url.lastPathComponent
        self.userID = userID
        self.data = data
        self.materialID = materialID
    }
    
    convenience init(firebasePath: URL, data: Data, materialID: String, userID: String = Database.userID) {
        self.init(url: firebasePath, data: data, materialID: materialID, userID: userID)
        isLocal = false
    }
    
    convenience init(localPath: String, data: Data, materialID: String, userID: String = Database.userID) {
        self.init(url: URL(fileURLWithPath: localPath), data: data, materialID: materialID, userID: userID)
        isLocal = true
    }
    
    private init(url: URL, materialID: String, userID: String) {
        self.url = url
        suffix = url.pathExtension
        dataName = url.lastPathComponent
        self.userID = userID
        self.materialID = materialID
    }
    
    convenience init(firebasePath: URL, materialID: String, userID: String = Database.userID) {
        self.init(url: firebasePath, materialID: materialID, userID: userID)
        isLocal = false
    }
    
    convenience init(localPath: String, materialID: String, userID: String = Database.userID) {
        self.init(url: URL(fileURLWithPath: localPath), materialID: materialID, userID: userID)
        isLocal = true
    }
    
}

