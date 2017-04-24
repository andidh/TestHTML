//
//  NetworkManager.swift
//  TestHTML
//
//  Created by Dehelean Andrei on 4/21/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

let firstGuid = "firstSite_guid"
let secondGuid = "secondSite_guid"


typealias CompleteHandlerBlock = () -> ()

class NetworkManager: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    
    var handlerQueue: [String:CompleteHandlerBlock]!
    
    static let shared: NetworkManager = NetworkManager()
    
    private override init() {
        super.init()
        
        handlerQueue = [:]
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print(bytesWritten)
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print(error ?? "")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(error ?? "it worked")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let webTask = fetchWebsiteTask(sessionId: session.configuration.identifier!, taskId: downloadTask.taskIdentifier)
        
        let path = webTask?.filePath
        
        do {
            try FileManager.default.moveItem(at: location, to: path!)
        } catch let error as NSError {
            print(error)
        }
        
        let guid = webTask?.filePath.lastPathComponent.replacingOccurrences(of: ".zip", with: "")
        let unzipService = UnzipService(guid: guid!)
        unzipService.run()
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("background url it finished")
        if let identif = session.configuration.identifier {
            callCompletionHandlerForSession(identifier: identif)
        }
    }
    
    func addCompletionHandler(handler: @escaping CompleteHandlerBlock, identifier: String) {
        handlerQueue[identifier] = handler
    }
    
    func callCompletionHandlerForSession(identifier: String) {
        if let handler = handlerQueue[identifier] {
            handlerQueue.removeValue(forKey: identifier)
            DispatchQueue.main.async {
                handler()
            }
        }
    }
    
    
}
