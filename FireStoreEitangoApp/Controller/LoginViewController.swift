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
import FirebaseFirestore

extension Notification.Name {
    static let notification = Notification.Name("SettingsDone")
}

class LoginViewController: UIViewController,UITextFieldDelegate {
    

    @IBOutlet weak var textFieldFloatingEmail: MDCTextField!
    @IBOutlet weak var textFieldFloatingPW: MDCTextField!
    
    var textControllerEmail: MDCTextInputControllerOutlined!
    var textControllerPW: MDCTextInputControllerOutlined!
    @IBOutlet weak var loginBtn: MDCRaisedButton!
    
    let db = Firestore.firestore()
    var refString = String()
//    //このユーザー専用のfirestore参照先(ドキュメントID)
//    let profileRef = Firestore.firestore().collection("Profile").document()
    
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
    
    //ログイン画面が閉じるときに、元のviewへ「閉じるよ！」と伝える（プロフィールデータを更新のため）
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: .notification, object: nil)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        if UserDefaults.standard.object(forKey: "refString") != nil{
//
//            refString = UserDefaults.standard.object(forKey: "refString") as! String
//
//        }else{
//
//            refString = db.collection("Answers").document().path
//            print(refString)
//            UserDefaults.standard.setValue(refString, forKey: "refString")
//
//        }
//    }
    
    
    @IBAction func login(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: textFieldFloatingEmail.text!, password: textFieldFloatingPW.text!) { (user, error) in
            if error != nil{
                print(error)
                
                let alertController = MDCAlertController(title: "ログイン失敗", message: "メールアドレスかパスワードが違います")
                let action = MDCAlertAction(title:"OK")
                alertController.addAction(action)
                self.present(alertController, animated:true)
                
                
            }else{
                
                
//                //練習
//                //このユーザー専用のfirestore参照先(ドキュメントID)
//                let profileRef = Firestore.firestore().collection("Profile").document()
//                var refString = String()
//                refString = profileRef.documentID
//                UserDefaults.standard.setValue(refString, forKey: "refString")
//                print("ログイン成功しただよ")
                
                //FSからドキュメント全部とる。そのドキュメントの中で、現在のuidと一致するものを取ってくる。そしてそのdocの中のrefStringを取ってきてuserDefaultに保存。otherViewControllerに戻った時にきちんとプロフィールのデータがロードされる。
                self.db.collection("Profile").getDocuments { (snapShot, error) in
                    if error != nil{
                        print(error.debugDescription)
                    }
                    
                    //snapShotDocに、コレクション（Profile)の中にあるドキュメント全てが入っている
                    if let snapShotDoc = snapShot?.documents{
                        //snapShotDocの中身を一つ一つ見るためにdocへfor文で入れてる。
                        for doc in snapShotDoc{
                            //uidが一致したときだけ、そのドキュメントの中にあるrefStringを取ってきたい！(ユーザーとFireStore送信先を紐づけるため）
                            
                            //docの中にあるdataを定数に入れてる。
                            let data = doc.data()
                            
                            //空じゃないときだけ入れる
                            if let uid = data["uid"] as? String, let ref = data["refString"] as? String{
                                
                                if uid == Auth.auth().currentUser!.uid{
                                    //ドキュメントの中のデータ中のrefStringを取ってきて、変数に入れてる
                                    self.refString = ref
                                    
//                                    self.refString = ref
                                    print(self.refString)
                                    //このユーザーのFireStore送信先を取ってこれたので保存する
                                    UserDefaults.standard.setValue(self.refString, forKey: "refString")
                            }
                          }
                            
                        }
                        
                        
                        
                    }
                }
                
                
                
                
                
                
                //アラート
                let alertController = MDCAlertController(title: "ログイン成功", message: "さあ、はじめましょう！")
                let action = MDCAlertAction(title:"OK"){(alert) in
                    self.dismiss(animated: true, completion: nil)

                }
                
                alertController.addAction(action)
                self.present(alertController, animated:true)
                
            }
            
            //非同期処理(通信重たい時などのためにUIの処理だけ並行してやってしまう）
            DispatchQueue.main.async {
    
                self.textFieldFloatingEmail.resignFirstResponder()
                self.textFieldFloatingPW.resignFirstResponder()

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
