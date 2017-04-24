//
//  ViewController.swift
//  TestHTML
//
//  Created by Dehelean Andrei on 4/20/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit
import Alamofire
import SSZipArchive
import WebKit


struct Website {
    let guid: String
    let url: URL
}


class ViewController: UIViewController {

    var webView: WKWebView!
    var downloadService: DownloadWebsitesService?
    
    var count = 0
    
    let websites: [Website] = {
        let first = Website(guid: firstGuid, url: URL(string: "https://ontdev.sharepoint.com/Customers/_layouts/15/guestaccess.aspx?docid=0db424e0d3786461ba1edce23a84f4d16&authkey=ATSIKv6pkNomPOInG_qQWH4")!)
        let second = Website(guid: secondGuid, url: URL(string:  "https://ontdev.sharepoint.com/Customers/_layouts/15/guestaccess.aspx?docid=076aee993ab314553bc8e182c973d7c29&authkey=AZwJcctWUFYMahzz6ObtXXM")!)
        
        return [first, second]
    }()

    override func loadView() {
        webView = WKWebView()
        
        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        webView.configuration.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        webView.allowsBackForwardNavigationGestures = true
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadService = DownloadWebsitesService()
        downloadService?.websites = websites
    
        NotificationCenter.default.addObserver(self, selector: #selector(updateCount), name: NSNotification.Name(rawValue: "unzipDone"), object: nil)
    }
    
    @objc func updateCount() {
        count += 1
        
        let button = navigationItem.leftBarButtonItem
        button?.title = "\(count)"
    }
    
    
    @IBAction func unzip(_ sender: UIBarButtonItem) {
    
    }

    @IBAction func download(_ sender: UIBarButtonItem) {
        downloadService?.start()
    }
    
    
    func parseFolder(at directory: URL) {
        let urls = FileManager.default.listFiles(at: directory)
        
        urls.forEach() { url in
            if url.absoluteString.contains("index.html") {
                self.webView?.loadFileURL(url, allowingReadAccessTo: directory)
                return
            }
        }
    }
    
}


















//        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
//            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let folderURL = url.appendingPathComponent("Downloads")
////            do {
////                try FileManager.default.createDirectory(atPath: folderURL.absoluteString, withIntermediateDirectories: false, attributes: nil)
////            } catch let error as NSError {
////                print(error.localizedDescription);
////            }
////
//            let fileurl = folderURL.appendingPathComponent("firstSite.zip")
//
//            return (fileurl, [.removePreviousFile, .createIntermediateDirectories])
//        }
//        let url = URL(string: "https://ontdev.sharepoint.com/Customers/_layouts/15/guestaccess.aspx?docid=0db424e0d3786461ba1edce23a84f4d16&authkey=ATSIKv6pkNomPOInG_qQWH4")
//        Alamofire.download(url!, to: destination)
//                .response { response in
//
//                    let zipPath = response.destinationURL
//                    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                    let unzippedFolder = documentsUrl.appendingPathComponent("Unzipped/FirstSite")
//                    try? FileManager.default.createDirectory(at: unzippedFolder, withIntermediateDirectories: true, attributes: nil)
//
//                    SSZipArchive.unzipFile(atPath: zipPath!.path, toDestination: unzippedFolder.path)
//
//                    self.parseFolder(at: unzippedFolder.path)
//
//
//        }

