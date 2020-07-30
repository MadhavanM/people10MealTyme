//
//  SecondViewController.swift
//  mealTime
//
//  Created by Madhavan on 29/07/20.
//  Copyright © 2020 myApp. All rights reserved.
//

import UIKit
import WebKit
class SecondViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.bottlerocketstudios.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
