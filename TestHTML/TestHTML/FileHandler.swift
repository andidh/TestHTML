//
//  FileHandler.swift
//  TestHTML
//
//  Created by Dehelean Andrei on 4/22/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation

extension FileManager {
    func listFiles(at directory: URL) -> [URL] {
        let baseurl: URL = directory
        var urls = [URL]()
        enumerator(atPath: directory.path)?.forEach({ (e) in
            guard let s = e as? String else { return }
            let relativeURL = URL(fileURLWithPath: s, relativeTo: baseurl)
            let url = relativeURL.absoluteURL
            urls.append(url)
        })
        return urls
    }
}

enum FileHandler {
    
    case downloadsFolder(fileName: String?)
    case websitesFolder(fileName: String?)
    
    var path: URL {
        let fm = FileManager.default
        
        
        switch self {
        case .downloadsFolder(let fileName):
            let downloadsFolder = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Downloads")
            
            if (!fm.fileExists(atPath: downloadsFolder.absoluteString)) {
                do {
                    try FileManager.default.createDirectory(at: downloadsFolder, withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    print(error)
                }
            }
            
            guard let fileName = fileName else { return downloadsFolder }
            
            let filePath = downloadsFolder.appendingPathComponent(fileName).appendingPathExtension("zip")
            
            if (!fm.fileExists(atPath: filePath.absoluteString)) {
                FileManager.default.createFile(atPath: filePath.absoluteString, contents: nil, attributes: nil)
            }
            
            return filePath
            

        case .websitesFolder(let fileName):
            
            let unzippedFolder = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Websites")
            
            if (!fm.fileExists(atPath: unzippedFolder.absoluteString)) {
                do {
                    try FileManager.default.createDirectory(at: unzippedFolder, withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    print(error)
                }
            }
            
            guard let fileName = fileName else { return unzippedFolder }
            
            let filePath = unzippedFolder.appendingPathComponent(fileName)
            
            if (!fm.fileExists(atPath: filePath.absoluteString)) {
                do {
                    try FileManager.default.createDirectory(at: filePath, withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    print(error)
                }
            }
            
            return filePath
        }
        
    }
    
}
