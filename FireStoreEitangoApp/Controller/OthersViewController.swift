//
//  OthersViewController.swift
//  FireStoreEitangoApp
//
//  Created by 下川勇輝 on 2020/10/09.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields
import Firebase



class OthersViewController: UIViewController {
    
    var textController: MDCTextInputControllerOutlined!

    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textFieldFloating = MDCTextField(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 50))
        textFieldFloating.placeholder = "Usename"
        textFieldFloating.center = self.view.center
        
        self.view.addSubview(textFieldFloating)
        
        
        self.textController = MDCTextInputControllerOutlined(textInput: textFieldFloating)
        self.textController.textInsets(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        // MDCTextInputControllerOutlined
        
        
        
        
        //materia design風の影の付け方の基本
        loginButton.layer.cornerRadius = 10.0
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowRadius = 1
        loginButton.layer.shadowOpacity = 0.5
        loginButton.layer.shadowOffset = CGSize(width: 1, height: 1)

        
    }
    
    @IBAction func logout(_ sender: Any) {
          let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
          print("ログアウトしました")
        } catch let signOutError as NSError {
          print ("error", signOutError)
        }
    }
    
    
    
}
