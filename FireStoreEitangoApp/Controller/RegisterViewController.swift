//
//  RegisiterViewController.swift
//  FireStoreEitangoApp
//
//  Created by 下川勇輝 on 2020/10/11.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import MaterialComponents.MaterialTextFields
import SDWebImage

extension Notification.Name {
    static let notificationFromRegister = Notification.Name("SettingsDone")
}


class RegisterViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var textFieldFloatingUserName: MDCTextField!
    @IBOutlet weak var textFieldFloatingEmail: MDCTextField!
    @IBOutlet weak var textFieldFloatingPW: MDCTextField!
    @IBOutlet weak var registerBtn: MDCRaisedButton!
    var textControllerUserName: MDCTextInputControllerOutlined!
    var textControllerEmail: MDCTextInputControllerOutlined!
    var textControllerPW: MDCTextInputControllerOutlined!
    
    //fireStoreにアクセスするため(firestoreから色々取ってきたり送ったりするため）
    let db = Firestore.firestore()
    
    let urlString = String()
    var imageString = String()
    //各ユーザのドキュメントidを保持するため
    var idString = String()
    
//    var refString = String()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //カメラ、アルバムを使用する旨を表示
        let checkModel = CheckPermission()
        checkModel.showCheckPermission()
        
        textFieldFloatingUserName.delegate = self
        textFieldFloatingEmail.delegate = self
        textFieldFloatingPW.delegate = self
        
        registerBtn.layer.cornerRadius = 5
        
        textFieldFloatingUserName.placeholder = "ユーザー名"
        self.textControllerUserName = MDCTextInputControllerOutlined(textInput: textFieldFloatingUserName)
        
        textFieldFloatingEmail.placeholder = "メールアドレス"
        self.textControllerEmail = MDCTextInputControllerOutlined(textInput: textFieldFloatingEmail)
        
        textFieldFloatingPW.placeholder = "パスワード"
        self.textControllerPW = MDCTextInputControllerOutlined(textInput: textFieldFloatingPW)
        
    }
    
    //ログイン画面が閉じるときに、元のviewへ「閉じるよ！」と伝える（プロフィールデータを更新のため）
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: .notificationFromRegister, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    //      //FIrebaseにユーザーを登録する
    @IBAction func registerNewUser(_ sender: Any) {
        //新規登録（Firebaseのドキュメントにあるやり方
        Auth.auth().createUser(withEmail:textFieldFloatingEmail.text! , password: textFieldFloatingPW.text!) { [self] (user,  error) in
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
                    self.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(action)
                self.present(alertController, animated:true)
                
//                //自分のプロフィール作成用にユーザー名とアイコンを保存
//                UserDefaults.standard.setValue(textFieldFloatingUserName.text, forKey: "profileUserName")
//                //userDefaultsはUIImage型は保存できないためdata型で保存
//                let data = iconImageView.image?.jpegData(compressionQuality: 0.1)
//                UserDefaults.standard.setValue(data, forKey: "profileIconImage")
                
//                //以下データベース関連
//                sendProfileImageData()
                
                
                
                if let userName = textFieldFloatingUserName.text {
                    
                    //新しいfirestoreのdocument送信先を保存するため、古い行き先は削除
                    if UserDefaults.standard.object(forKey: "refString") != nil{
                        UserDefaults.standard.removeObject(forKey: "refString")
                    }
                    
                    //このユーザー専用のfirestore参照先(ドキュメントID)
                    var profileRef = Firestore.firestore().collection("Profile").document()
                    var refString = String()
                    
//                    refString = Firestore.firestore().collection("Profile").document().documentID
                    
                    refString = profileRef.documentID
                    
                  
                    
                    
                    var uidString = String()
                    uidString = Auth.auth().currentUser!.uid
                    
                    profileRef.setData(["userName":userName,"imageString":imageString, "learnedNumber": 0, "like":0, "likeFlagDic":[refString:false], "uid": uidString, "refString":refString] ) { (error) in
                        if error != nil{
                            print(error.debugDescription)
                            return
                        }
                        
                        //指定済みのdocumentにおけるIDを保存しておく（othersViewでデータ読み込むため）
                        UserDefaults.standard.setValue(refString, forKey: "refString")
                        print("\(refString)")
                        
                        sendProfileImageData()
                        
                        //非同期処理(通信重たい時などのためにUIの処理だけ並行してやってしまう）
                        DispatchQueue.main.async {
                            self.textFieldFloatingUserName.resignFirstResponder()
                            self.textFieldFloatingEmail.resignFirstResponder()
                            self.textFieldFloatingPW.resignFirstResponder()
                        }
                    }
                }
                
            }
        }
    }
    
    
    //firebaseStorageへ画像データを送信。そして画像が保存されているURLをもらう。このURLは他のとこでfirestoreに送信する。このURLをもとに後で画像を表示する。（SDsetImage)
    func sendProfileImageData(){
        
        let image = iconImageView.image
        let profileImageData = image?.jpegData(compressionQuality: 0.1)
        //FireStorageの保存先を指定（ストレージサーバーのパスを決めてる。フォルダ名がprofileImage。UUIDはUniqueUserID）
        let imageRef = Storage.storage().reference().child("profileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        //firebaseStorageに画像データを置いてる
        imageRef.putData(profileImageData!, metadata:nil) { (metaData, error) in
            
            if error != nil{
                
                print(error.debugDescription)
                return
            }
            //firebaseStorageから、画像が保存されているURLを取ってきてる。（そのURLを後でfirestoreに送信する。）
            imageRef.downloadURL { (url, error) in
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                print("ここにURL：\(url)")
                self.imageString = url!.absoluteString
                print("imageStringは\(self.imageString)")
             
                
               
                //以下、画像URLをFSへ送信する処理（ユーザー名などと比べ画像URLはURLの取得に時間がかかるからここで処理している）
                var refStringForDatabase = String()
                if UserDefaults.standard.object(forKey: "refString") != nil{
                    refStringForDatabase = UserDefaults.standard.object(forKey: "refString") as! String
                }
                
                self.db.collection("Profile").document(refStringForDatabase).updateData(["imageString" : self.imageString]) { (error) in
                    print(error.debugDescription)
                    return
                }
                
            }
        }
    }
    
    
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
        textFieldFloatingUserName.resignFirstResponder()
    }
    
    //リターンでキーボ閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldFloatingEmail.resignFirstResponder()
        textFieldFloatingPW.resignFirstResponder()
        textFieldFloatingUserName.resignFirstResponder()
        return true
    }
    
    
    //アラートを出す
    func showAlert(){
        
        let alertController = UIAlertController(title: "選択", message: "どちらの方法で画像を追加しますか", preferredStyle: .actionSheet)
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
            
            //            let selectedImage = info[.originalImage] as! UIImage
            let selectedImage = info[.editedImage] as! UIImage
            //画像を圧縮（おそらくもういらない処理）
            UserDefaults.standard.set(selectedImage.jpegData(compressionQuality: 0.1), forKey: "userImage")
            
            iconImageView.image = selectedImage
            
            //storageに画像データを送信してURLを受け取っておく
//            sendProfileImageData()
            
     
            
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
