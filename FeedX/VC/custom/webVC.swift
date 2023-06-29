//
//  webVC.swift
//  FeedX
//
//  Created by Val V on 26/03/23.
//


import UIKit
import WebKit

protocol webVCdelegate{
    func getNextArticle()->feedItem?
    func changeSelectedIndex()
}

class WebViewController: UIViewController {
    
    var webView: WKWebView?
    let urlS:String
    var delegate:webVCdelegate?
    var nextItem:feedItem?
    
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
        // Add a close button to the navigation bar
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.rightBarButtonItem = closeButton

        

        webView = WKWebView(frame: view.bounds)
        webView?.navigationDelegate = self
        guard let webView = webView else {
            return
        }
        view.addSubview(webView)
        // Load a website
        let url = URL(string: urlS)!
        let request = URLRequest(url: url)
        webView.load(request)
        

        let swipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(backNavigationFunction(_:)))
                swipeGesture.edges = .right
                swipeGesture.delegate = self

        webView.addGestureRecognizer(swipeGesture)
       
        getNextItem()
    }
    
    func getNextItem(){
        nextItem = delegate?.getNextArticle()
        if let nextItem = nextItem {
            title = "Up Next:\(nextItem.feedItemTitle)"
        }
        else{
            title = ""
        }
    }
    
    @objc func closeTapped() {
        // Dismiss the view controller when the close button is tapped
        navigationController?.popViewController(animated: true)
    }
}

extension WebViewController: WKNavigationDelegate,UIGestureRecognizerDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        // Handle errors
        print(error.localizedDescription)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return true
    }
    
    @objc func backNavigationFunction(_ sender: UIScreenEdgePanGestureRecognizer)
    {
        let dX = sender.translation(in: view).x
        if sender.state == .ended
        {
            let fraction = abs(dX / view.bounds.width)
            if fraction >= 0.40
            {
                print("NEXT ARTICLE")
                if let next = nextItem{
                    if let url = URL(string: next.feedItemLink){
                        webView?.load(URLRequest(url: url))
                        delegate?.changeSelectedIndex()
                    }
                }
            }
        }
        
        getNextItem()
    }
}


