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



class OthersViewController: UIViewController {
    
    var textController: MDCTextInputControllerOutlined!
    
    var email = String()
    var PW = String()
    
    //firestoreから取ってきた画像のurlをもとにアイコンを表示してみる
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    //fireStoreにアクセスするため(firestoreから色々取ってきたり送ったりするため）
    let db1 = Firestore.firestore().collection("Profile").document("KuzjYdPXAbyvlKMq1g1s")
    var imageString = String()
    
    var profiles:[ProfileModel] = []
    
    
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            //firestoreからユーザー名とってきてる
            loadUserName()
            
            //DBから取ってきた画像入ってるURLを定数に入れる
            if UserDefaults.standard.object(forKey: "userImage") != nil{
                imageString = UserDefaults.standard.object(forKey: "userImage") as! String
            }
            //そのurlをもとに画像を表示(とりあえずDBから取ってきて表示させる練習）
            iconImageView.sd_setImage(with: URL(string: imageString), completed: nil)
    
        }
    
   
    
    
//    //ユーザー名を取ってくる
//    func loadFromDB(){
//
//        db.collection("Profile").addSnapshotListener { (snapShot, error) in
//
//
//            if error != nil{
//
//                print(error.debugDescription)
//                return
//            }
//
//            if let snapShotDoc = snapShot?.documents{
//
//                for doc in snapShotDoc{
//
//                    let data = doc.data()
//                    if let userName = data["userName"] as? String, let imageString = data["imageString"] as? String{
//
//                        let profile = ProfileModel(userName: userName, imageString: imageString)
//
//                            self.profiles.append(profile)
//                    }
//                }
//            }
//        }
//    }
    
    func loadUserName(){
        
        //firestoreからユーザー名とってくる
        db1.getDocument { (snapShot, error) in
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            //dataメソッドはドキュメントの中のdata全体を取ってきている。
            let data = snapShot?.data()
            self.userNameLabel.text = data!["userName"] as! String
            
        }
        
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
