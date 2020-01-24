//
//  ViewController.swift
//  AsyncApiCall
//
//  Created by Vivek Gajbe on 1/24/20.
//  Copyright © 2020 Intelegain. All rights reserved.
//

import UIKit

class ViewController: UIViewController,URLSessionDelegate,URLSessionDataDelegate {

    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var lblDownloadText: UILabel!
    
    var buffer:NSMutableData = NSMutableData()
    var session:URLSession?
    var dataTask:URLSessionDataTask?
    var expectedContentLength = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - button delegate method
    @IBAction func downloadClicked(_ sender: UIButton) {
        let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!
        fetchFile(url: url)
    }
    @IBAction func UploadClicked(_ sender: Any) {
        
    }
    //MARK: - custom method
    func fetchFile(url: URL) {
        progress.progress = 0.0
        let configuration = URLSessionConfiguration.default
        let mainQueue = OperationQueue.main
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: mainQueue)
        dataTask = session?.dataTask(with: URLRequest(url: url))
        dataTask?.resume()
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        buffer.append(data)
        let percentageDownloaded = Float(buffer.length) / Float(expectedContentLength)
        progress.progress =  percentageDownloaded
        lblDownloadText.text = String(format: "%.2f", progress.progress)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void) {
        expectedContentLength = Int(response.expectedContentLength)
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        progress.progress = 1.0
    }
}

