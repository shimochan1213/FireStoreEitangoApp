//
//  WebViewController.swift
//  FireStoreEitangoApp
//
//  Created by 下川勇輝 on 2020/10/27.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import UIKit
import WebKit

class WebViewController:UINavigationController,WKUIDelegate,UINavigationControllerDelegate {
    
    var webView = WKWebView()
    var urlString = String()
    
    var closeBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.frame = CGRect(x: 0, y: navigationBar.bounds.height + 5, width: view.frame.size.width, height: view.frame.size.height - 50)
        view.addSubview(webView)
        
        self.setNavigationBar()
        
        
        //        if UserDefaults.standard.object(forKey: "url") != nil{
        //            urlString = UserDefaults.standard.object(forKey: "url") as! String
        //            print("ここに\(urlString)")
        //        }
        
        //        let url = URL(string: urlString)
        
        let urlString = UserDefaults.standard.object(forKey: "url")
        
        let url = URL(string: urlString! as! String)
        let request = URLRequest(url: url!)
        webView.load(request)
        
        
    }
    
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: navigationBar.bounds.height))
        let navItem = UINavigationItem(title: "ニュース")
        let closeItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: nil, action: #selector(close))
        navItem.rightBarButtonItem = closeItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    
}
