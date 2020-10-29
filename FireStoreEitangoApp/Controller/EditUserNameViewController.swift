//
//  EditUserNameViewController.swift
//  FireStoreEitangoApp
//
//  Created by 下川勇輝 on 2020/10/29.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields
import Firebase
import FirebaseFirestore

class EditUserNameViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var renewBtn: UIButton!
    @IBOutlet weak var textFieldFloatingUserName: MDCTextField!
    var textControllerUserName: MDCTextInputControllerOutlined!
    var refString = String()
    
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldFloatingUserName.delegate = self

        textFieldFloatingUserName.placeholder = "新しいユーザー名を入れてください"
        self.textControllerUserName = MDCTextInputControllerOutlined(textInput: textFieldFloatingUserName)
        
        renewBtn.layer.cornerRadius = 10
        
        
        if UserDefaults.standard.object(forKey: "refString") != nil{
            refString = UserDefaults.standard.object(forKey: "refString") as! String
        }
        
        
        
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func renewUserInformation(_ sender: Any) {
      

    
        
        
        //テキストが空でないなら、入れる
        if let newUserName = textFieldFloatingUserName.text,!newUserName.isEmpty{
            db.collection("Profile").document(refString).updateData(["userName" : textFieldFloatingUserName.text!]) { (error) in
                print(error.debugDescription)
                return
            }
            
            
            //アラート
            let alertController = MDCAlertController(title: "成功", message: "ユーザー名を更新しました")
            let action = MDCAlertAction(title:"OK"){(alert) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(action)
            self.present(alertController, animated:true)
            
        }else{
            //警告アラート
            let alertController2 = MDCAlertController(title: "変更失敗", message: "新しいユーザー名を入力してください")
            let action2 = MDCAlertAction(title:"OK"){(alert) in
                return
            }
            alertController2.addAction(action2)
            self.present(alertController2, animated:true)
            
        }
        
    }
    
    //リターンでキーボ閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldFloatingUserName.resignFirstResponder()
        return true
    }
    
}
