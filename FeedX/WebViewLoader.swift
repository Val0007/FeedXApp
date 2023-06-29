//
//  WebViewLoader.swift
//  FeedX
//
//  Created by Val V on 26/06/23.
//

import Foundation
import UIKit
import WebKit

class WebViewPreloader:NSObject{
    var urlStrings:[String] = []
    var urllinks:[String:Bool] = [:]
    
    var webviews = [URL: WKWebView]()
    
    func isCached(url:String)->Bool{
        return urllinks[url] ?? false
    }
    
    /// - Parameter url: the URL to preload
    
    func returnWebView(url:String) -> WKWebView?{
        if let url = URL(string: url){
            return webviews[url] ?? nil
        }
        return nil
    }
    
    
    func getwebview(for url: URL) -> WKWebView {
        if let cachedWebView = webviews[url] { return cachedWebView }
        let webview = WKWebView(frame: .zero)
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
        guard let topController = keyWindow?.rootViewController else {return webview}
        DispatchQueue.main.async {
            topController.view.addSubview(webview)
        }
        webview.load(URLRequest(url: url))
        print("Loading")
        webview.navigationDelegate = self
//        observation = webview.observe(\.estimatedProgress, options: [.new]) { _, _ in
//                self.progressView.progress = Float(self.webView.estimatedProgress)
//            }
        return webview
    }
    
    func fetchUrls(){
        for stringLink in urlStrings{
            if let url = URL(string: stringLink){
                print(url)
                let _ = getwebview(for: url)
            }
        }
    }
    
    
}


extension WebViewPreloader:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Determine which web view finished loading based on the webView parameter
        if let url = webView.url {
            let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
            guard let topController = keyWindow?.rootViewController else {return}
            for v in topController.view.subviews{
                if v == webView{
                    DispatchQueue.main.async {
                        v.removeFromSuperview()
                    }
                }
            }
            if urlStrings.contains(url.absoluteString){
                urllinks[url.absoluteString] = true
                webviews[url] = webView
                print("Fetching and PRELOADING DONEEEE for \(url)")
                print(urllinks)
                print(urlStrings.count)
                print(urllinks.keys.count)

            }
        }
    }
}
