//
//  RegisiterViewController.swift
//  FireStoreEitangoApp
//
//  Created by 下川勇輝 on 2020/10/11.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import UIKit
import Firebase
import MaterialComponents.MaterialTextFields

class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var textFieldFloatingUserName: MDCTextField!
    
    @IBOutlet weak var textFieldFloatingPW: MDCTextField!
  
    @IBOutlet weak var registerBtn: MDCRaisedButton!
    
    var textControllerUserName: MDCTextInputControllerOutlined!
    var textControllerPW: MDCTextInputControllerOutlined!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldFloatingUserName.delegate = self
        textFieldFloatingPW.delegate = self
        
        
        
        registerBtn.layer.cornerRadius = 5
    
        textFieldFloatingUserName.placeholder = "メールアドレス"
        self.textControllerUserName = MDCTextInputControllerOutlined(textInput: textFieldFloatingUserName)
        
        textFieldFloatingPW.placeholder = "パスワード"
        self.textControllerPW = MDCTextInputControllerOutlined(textInput: textFieldFloatingPW)
        
        
        
        
    }
    
    //      //FIrebaseにユーザーを登録する
    @IBAction func registerNewUser(_ sender: Any) {
        //新規登録（Firebaseのドキュメントにあるやり方
        Auth.auth().createUser(withEmail:textFieldFloatingUserName.text! , password: textFieldFloatingPW.text!) { (user,  error) in
            if error != nil {
                print(error)
                let alertController = MDCAlertController(title: "登録失敗", message: "有効なメールアドレスであること、パスワードは6文字以上であることをご確認ください。")
                let action = MDCAlertAction(title:"OK")
                alertController.addAction(action)
                self.present(alertController, animated:true)
                
                
            }else{
                print("ユーザの作成が成功しただよ！")
                let alertController = MDCAlertController(title: "ユーザー登録が完了しました", message: "さあ、はじめましょう！")
                let action = MDCAlertAction(title:"OK"){(alert) in
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(action)
                self.present(alertController, animated:true)
                
                //ログイン済みであるという情報を保存。次からログインボタンでないように。
                
                
                
            }
        }
    }
    

    @IBAction func back(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
       }
       
       //タッチでキーボ閉じる
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           textFieldFloatingUserName.resignFirstResponder()
           textFieldFloatingPW.resignFirstResponder()
       }
       
       //リターンでキーボ閉じる
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textFieldFloatingUserName.resignFirstResponder()
           textFieldFloatingPW.resignFirstResponder()
           return true
       }

    
    
    

}
