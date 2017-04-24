//
//  UnzippService.swift
//  TestHTML
//
//  Created by Dehelean Andrei on 4/23/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import SSZipArchive

struct UnzipService {
    
    let guid: String
    
    func run() {
        let zipLocation = FileHandler.downloadsFolder(fileName: guid).path
        let newLocation = FileHandler.websitesFolder(fileName: guid).path
        
        SSZipArchive.unzipFile(atPath: zipLocation.path, toDestination: newLocation.path)
        try? FileManager.default.removeItem(at: zipLocation)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unzipDone"), object: nil)
    }
}
