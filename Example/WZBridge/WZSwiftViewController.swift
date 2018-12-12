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
        view.addSubview(webView)
        webView.addJavascriptObject(ocTest, namespace: "toObjC")
        webView.addJavascriptObject(swiftTest, namespace: "toSwift")
        let path = Bundle.main.bundlePath
        let baseURL = NSURL.fileURL(withPath: path)
        if let htmlPath = Bundle.main.path(forResource: "test", ofType: "html"), let htmlString = try? String.init(contentsOfFile: htmlPath) {
            webView.loadHTMLString(htmlString, baseURL: baseURL)
        }
    }

}
