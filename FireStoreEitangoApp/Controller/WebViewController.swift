//
//  WebViewController.swift
//  FireStoreEitangoApp
//
//  Created by 下川勇輝 on 2020/10/27.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    var webView = WKWebView()
    var urlString = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 50)
        view.addSubview(webView)
        
//        if UserDefaults.standard.object(forKey: "url") != nil{
//            urlString = UserDefaults.standard.object(forKey: "url") as! String
//            print("ここに\(urlString)")
//        }
        
//        let url = URL(string: urlString)
        
        let urlString = UserDefaults.standard.object(forKey: "url")
        
        let url = URL(string: urlString! as! String)
//        let url = URL(string: "https://www.yahoo.co.jp/")
        let request = URLRequest(url: url!)
        webView.load(request)
        
        
    }
    

}
