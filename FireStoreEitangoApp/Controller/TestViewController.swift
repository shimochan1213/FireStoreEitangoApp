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
import Lottie

class TestViewController: UIViewController {

    // AVSpeechSynthesizerをクラス変数で保持しておく、インスタンス変数だと読み上げるまえに破棄されてしまう
    var speechSynthesizer : AVSpeechSynthesizer!
    @IBOutlet weak var manabuImageView: UIImageView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var japanWordLabel: UILabel!
    @IBOutlet weak var selec1: UIButton!
    @IBOutlet weak var selec2: UIButton!
    @IBOutlet weak var selec3: UIButton!
    @IBOutlet weak var selec4: UIButton!
    
    var materialList = MaterialList()
    var wordCount = 0
    var receivedCellNumber = Int()
    
    var whereIsCorrectSelection = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //アニメーション練習
        var animationView = AnimationView()
        animationView = .init(name: "success")
        //         animationView.frame = view.bounds
        animationView.frame = CGRect(x: view.bounds.width/4, y: view.bounds.height/4, width: view.bounds.width/2, height: view.bounds.height/2)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 2
        view.addSubview(animationView)
//        animationView.play()
        
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
        
        
       
        
        
        getImages(keyword: "cat")
        wordLabel.text = materialList.TOEIC600NounList[wordCount].Words

        
        
        
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
        let utterance = AVSpeechUtterance(string:materialList.TOEIC600NounList[wordCount].Words) // 読み上げる文字
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // 言語
        utterance.rate = 0.5; // 読み上げ速度
        utterance.pitchMultiplier = 0.5; // 読み上げる声のピッチ
        utterance.preUtteranceDelay = 0.2; // 読み上げるまでのため
        self.speechSynthesizer.speak(utterance)
        
    }
    

    
    @IBAction func answer(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            //一番上の選択肢が押された
            if whereIsCorrectSelection == 0{
                //正解が一番上の選択肢に表示されているから正解
                print("correct")
            }else{
                print("incorrect")
            }
            
            
        case 2:
            //2番目の選択肢が押された
            if whereIsCorrectSelection == 1{
                //正解が2番目の選択肢に表示されているから正解
                print("correct")
            }else{
                print("incorrect")
            }
        case 3:
            print(3)
            if whereIsCorrectSelection == 2{
          
                print("correct")
            }else{
                print("incorrect")
            }
        case 4:
            print(4)
            if whereIsCorrectSelection == 3{
        
                print("correct")
            }else{
                print("incorrect")
            }
        default:
            break
        }
    }
    
    
    
    func showRandomSelection(){
        //正解選択肢を4つのうち何処かに配置し、残りの選択肢をランダムに表示（一つランダム数字を呼んで、そこからプラス1ずつしてけば同じ選択肢でないのでは？
        
        
        //正解選択肢を置く場所を決める
//        var whereIsCorrectSelection = Int()
        whereIsCorrectSelection = Int(arc4random_uniform(UInt32(4)))
//        print(whereIsCorrectSelection)
        
        switch whereIsCorrectSelection {
        case 0:
            //正解を一番上に表示
            selec1.setTitle(materialList.TOEIC600NounList[wordCount].japanWords, for: UIControl.State.normal)
            //その他選択肢を表示（現在のwordCountを基準として、2で割ったり数を足していくことにする）
            selec2.setTitle(materialList.TOEIC600NounList[wordCount/2 + 2].japanWords, for: UIControl.State.normal)
            selec3.setTitle(materialList.TOEIC600NounList[wordCount/2 + 3].japanWords, for: UIControl.State.normal)
            selec4.setTitle(materialList.TOEIC600NounList[wordCount/2 + 4].japanWords, for: UIControl.State.normal)
           
        case 1:
        //正解を2番目に表示
            selec2.setTitle(materialList.TOEIC600NounList[wordCount].japanWords, for: UIControl.State.normal)
            //その他選択肢を表示
            selec1.setTitle(materialList.TOEIC600NounList[wordCount/2 + 2].japanWords, for: UIControl.State.normal)
            selec3.setTitle(materialList.TOEIC600NounList[wordCount/2 + 3].japanWords, for: UIControl.State.normal)
            selec4.setTitle(materialList.TOEIC600NounList[wordCount/2 + 4].japanWords, for: UIControl.State.normal)
        case 2:
            selec3.setTitle(materialList.TOEIC600NounList[wordCount].japanWords, for: UIControl.State.normal)
            //その他選択肢を表示
            selec2.setTitle(materialList.TOEIC600NounList[wordCount/2 + 2].japanWords, for: UIControl.State.normal)
            selec1.setTitle(materialList.TOEIC600NounList[wordCount/2 + 3].japanWords, for: UIControl.State.normal)
            selec4.setTitle(materialList.TOEIC600NounList[wordCount/2 + 4].japanWords, for: UIControl.State.normal)
        case 3:
            selec4.setTitle(materialList.TOEIC600NounList[wordCount].japanWords, for: UIControl.State.normal)
            //その他選択肢を表示
            selec2.setTitle(materialList.TOEIC600NounList[wordCount/2 + 2].japanWords, for: UIControl.State.normal)
            selec3.setTitle(materialList.TOEIC600NounList[wordCount/2 + 3].japanWords, for: UIControl.State.normal)
            selec1.setTitle(materialList.TOEIC600NounList[wordCount/2 + 4].japanWords, for: UIControl.State.normal)
            
        default:
            break
        }
        
        
    }
    
    
    @IBAction func test(_ sender: Any) {
        showRandomSelection()
    }
    
    
    
    
    

}
