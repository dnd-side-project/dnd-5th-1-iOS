//
//  InstarWebViewController.swift
//  Picme
//
//  Created by taeuk on 2021/09/05.
//

import UIKit
import WebKit

class InstarWebViewController: BaseViewContoller, WKUIDelegate {

    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        
        guard let picmeInstarUrl = URL(string: "https://www.instagram.com/pic_me_official/") else { return }
        let urlRequest = URLRequest(url: picmeInstarUrl)
        webView.load(urlRequest)
    }

}
