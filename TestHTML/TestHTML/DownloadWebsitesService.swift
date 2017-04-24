//
//  DownloadWebsitesService.swift
//  TestHTML
//
//  Created by Dehelean Andrei on 4/23/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import UIKit

fileprivate let sessionIdentifier = Bundle.main.bundleIdentifier! + "-background"

struct DownloadWebsitesService {
    
    var websites: [Website]?
    
    var backgroundSession: URLSession {
        let config = URLSessionConfiguration.background(withIdentifier: sessionIdentifier)
        config.httpMaximumConnectionsPerHost = 3
        return URLSession(configuration: config, delegate: NetworkManager.shared, delegateQueue: nil)
    }
    
    
    func start() {
        for website in websites! {
            let guid = website.guid
            let filePath = FileHandler.downloadsFolder(fileName: guid).path
            let task = self.backgroundSession.downloadTask(with: website.url)
            let websiteTask = WebsiteDownloadTask(sessionId: self.backgroundSession.configuration.identifier!, taskId: task.taskIdentifier, filePath: filePath)
            
            websiteTask.save()
            task.resume()
        }
        
//        self.backgroundSession.finishTasksAndInvalidate()
    }
}
