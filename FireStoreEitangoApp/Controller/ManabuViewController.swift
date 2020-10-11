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

class ManabuViewController: UIViewController {

    // AVSpeechSynthesizerをクラス変数で保持しておく、インスタンス変数だと読み上げるまえに破棄されてしまう
    var speechSynthesizer : AVSpeechSynthesizer!
    @IBOutlet weak var manabuImageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        getImages(keyword: "cat")
        
        
    }
    

   //検索ワードの値を元に画像を引っ張ってくる
      //pixabay.com
      func getImages(keyword:String){
          //APIKEY 16306601-72effe1bbc4631fe8092700f6
          
          let url = "https://pixabay.com/api/?key=16306601-72effe1bbc4631fe8092700f6&q=\(keyword)"
          
          //Alamofireを使ってhttpリクエストを投げる。値が返ってくる。
          
          AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{(response) in
              
              switch response.result{
                  
              case .success:
                  //データを取得
                  let json:JSON = JSON(response.data as Any)
                  //外部サイトの、Lists配列の中にある画像が存在するURLをとってきて定数に入れる
                  var imageString = json["hits"][0]["webformatURL"].string
                  
                  //用意されている画像数を越えないように画像がなくなったらカウントをリセット
                  if imageString == nil {
                      
                      imageString = json["hits"][0]["webformatURL"].string
                      //odaiImageViewに反映してる
                      self.manabuImageView.sd_setImage(with: URL(string:imageString!), completed: nil)
                      
                  }else{
                      //odaiImageViewに反映してる
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
        let utterance = AVSpeechUtterance(string:"cat") // 読み上げる文字
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // 言語
        utterance.rate = 0.5; // 読み上げ速度
        utterance.pitchMultiplier = 0.5; // 読み上げる声のピッチ
        utterance.preUtteranceDelay = 0.2; // 読み上げるまでのため
        self.speechSynthesizer.speak(utterance)
        
    }
    
    
    
    
    
    
    

}
