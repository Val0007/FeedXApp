//
//  webVC.swift
//  FeedX
//
//  Created by Val V on 26/03/23.
//


import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    let urlS:String
    
    init(u:String){
        self.urlS = u
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a WKWebView
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        // Add a close button to the navigation bar
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.rightBarButtonItem = closeButton
        
        // Load a website
        let url = URL(string: urlS)!
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc func closeTapped() {
        // Dismiss the view controller when the close button is tapped
        navigationController?.popViewController(animated: true)
    }
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        // Handle errors
        print(error.localizedDescription)
    }
}
