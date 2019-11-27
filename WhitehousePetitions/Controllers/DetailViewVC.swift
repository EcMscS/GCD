//
//  DetailViewVC.swift
//  WhitehousePetitions
//
//  Created by Jeffrey Lai on 11/6/19.
//  Copyright © 2019 Jeffrey Lai. All rights reserved.
//

import UIKit
import WebKit

class DetailViewVC: UIViewController {

    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        createHTML()
    }
    
    func setupNavBar() {
        title = detailItem?.title

    }
    
    func createHTML() {
        guard let detailItem = detailItem else { return }
        
        let html = """
            <html>
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <style> body { font-size: 150%; text-align: center }</style>
                </head>
                <body>
                    \(detailItem.body)
                </body>
            </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    deinit {
        webView = WKWebView()
    }

}
