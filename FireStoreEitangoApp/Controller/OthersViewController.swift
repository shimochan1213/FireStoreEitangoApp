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
    
    let registerVC = RegisterViewController()
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileLearnedNumberLabel: UILabel!
    @IBOutlet weak var profileUserNameLabel: UILabel!
    var profileImageData = Data()
    var profileImage = UIImage()
    var textController: MDCTextInputControllerOutlined!
    var email = String()
    var PW = String()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //firestoreから取ってきた画像のurlをもとにアイコンを表示してみる
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    let profileLabel = UILabel()
    @IBOutlet weak var otherUsersLabel: UILabel!
    //fireStoreにアクセスするため(firestoreから色々取ってきたり送ったりするため）
    let db = Firestore.firestore()
    
    var imageString = String()
    //firestoreから取ってきたデータを入れておく配列。型はProfileModel型
    var profiles:[ProfileModel] = []
    //ユーザー登録時保存したfirestoreのdocumentIDを入れる
    var refString = String()
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var profileCard: MDCCard!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var accountAskLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    
    //タップで振動を起こすため（appleドキュメントより）
    private let feedbackGenerator: Any? = {
        if #available(iOS 10.0, *) {
            let generator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            return generator
        } else {
            return nil
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("didload")
        
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        profileCard.layer.cornerRadius = 20
        tableView.layer.cornerRadius = 20
        
        iconImageView.layer.cornerRadius = iconImageView.bounds.width/2
        
        //materia design風の影の付け方の基本
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowRadius = 1
        tableView.layer.shadowOpacity = 0.5
        tableView.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        //ログイン画面が閉じられたことを感知（プロフィール更新のため）
        NotificationCenter.default.addObserver(self, selector: #selector(fromSub), name: .notification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fromRegister), name: .notificationFromRegister, object: nil)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //上部にラベルを置く
        profileLabel.frame = CGRect(x: view.bounds.width/20, y: view.bounds.height/11, width: otherUsersLabel.bounds.width, height: otherUsersLabel.bounds.height)
        profileLabel.text = "プロフィール"
        profileLabel.font =  UIFont.boldSystemFont(ofSize: 26)
        scrollView.addSubview(profileLabel)
        
        
    }
    
    @objc func fromSub() {
//        print("fromLoginView")
//        profileLabel.isHidden = true
        if Auth.auth().currentUser?.uid == nil{
        profileLabel.isHidden = true
        }else{
            profileLabel.isHidden = false
        }
        //プロフカード更新
        showUserInformationFromFireStore()
        //いいねボタンが押せるようになったことを反映するため
        tableView.reloadData()
    }
    
    @objc func fromRegister() {
//        print("fromRegister")
        if Auth.auth().currentUser?.uid == nil{
        profileLabel.isHidden = true
        }else{
            profileLabel.isHidden = false
        }
        
        //プロフカード更新
        showUserInformationFromFireStore()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadFromFireStore()
//        print("willappear")
        
        //ログイン済みであればログインボタンと登録ボタンなどを非表示
        if Auth.auth().currentUser?.uid != nil{
            loginBtn.isHidden = true
            accountAskLabel.isHidden = true
            registerBtn.isHidden = true
            
            profileLabel.isHidden = false
        }else{
            profileLabel.isHidden = true
        }
        
        showUserInformationFromFireStore()
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        
//        if Auth.auth().currentUser?.uid == nil{
//            cell.likeBtn.setImage(UIImage(named: "noLike"), for: .normal)
//            cell.likeBtn.isEnabled = false
//        }else{
//            cell.likeBtn.isEnabled = true
//        }
        
        //新規登録時に画像を設定した人にはアイコン表示、してない人にはデフォルトアイコンを表示。
        if profiles[indexPath.row].imageString.isEmpty == false{
            cell.iconImageView.sd_setImage(with: URL(string: profiles[indexPath.row].imageString), completed: nil)
        }else{
            cell.iconImageView.image = UIImage(named: "120reo")
        }
        cell.iconImageView.layer.cornerRadius = cell.iconImageView.bounds.width/2
        
        cell.userNameLabel.text = profiles[indexPath.row].userName
        cell.learnedNumberLabel.text = "学んだ単語数は\(String(profiles[indexPath.row].learnedNumber))"
        
        
        //後で何番目のセルのいいねボタンが押されたか判別するため
        cell.likeBtn.tag = indexPath.row
        
        
        cell.likeLabel.text = String(profiles[indexPath.row].likeCount)
        cell.likeBtn.addTarget(self, action: #selector(like(_:)), for: .touchUpInside)
        
        //自分（regStringで指定してる）が、既にいいねをした記録があるならば
        if (self.profiles[indexPath.row].likeFlagDic[refString] != nil) == true{
            
            //現在、　いいねか、notいいねかを取得
            let flag = self.profiles[indexPath.row].likeFlagDic[refString]
            
            if flag! as! Bool == true{
                //「いいね」画像にする
                cell.likeBtn.setImage(UIImage(named: "like"), for: .normal)
            }else{
                //「いいね」したことあるけど今はnotいいねになっている）。つまり、likeFlagDicのidはfirestoreにのこったままである。
                cell.likeBtn.setImage(UIImage(named: "noLike"), for: .normal)
            }
        }
        
        
        if Auth.auth().currentUser?.uid == nil{
            cell.likeBtn.setImage(UIImage(named: "noLike"), for: .normal)
            cell.likeBtn.isEnabled = false
        }else{
            cell.likeBtn.isEnabled = true
        }

        
        
        return cell
    }
    
    @objc func like(_ sender:UIButton){
        //押されたボタンの情報が入ってくる（引数として）
        
        //値を送信するため
        var count = Int()
        //senderはlikeBtnのこと。どのユーザーにいいねするか判別するための処理。
        let flag = self.profiles[sender.tag].likeFlagDic[refString]
        
        
        
        if flag == nil{
            //初めていいねするので自分のidがない
            count = self.profiles[sender.tag].likeCount + 1
            //いいねの対象を取得して、データを追加してる。[自分のid：true]を追加してる。mergeは他の人のデータたちに「追加（not上書き）」するという意味
            db.collection("Profile").document(profiles[sender.tag].docID).setData(["likeFlagDic":[refString:true]], merge: true)
            
        }else{
            
            //既にいいねされている時
            if flag! as! Bool == true{
                
                //いいねを解除
                count = self.profiles[sender.tag].likeCount - 1
                db.collection("Profile").document(profiles[sender.tag].docID).setData(["likeFlagDic":[refString:false]], merge: true)
                
            }else{
                
                count = self.profiles[sender.tag].likeCount + 1
                db.collection("Profile").document(profiles[sender.tag].docID).setData(["likeFlagDic":[refString:true]], merge: true)
                
            }
            
            
        }
        
        //count情報を送信（増減したいいねの数を送信）
        db.collection("Profile").document(profiles[sender.tag].docID).updateData(["like":count], completion: nil)
        tableView.reloadData()
        
        //振動させる
        if #available(iOS 10.0, *), let generator = feedbackGenerator as? UIImpactFeedbackGenerator {
            generator.impactOccurred()
        }
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height/6
    }
    
    
    @IBAction func tapped(_ sender: Any) {
        if Auth.auth().currentUser?.uid != nil{
            showAlert()
        }
    }
    
    @IBAction func userNameLabelTapped(_ sender: Any) {
        if Auth.auth().currentUser?.uid != nil{
            performSegue(withIdentifier: "newUserName", sender: nil)
        }
    }
    
    

    //ユーザー名とアイコンの画像URLを取ってくる
    func loadFromFireStore(){
        
        //addSnapshotListenerは「変化があったもの」をとってきてる
        db.collection("Profile").addSnapshotListener{ (snapShot, error) in
            
            //毎回同じデータが増え続けるのを防ぐために一度配列を空にする
            self.profiles = []
            
            if error != nil{
                
                print(error.debugDescription)
                return
            }
            
            //すべてのdocumentが「snapShot?.documents」で取得できてる。その一つ一つのdocumentをまとめて全部snapShotDocという定数にいれてる。
            if let snapShotDoc = snapShot?.documents{
                
                //snapShotDocの中身を一つ一つ見るためにdocへfor文で入れてる。
                for doc in snapShotDoc{
                    
                    //docの中にあるdataを定数に入れてる。
                    let data = doc.data()
                    //空じゃないなら、定数に入れる。
                    if let userName = data["userName"] as? String, let imageString = data["imageString"] as? String, let learnedNumber = data["learnedNumber"] as? Int, let likeCount = data["like"] as? Int, let likeFlagDic = data["likeFlagDic"] as? Dictionary<String, Bool>, let uidString = data["uid"] as? String, let refString = data["refString"] as? String{
                        
                        let profile = ProfileModel(userName: userName, imageString: imageString, learnedNumber: learnedNumber, likeCount: likeCount, likeFlagDic: likeFlagDic, uidString: uidString, refString: refString, docID: doc.documentID)
                        
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
    
    
    
    func showUserInformationFromFireStore(){
        
        //ユーザーカードにfirestoreから取ってきたユーザー情報を表示する(変更をすぐ反映したいからaddSnapshotを使う）
        if UserDefaults.standard.object(forKey: "refString") != nil && Auth.auth().currentUser?.uid != nil{
            refString = UserDefaults.standard.object(forKey: "refString") as! String
            print(refString)
            
            db.collection("Profile").document(refString).addSnapshotListener { (snapShot, error) in
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                //dataメソッドはドキュメントの中のdata全体を取ってきている。
                let data = snapShot?.data()
                self.profileLearnedNumberLabel.text = "学んだ単語数は\(String(data!["learnedNumber"] as! Int))です"
                self.profileUserNameLabel.text = data!["userName"] as! String
                self.profileImageView.sd_setImage(with: URL(string: data!["imageString"] as! String), placeholderImage: UIImage(named: "120reo"), completed: nil)
                self.likeCountLabel.text = String(data!["like"] as! Int)
                //                self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width/2
                
            }
            
            //ログイン中は、これらを非表示
            hintLabel.isHidden = true
            loginBtn.isHidden = true
            accountAskLabel.isHidden = true
            registerBtn.isHidden = true
            
           
            
        }
    }
    
    
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("ログアウトしました")
            UserDefaults.standard.removeObject(forKey: "refString")
            
            //いいねボタン押せなくしたのを反映するため
            tableView.reloadData()
            
            likeCountLabel.text = "0"
            loginBtn.isHidden = false
            accountAskLabel.isHidden = false
            registerBtn.isHidden = false
            hintLabel.isHidden = false
            profileLabel.isHidden = true
            profileLearnedNumberLabel.text = "学んだ単語数"
            profileUserNameLabel.text = "ユーザー名"
            profileImageView.image = UIImage(named: "user128")
            
        } catch let signOutError as NSError {
            print ("error", signOutError)
        }
        
        //top(スクロールの一番上へ戻る）
        scrollView.setContentOffset(.zero, animated: true)
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
            
            //         let selectedImage = info[.originalImage] as! UIImage
            let selectedImage = info[.editedImage] as! UIImage
                  
            profileImageView.image = selectedImage
            
            //dataBaseに画像データを送り、返ってきたURLをfireStoreへ送信する
            sendProfileImageDataAndToFireStore()
            
            //ピッカーを閉じる
            picker.dismiss(animated: true, completion: nil)
        }
        
    }
    
    //キャンセルが押された時の処理
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //firebaseStorageへ画像データを送信。そして画像が保存されているURLをもらう。このURLは他のとこでfirestoreに送信する。このURLをもとに後で画像を表示する。（SDsetImage)
    func sendProfileImageDataAndToFireStore(){
        
        let image = profileImageView.image
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
            imageRef.downloadURL { [self] (url, error) in
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                print("ここにURL：\(url)")
                self.imageString = url!.absoluteString
                
                //ドキュメントの中身を一部更新する
                db.collection("Profile").document(refString).updateData(["imageString" : imageString]) { (error) in
                    print(error.debugDescription)
                    return
                }
                
            }
        }
    }
    
    
    
    
    
    
}
