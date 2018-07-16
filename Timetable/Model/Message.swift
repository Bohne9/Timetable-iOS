//
//  Message.swift
//  Timetable
//
//  Created by Jonah Schueller on 07.05.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import FirebaseFirestore

class Message {
    
    /*
     Firebase fields:
        - Message Content ("content")
        - Owner ID ("user")
        - timestamp ("timestamp")
     
        - (Chat path, Message path, user Name can be extracted in other ways)
    */
    
    /// Firebase Path ID of the chat
    var chatID = ""
    
    /// Content of the message
    var message = "loading..."
    
    /// Firebase ID of the user
    var userID = ""
    
    /// Name of the user
    var userName = ""
    
    /// Firebase ID of the Message Document
    var messageId = ""
    
    /// Timestamp when the message was written
    var timestamp: Timestamp!
    
    init() {
        
    }
    
}

