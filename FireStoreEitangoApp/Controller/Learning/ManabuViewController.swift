//
//  ManabuViewController.swift
//  FireStoreEitangoApp
//
//  Created by 下川勇輝 on 2020/10/11.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import Alamofire
import Photos
import AVFoundation
import Firebase
import FirebaseFirestore
import Lottie

class ManabuViewController: UIViewController {

    @IBOutlet weak var numberLabel: UILabel!
    // AVSpeechSynthesizerをクラス変数で保持しておく、インスタンス変数だと読み上げるまえに破棄されてしまう
    var speechSynthesizer : AVSpeechSynthesizer!
    @IBOutlet weak var manabuImageView: UIImageView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var japanWordLabel: UILabel!
    @IBOutlet weak var manabuView: UIView!
    
    var materialList = MaterialList()
    var wordCount = 0
    var refString = String()
    
    var animationView = AnimationView()
    
    //単語の範囲を受け取る
    var receivedCellNumber = Int()
    
    //累計単語学習数を記録
    var learnedNumber = Int()
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初回のみ表示
        if UserDefaults.standard.object(forKey: "visited") == nil{
        showHowToSwipe()
        }
        
        //これまで学んだ単語数をfirestoreから引っ張ってくる
        if UserDefaults.standard.object(forKey: "refString") != nil{
            refString = UserDefaults.standard.object(forKey: "refString") as! String
            
            //refStringはdocumentを指定するID
            
            db.collection("Profile").document(refString).getDocument { (snapShot, error) in
                if error != nil{
                    return
                }
                //dataメソッドはドキュメントの中のdata全体を取ってきている。
                let data = snapShot?.data()
                self.learnedNumber = data!["learnedNumber"] as! Int
                
            }
        }
        
        
        
        //単語の範囲を指定
        switch receivedCellNumber {
        case 0:
            wordCount = 0
        case 1:
            wordCount = 20
        case 2:
            wordCount = 40
        case 3:
            wordCount = 60
        case 4:
            wordCount = 80
//        case 5:
//            wordCount = 100
        default:
            return
        }
        
