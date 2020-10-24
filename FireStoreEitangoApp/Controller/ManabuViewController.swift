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

class ManabuViewController: UIViewController {

    // AVSpeechSynthesizerをクラス変数で保持しておく、インスタンス変数だと読み上げるまえに破棄されてしまう
    var speechSynthesizer : AVSpeechSynthesizer!
    @IBOutlet weak var manabuImageView: UIImageView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var japanWordLabel: UILabel!
    
    var materialList = MaterialList()
    var wordCount = 0
    var refString = String()
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getImages(keyword: materialList.TOEIC600NounList[0].Words)
        
        
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
                      self.manabuImageView.sd_setImage(with: URL(string:imageString!), completed: nil)
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
        utterance.pitchMultiplier = 0.9; // 読み上げる声のピッチ
        utterance.preUtteranceDelay = 0.05; // 読み上げるまでのため
        self.speechSynthesizer.speak(utterance)
        
    }
    
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextWord(_ sender: Any) {
        
        //範囲のコード後で追加（落ちないように）
        wordCount += 1
        getImages(keyword: materialList.TOEIC600NounList[wordCount].Words)
        wordLabel.text = materialList.TOEIC600NounList[wordCount].Words
        japanWordLabel.text = materialList.TOEIC600NounList[wordCount].japanWords
    }
    
    @IBAction func beforeWord(_ sender: Any) {
        //範囲のコード後で追加（落ちないように
        wordCount -= 1
        getImages(keyword: materialList.TOEIC600NounList[wordCount].Words)
        wordLabel.text = materialList.TOEIC600NounList[wordCount].Words
        japanWordLabel.text = materialList.TOEIC600NounList[wordCount].japanWords
    }
    
    
    @IBAction func karinoButton(_ sender: Any) {
        //学んだ単語数をfirestoreに送信する練習
        
        //ドキュメントの中身を一部更新する
        db.collection("Profile").document(refString).updateData(["learnedNumber" : 400]) { (error) in
            print(error.debugDescription)
            return
        }
    }
    

}
