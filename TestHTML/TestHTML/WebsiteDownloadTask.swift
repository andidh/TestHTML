//
//  WebsiteDownloadTask.swift
//  TestHTML
//
//  Created by Dehelean Andrei on 4/23/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation

var websitesCache: [WebsiteDownloadTask] = []

class WebsiteDownloadTask {
    
    let sessionId: String
    let taskId: Int
    let filePath: URL
    
    init(sessionId: String, taskId: Int, filePath: URL) {
        self.sessionId = sessionId
        self.taskId = taskId
        self.filePath = filePath
    }
    
    func save() {
        websitesCache.append(self)
    }
}

func fetchWebsiteTask(sessionId: String, taskId: Int) -> WebsiteDownloadTask? {
    var found: WebsiteDownloadTask?
    websitesCache.forEach() { task in
        if (task.sessionId == sessionId && task.taskId == taskId) {
            found = task
        }
    }
    
    return found
}