        manabuView.layer.cornerRadius = 20
        manabuImageView.layer.cornerRadius = 20
        //materia design風の影の付け方の基本
        manabuView.layer.shadowColor = UIColor.black.cgColor
        manabuView.layer.shadowRadius = 1
        manabuView.layer.shadowOpacity = 0.5
        manabuView.layer.shadowOffset = CGSize(width: 1, height: 1)
        //単語の番号を表示
        numberLabel.text = String("No. \(wordCount + 1)")
        getImages(keyword: materialList.TOEIC600NounList[wordCount].Words)
        wordLabel.text = materialList.TOEIC600NounList[wordCount].Words
        japanWordLabel.text = materialList.TOEIC600NounList[wordCount].japanWords
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //firestoreの、自分のドキュメントIDをロード
        if UserDefaults.standard.object(forKey: "refString") != nil{
            refString = UserDefaults.standard.object(forKey: "refString") as! String
            
        }
        
        
        
    }
    

   //検索ワードの値を元に画像を引っ張ってくる
      //pixabay.com
      func getImages(keyword:String){
          //APIKEY 16306601-72effe1bbc4631fe8092700f6
          
          let url = "https://pixabay.com/api/?key=16306601-72effe1bbc4631fe8092700f6&q=\(keyword)"
          
          //Alamofireを使ってhttpリクエストを投げる。値が返ってくる。
          
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ [self](response) in
              
              switch response.result{
                  
              case .success:
                  //データを取得
                  let json:JSON = JSON(response.data as Any)
                  //外部サイトの、Lists配列の中にある画像が存在するURLをとってきて定数に入れる
                  var imageString = json["hits"][0]["webformatURL"].string
                  
                  //用意されている画像数を越えないように画像がなくなったらカウントをリセット
                  if imageString == nil {
                      
//                      imageString = json["hits"][0]["webformatURL"].string
//
//                      self.manabuImageView.sd_setImage(with: URL(string:imageString!), completed: nil)
                    
                    //画像がないなら「画像ない」画像を表示
                    manabuImageView.image = UIImage(named: "120reo")
                    
                    return
                      
                  }else{
                      //maanbuImageViewに反映してる
//                      self.manabuImageView.sd_setImage(with: URL(string:imageString!), completed: nil)
                    self.manabuImageView.sd_setImage(with: URL(string:imageString!), placeholderImage: UIImage(named: "loading"), completed: nil)
                  }
                  
              case .failure(let error):
                  print(error)
                  
              }
          }
      }
    
    
    @IBAction func playSound(_ sender: Any) {
        
        // AVSpeechSynthesizerのインスタンス作成
        self.speechSynthesizer = AVSpeechSynthesizer()
        // 読み上げる、文字、言語などの設定
        let utterance = AVSpeechUtterance(string:materialList.TOEIC600NounList[wordCount].Words) // 読み上げる文字
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // 言語
        utterance.rate = 0.5; // 読み上げ速度
        utterance.pitchMultiplier = 1.3; // 読み上げる声のピッチ
        utterance.preUtteranceDelay = 0; // 読み上げるまでのため
        self.speechSynthesizer.speak(utterance)
        
    }
    
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextWord(_ sender: Any) {
        
        NEXTWORD()
//        switch receivedCellNumber {
//        case 0:
//            if wordCount == 19{
//                //終了
//                //学んだ単語数をfirestoreに送信する練習
//                //ドキュメントの中身を一部更新する
////                db.collection("Profile").document(refString).updateData(["learnedNumber" : 400]) { (error) in
////                    print(error.debugDescription)
////                    return
////                }
////                dismiss(animated: true, completion: nil)
//                endLearning()
//            }
//        case 1:
//            if wordCount == 39{
//                endLearning()
//            }
//        case 2:
//            if wordCount == 59{
//                endLearning()
//            }
//        case 3:
//            if wordCount == 79{
//                endLearning()
//            }
//        case 4:
//            if wordCount == 99{
//                endLearning()
//            }
//        default:
//            break
//        }
//
//
//        //範囲のコード後で追加（落ちないように）
//        wordCount += 1
//        getImages(keyword: materialList.TOEIC600NounList[wordCount].Words)
//        wordLabel.text = materialList.TOEIC600NounList[wordCount].Words
//        japanWordLabel.text = materialList.TOEIC600NounList[wordCount].japanWords
//        //単語の番号を表示
//        numberLabel.text = String("No. \(wordCount + 1)")
    }
    
    @IBAction func beforeWord(_ sender: Any) {
        
//        //問題のはじめは戻るボタン押せない様にする
//        if wordCount == 0 || wordCount == 20 || wordCount == 40 || wordCount == 60 || wordCount == 80{
//            return
//        }
//
//        wordCount -= 1
//        getImages(keyword: materialList.TOEIC600NounList[wordCount].Words)
//        wordLabel.text = materialList.TOEIC600NounList[wordCount].Words
//        japanWordLabel.text = materialList.TOEIC600NounList[wordCount].japanWords
//        //単語の番号を表示
//        numberLabel.text = String("No. \(wordCount + 1)")
        BEFOREWORD()
    }
    
    
    @IBAction func karinoButton(_ sender: Any) {
        //学んだ単語数をfirestoreに送信する練習
        
        //ドキュメントの中身を一部更新する
        db.collection("Profile").document(refString).updateData(["learnedNumber" : 400]) { (error) in
            print(error.debugDescription)
            return
        }
    }
    
    func endLearning(){
        //学んだ単語数をfirestoreに送信する
        //ドキュメントの中身を一部更新する
        db.collection("Profile").document(refString).updateData(["learnedNumber" : learnedNumber + 20]) { (error) in
            print(error.debugDescription)
            return
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func NEXTWORD(){
        switch receivedCellNumber {
        case 0:
            if wordCount == 19{
                //終了
                //学んだ単語数をfirestoreに送信する練習
                //ドキュメントの中身を一部更新する
//                db.collection("Profile").document(refString).updateData(["learnedNumber" : 400]) { (error) in
//                    print(error.debugDescription)
//                    return
//                }
//                dismiss(animated: true, completion: nil)
                endLearning()
            }
        case 1:
            if wordCount == 39{
                endLearning()
            }
        case 2:
            if wordCount == 59{
                endLearning()
            }
        case 3:
            if wordCount == 79{
                endLearning()
            }
        case 4:
            if wordCount == 99{
                endLearning()
            }
        default:
            break
        }
        
        
        //範囲のコード後で追加（落ちないように）
        wordCount += 1
        getImages(keyword: materialList.TOEIC600NounList[wordCount].Words)
        wordLabel.text = materialList.TOEIC600NounList[wordCount].Words
        japanWordLabel.text = materialList.TOEIC600NounList[wordCount].japanWords
        //単語の番号を表示
        numberLabel.text = String("No. \(wordCount + 1)")
    }
    
    func BEFOREWORD(){
        //問題のはじめは戻るボタン押せない様にする
        if wordCount == 0 || wordCount == 20 || wordCount == 40 || wordCount == 60 || wordCount == 80{
            return
        }
        
        wordCount -= 1
        getImages(keyword: materialList.TOEIC600NounList[wordCount].Words)
        wordLabel.text = materialList.TOEIC600NounList[wordCount].Words
        japanWordLabel.text = materialList.TOEIC600NounList[wordCount].japanWords
        //単語の番号を表示
        numberLabel.text = String("No. \(wordCount + 1)")
    }
    
    
    @IBAction func swiped(_ sender: Any) {
//        //右へのスワイプ
//        print("swiped")
//        //問題のはじめは戻るボタン押せない様にする
//        if wordCount == 0 || wordCount == 20 || wordCount == 40 || wordCount == 60 || wordCount == 80{
//            return
//        }
//
//        wordCount -= 1
//        getImages(keyword: materialList.TOEIC600NounList[wordCount].Words)
//        wordLabel.text = materialList.TOEIC600NounList[wordCount].Words
//        japanWordLabel.text = materialList.TOEIC600NounList[wordCount].japanWords
//        //単語の番号を表示
//        numberLabel.text = String("No. \(wordCount + 1)")
        BEFOREWORD()
    }
    
    @IBAction func leftSwiped(_ sender: Any) {
        //左へのスワイプ
        NEXTWORD()
        animationView.removeFromSuperview()
    }
    
    func showHowToSwipe(){
       //スワイプで単語をめくれることを伝える
        
//        var animationView = AnimationView()
        animationView = .init(name: "swipe")
            animationView.frame = CGRect(x: view.bounds.width/4, y: view.bounds.height/4, width: view.bounds.width/2, height: view.bounds.height/2)
//        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        view.addSubview(animationView)
        animationView.play()
      
        
        UserDefaults.standard.set(true, forKey: "visited")
    }
    
    

}
