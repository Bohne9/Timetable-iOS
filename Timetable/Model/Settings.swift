//
//  Settings.swift
//  Timetable
//
//  Created by Jonah Schueller on 22.07.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import Foundation

class Settings {
    
    static var shared: Settings = Settings()
    
    // Initial maxDownloadSize of 50MB
    /// Maximum download size for materials
    var maxDownloadSize: Int64 = 1024 * 1024 * 50
    
    
    /// Decide wheather downloaded material should always be stored on the device
    var alwaysStoreMaterialToLocalStorage = false
    
    
    /// Decide wheather material should be automatically downloaded without any user interaction
    var autoDownloadMaterials = true

    
}




