//
//  WZSwiftViewController.swift
//  WZBridge_Example
//
//  Created by 吴哲 on 2018/12/12.
//  Copyright © 2018 arcangelw. All rights reserved.
//

import UIKit

class WZSwiftViewController: UIViewController {
    let webView = WWKWebView()
    let ocTest = WZObjCApiTest()
    let swiftTest = WZSwiftApiTest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.frame = view.bounds
        webView.setDebugMode(true)
        view.addSubview(webView)
        webView.addJavascriptObject(ocTest, namespace: "toObjC")
        webView.addJavascriptObject(swiftTest, namespace: "toSwift")
        
        webView.addObserver(forType: WWObserverTypeTitle) { (value) in
            guard let title = value as? String else {
                return
            }
            print("block title is : \(title)")
        }
        webView.addObserver(forType: WWObserverTypeTitle, target: self, selector: #selector(WZSwiftViewController.addTitle(_:)))
        
        webView.addObserver(forType: WWObserverTypeProgress) { (value) in
            guard let progress = value as? Double else {
                return
            }
            print("block progress is : \(progress)")
        }
        webView.addObserver(forType: WWObserverTypeProgress, target: self
            , selector: #selector(WZSwiftViewController.addProgress(_:)))
        
        
        let path = Bundle.main.bundlePath
        let baseURL = NSURL.fileURL(withPath: path)
        if let htmlPath = Bundle.main.path(forResource: "test", ofType: "html"), let htmlString = try? String.init(contentsOfFile: htmlPath) {
            webView.loadHTMLString(htmlString, baseURL: baseURL)
        }
        
    }
    
    @objc private func addTitle(_ title:String){
        print("target title is : \(title)")
    }
    @objc private func addProgress(_ value:Double){
        print("target progress is : \(value)")
    }

}
