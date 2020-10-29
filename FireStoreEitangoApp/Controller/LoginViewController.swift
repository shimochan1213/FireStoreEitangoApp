//
//  LogiinAndRegisterViewController.swift
//  FireStoreEitangoApp
//
//  Created by 下川勇輝 on 2020/10/11.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields
import MaterialComponents.MaterialDialogs
import Firebase

class LoginViewController: UIViewController,UITextFieldDelegate {
    

    @IBOutlet weak var textFieldFloatingEmail: MDCTextField!
    @IBOutlet weak var textFieldFloatingPW: MDCTextField!
    
    var textControllerEmail: MDCTextInputControllerOutlined!
    var textControllerPW: MDCTextInputControllerOutlined!
   
    
    @IBOutlet weak var loginBtn: MDCRaisedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldFloatingEmail.delegate = self
        textFieldFloatingPW.delegate = self
        
        loginBtn.layer.cornerRadius = 5
        
        textFieldFloatingEmail.placeholder = "メールアドレス"
        self.textControllerEmail = MDCTextInputControllerOutlined(textInput: textFieldFloatingEmail)
        self.textControllerEmail.textInsets(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        
        textFieldFloatingPW.placeholder = "パスワード"
        self.textControllerPW = MDCTextInputControllerOutlined(textInput: textFieldFloatingPW)
        
       
        
    }
    
    
    @IBAction func login(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: textFieldFloatingEmail.text!, password: textFieldFloatingPW.text!) { (user, error) in
            if error != nil{
                print(error)
                
                let alertController = MDCAlertController(title: "ログイン失敗", message: "メールアドレスかパスワードが違います")
                let action = MDCAlertAction(title:"OK")
                alertController.addAction(action)
                self.present(alertController, animated:true)
                
                
            }else{
                
                print("ログイン成功しただよ")
                
//                //自動ログインのため
//                UserDefaults.standard.set(self.textFieldFloatingEmail.text!, forKey: "email")
//                UserDefaults.standard.set(self.textFieldFloatingPW.text!, forKey: "PW")
                
                //アラート
                let alertController = MDCAlertController(title: "ログイン成功", message: "さあ、はじめましょう！")
                let action = MDCAlertAction(title:"OK"){(alert) in
//                    self.navigationController?.dismiss(animated: true, completion: nil)

                    self.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(action)
                self.present(alertController, animated:true)
                
            }
        }
    }
    
    
    
//    @IBAction func back(_ sender: Any) {
//        self.navigationController?.dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //タッチでキーボ閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textFieldFloatingEmail.resignFirstResponder()
        textFieldFloatingPW.resignFirstResponder()
    }
    
    //リターンでキーボ閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldFloatingEmail.resignFirstResponder()
        textFieldFloatingPW.resignFirstResponder()
        return true
    }
    
    
}
