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
import FirebaseFirestore
import SDWebImage



class OthersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var profileUserNameLabel: UILabel!
    var profileImageData = Data()
    var profileImage = UIImage()
    
    
    var textController: MDCTextInputControllerOutlined!
    var email = String()
    var PW = String()
    @IBOutlet weak var tableView: UITableView!
    
    //firestoreから取ってきた画像のurlをもとにアイコンを表示してみる
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    //fireStoreにアクセスするため(firestoreから色々取ってきたり送ったりするため）
    let db1 = Firestore.firestore().collection("Profile").document("KuzjYdPXAbyvlKMq1g1s")
    let db = Firestore.firestore()
    
    var imageString = String()
    //firestoreから取ってきたデータを入れておく配列。型はProfileModel型
    var profiles:[ProfileModel] = []
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadFromFireStore()
        
        
        //登録時に設定したユーザ名とアイコンを表示
        if UserDefaults.standard.object(forKey: "profileIconImage") != nil{
            profileImageData = UserDefaults.standard.object(forKey: "profileIconImage") as! Data
        }
        profileImage = UIImage(data: profileImageData)!
        profileImageView.image = profileImage
        
        
        if UserDefaults.standard.object(forKey: "profileUserName") != nil{
            profileUserNameLabel.text = UserDefaults.standard.object(forKey: "profileUserName") as! String
        }
        
        
        
        
        //        let textFieldFloating = MDCTextField(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 50))
        //        textFieldFloating.placeholder = "Usename"
        //        textFieldFloating.center = self.view.center
        //
        //        self.view.addSubview(textFieldFloating)
        //
        //
        //        self.textController = MDCTextInputControllerOutlined(textInput: textFieldFloating)
        //        self.textController.textInsets(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        //        // MDCTextInputControllerOutlined
        
        //materia design風の影の付け方の基本
        loginButton.layer.cornerRadius = 10.0
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowRadius = 1
        loginButton.layer.shadowOpacity = 0.5
        loginButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        
    }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            
            loadFromFireStore()
//            print(profiles)
            
          
            
//            //firestoreからユーザー名とってきてる
//            loadUserName()
//
//            //DBから取ってきた画像入ってるURLを定数に入れる
//            if UserDefaults.standard.object(forKey: "userImage") != nil{
//                imageString = UserDefaults.standard.object(forKey: "userImage") as! String
//            }
//            //そのurlをもとに画像を表示(とりあえずDBから取ってきて表示させる練習）
//            iconImageView.sd_setImage(with: URL(string: imageString), completed: nil)
    
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        tableView.rowHeight = 200
        let iconImageView = cell.contentView.viewWithTag(1) as! UIImageView
//        let userNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        
       
           
        //新規登録時に画像を設定した人にはアイコン表示、してない人にはデフォルトアイコンを表示。
    if profiles[indexPath.row].imageString.isEmpty == false{
        iconImageView.sd_setImage(with: URL(string: profiles[indexPath.row].imageString), completed: nil)
    }else{
    iconImageView.image = UIImage(named: "icon")
    }
    
        
        userNameLabel.text = profiles[indexPath.row].userName

        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    

    @IBAction func tapped(_ sender: Any) {
        showAlert()
    }
    
    
    
    //ユーザー名とアイコンの画像URLを取ってくる
    func loadFromFireStore(){

        //addSnapshotListenerは「変化があったもの」をとってきてる

        db.collection("Profile").addSnapshotListener{ (snapShot, error) in


            if error != nil{

                print(error.debugDescription)
                return
            }

            //すべてのdocumentが「snapShot?.documents」で取得できてる。その一つ一つのdocumentをsnapShotDocという定数にいれてる。
            if let snapShotDoc = snapShot?.documents{

                //snapShotDocの中身を一つ一つ見るためにdocへfor文で入れてる。
                for doc in snapShotDoc{

                    //docの中にあるdataを定数に入れてる。
                    let data = doc.data()
                    //空じゃないなら、定数に入れる。
                    if let userName = data["userName"] as? String, let imageString = data["imageString"] as? String{

                        //配列に入れる準備(key-value型)
                        let profile = ProfileModel(userName: userName, imageString: imageString)

                            self.profiles.append(profile)
                        
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
   
    
    //これはいけるやつ（基本の練習用）
//    func loadUserName(){
//
//        //firestoreからユーザー名とってくる
//        db1.getDocument { (snapShot, error) in
//
//            if error != nil{
//                print(error.debugDescription)
//                return
//            }
//
//            //dataメソッドはドキュメントの中のdata全体を取ってきている。
//            let data = snapShot?.data()
//            self.userNameLabel.text = data!["userName"] as! String
//
//        }
//
//    }
    
    
    
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("ログアウトしました")
        } catch let signOutError as NSError {
            print ("error", signOutError)
        }
    }
    
    //以下、アイコン設定関連
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
         
         let selectedImage = info[.originalImage] as! UIImage
         
         //画像を圧縮
         UserDefaults.standard.set(selectedImage.jpegData(compressionQuality: 0.1), forKey: "profileIconImage")
         
         profileImageView.image = selectedImage
         //ピッカーを閉じる
         picker.dismiss(animated: true, completion: nil)
     }
     
 }
 
 //キャンセルが押された時の処理
 func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
     picker.dismiss(animated: true, completion: nil)
 }
 
    
    
    
}
