//
//  WebView.swift
//  FeedX
//
//  Created by Val V on 15/01/23.
//

import UIKit
import WebKit

class WebView: UIViewController,WKNavigationDelegate {

    var webView: WKWebView!
    let urlString:String
    
    init(s:String){
        urlString = s
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: urlString) else {return}
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    


}
