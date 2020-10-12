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

class RegisterViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var iconImageView: UIImageView!
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
        
        //ユーザー名とアイコンをfirebaseに送信
        
        
        
        
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
    
    
    
       //アラートを出す
        func showAlert(){
            
            let alertController = UIAlertController(title: "選択", message: "どちらの方法で画像を追加しますか", preferredStyle: .actionSheet)
            
//            let alertController = MDCAlertController(title: "選択", message: "どの方法で画像を追加しますか？")
            
            let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
                
                self.doCamera()
                
            }
            
            let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
                
                self.doAlubm()
                
            }
            
            let action3 = UIAlertAction(title: "キャンセル", style: .cancel)

            
            alertController.addAction(action1)
            alertController.addAction(action2)
            alertController.addAction(action3)
   
            
            self.present(alertController, animated: true, completion: nil)
        }
    
    //カメラ立ち上げメソッド
       func doCamera(){
           
           let sourceType:UIImagePickerController.SourceType = .camera
           
           //カメラ利用かチェック
           if UIImagePickerController.isSourceTypeAvailable(.camera){
               
               let cameraPicker = UIImagePickerController()
               cameraPicker.allowsEditing = true
               cameraPicker.sourceType = sourceType
               cameraPicker.delegate = self
               self.present(cameraPicker, animated: true, completion: nil)
           }
       }
       
       //アルバム立ち上げメソッド
       func doAlubm(){
           
           let sourceType:UIImagePickerController.SourceType = .photoLibrary
           
           //カメラ利用かチェック
           if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
               
               let cameraPicker = UIImagePickerController()
               cameraPicker.allowsEditing = true
               cameraPicker.sourceType = sourceType
               cameraPicker.delegate = self
               self.present(cameraPicker, animated: true, completion: nil)
           }
       }
    
    //カメラやアルバムで選択された画像のデータを受けとる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if info[.originalImage] as? UIImage != nil{
            
            let selectedImage = info[.originalImage] as! UIImage
            
            //画像を圧縮
            UserDefaults.standard.set(selectedImage.jpegData(compressionQuality: 0.1), forKey: "userImage")
            
            iconImageView.image = selectedImage
            //ピッカーを閉じる
            picker.dismiss(animated: true, completion: nil)
        }
        
    }
    
    //キャンセルが押された時の処理
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func iconTapped(_ sender: Any) {
        showAlert()
    }
    
    
    
    

}
