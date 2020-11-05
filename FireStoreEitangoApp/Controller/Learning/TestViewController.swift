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
import Firebase
import FirebaseFirestore

class TestViewController: UIViewController,UIGestureRecognizerDelegate  {

    // AVSpeechSynthesizerをクラス変数で保持しておく、インスタンス変数だと読み上げるまえに破棄されてしまう
    var speechSynthesizer : AVSpeechSynthesizer!

    @IBOutlet weak var wordLabel: UILabel!
  
    @IBOutlet weak var jpnWordLabel: UILabel!
    
    @IBOutlet weak var selec1: UIButton!
    @IBOutlet weak var selec2: UIButton!
    @IBOutlet weak var selec3: UIButton!
    @IBOutlet weak var selec4: UIButton!
//    @IBOutlet weak var nextQuesBtn: UIButton!
    
    @IBOutlet weak var quesNumberLabel: UILabel!
    
    var correctCount = 0
    var incorrectCount = 0
    
    var materialList = MaterialList()
    var wordCount = 0
    var receivedCellNumber = Int()
    //不正解の単語を記録
    var incorrectArray: [Int] = []
    
    var whereIsCorrectSelection = Int()
    var animationView = AnimationView()
    var animation2View = AnimationView()
    var soundFile = SoundFile()
    
    let db = Firestore.firestore()
    var learnedNumber = Int()
    var refString = String()
    
    var tapGesture: UITapGestureRecognizer!
    var tapOK:Bool = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        var radiusRate:CGFloat = 20
        selec1.layer.cornerRadius = radiusRate
        selec2.layer.cornerRadius = radiusRate
        selec3.layer.cornerRadius = radiusRate
        selec4.layer.cornerRadius = radiusRate
        
        // ジェスチャーの生成
        tapGesture = UITapGestureRecognizer(target:self,action: #selector(TestViewController.tap))
        view.addGestureRecognizer(tapGesture)
                

        //アニメーション練習
//        var animationView = AnimationView()
//        animationView = .init(name: "success")
////                 animationView.frame = view.bounds
//        animationView.frame = CGRect(x: view.bounds.width/4, y: view.bounds.height/4, width: view.bounds.width/2, height: view.bounds.height/2)
//        animationView.contentMode = .scaleAspectFit
//        animationView.loopMode = .playOnce
//        animationView.animationSpeed = 2
//        view.addSubview(animationView)
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
    
        quesNumberLabel.text = "\(wordCount % 20 + 1) /20"
        wordLabel.text = materialList.TOEIC600NounList[wordCount].Words
        soundYomiage()
        showRandomSelection()
        
//        nextQuesBtn.isEnabled = false

    }
    
//    // ジェスチャーイベント処理
    @objc func tap(_ sender: UITapGestureRecognizer) {
//        print("Tap")
        //回答されていたら
        if tapOK == true{
        nextQuestionMethod()
        }
        
        //未回答なら何もしない
     }


    
    @IBAction func yomiageBtn(_ sender: Any) {
        soundYomiage()
    }
    
    func soundYomiage(){
        // AVSpeechSynthesizerのインスタンス作成
        self.speechSynthesizer = AVSpeechSynthesizer()
        // 読み上げる、文字、言語などの設定
        let utterance = AVSpeechUtterance(string:materialList.TOEIC600NounList[wordCount].Words) // 読み上げる文字
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // 言語
        utterance.rate = 0.5; // 読み上げ速度
        utterance.pitchMultiplier = 0.9; // 読み上げる声のピッチ
        utterance.preUtteranceDelay = 0; // 読み上げるまでのため
        self.speechSynthesizer.speak(utterance)
    }
    
    
//    @IBAction func nextQuestion(_ sender: Any) {
//        nextQuestionMethod()
//    }

    
    @IBAction func answer(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            //一番上の選択肢が押された
            if whereIsCorrectSelection == 0{
                //正解が一番上の選択肢に表示されているから正解
                playCorrectAniSound()
            }else{
                playIncorrectAniSound()
                incorrectArray.append(wordCount)
            }
        case 2:
            //2番目の選択肢が押された
            if whereIsCorrectSelection == 1{
                //正解が2番目の選択肢に表示されているから正解
                playCorrectAniSound()
            }else{
                playIncorrectAniSound()
                incorrectArray.append(wordCount)
            }
        case 3:
            if whereIsCorrectSelection == 2{
                playCorrectAniSound()
            }else{
                playIncorrectAniSound()
                incorrectArray.append(wordCount)
            }
        case 4:
            if whereIsCorrectSelection == 3{
                playCorrectAniSound()
            }else{
                playIncorrectAniSound()
                incorrectArray.append(wordCount)
            }
        default:
            break
        }
        
        //正解表示
        jpnWordLabel.text = materialList.TOEIC600NounList[wordCount].japanWords
        
//        //解答後、初めてタップを有効にする
        tapOK = true
        
//        nextQuesBtn.isEnabled = true
        
        //ボタン何回も押してアニメバグらないように
        selec1.isEnabled = false
        selec2.isEnabled = false
        selec3.isEnabled = false
        selec4.isEnabled = false
        
        if UserDefaults.standard.object(forKey: "visitedTest") == nil{
        //初回起動のみ、タップで次の問題いけるチュートリアル出す
        animation2View = .init(name: "tap")
        animation2View.frame = CGRect(x: view.bounds.width/2, y: view.bounds.height * 2/3, width: view.bounds.width/3, height: view.bounds.height/3)
        animation2View.contentMode = .scaleAspectFit
        animation2View.loopMode = .loop
        animation2View.animationSpeed = 2
        view.addSubview(animation2View)
        animation2View.play()
        }
        
       
        

     

        
    }

    
    func showRandomSelection(){
        
        //回答する前にタップで次の問題いかないように
       tapOK = false
        
        
        //正解選択肢を4つのうち何処かに配置し、残りの選択肢をランダムに表示（一つランダム数字を呼んで、そこからプラス1ずつしてけば同じ選択肢でないのでは？
        
        
        //正解選択肢を置く場所を決める
//        var whereIsCorrectSelection = Int()
        whereIsCorrectSelection = Int(arc4random_uniform(UInt32(4)))
//        print(whereIsCorrectSelection)
        
        //ダミー選択肢を表示させるために被りのない数字を生成する
        var damiNumber1 = Int(arc4random_uniform(UInt32(materialList.TOEIC600NounList.count)))
        var damiNumber2 = Int(arc4random_uniform(UInt32(materialList.TOEIC600NounList.count)))
        var damiNumber3 = Int(arc4random_uniform(UInt32(materialList.TOEIC600NounList.count)))
        
        if damiNumber1 == wordCount || damiNumber1 == damiNumber2 || damiNumber1 == damiNumber3 || damiNumber2 == damiNumber3{
           damiNumber1 = Int(arc4random_uniform(UInt32(materialList.TOEIC600NounList.count)))
           damiNumber2 = Int(arc4random_uniform(UInt32(materialList.TOEIC600NounList.count)))
           damiNumber3 = Int(arc4random_uniform(UInt32(materialList.TOEIC600NounList.count)))
        }else if damiNumber1 == wordCount || damiNumber1 == damiNumber2 || damiNumber1 == damiNumber3 || damiNumber2 == damiNumber3{
            //それでもダメならこれらを表示
            damiNumber1 = 25
            damiNumber2 = 65
            damiNumber3 = 90
        }
        
//        print(damiNumber1,damiNumber2,damiNumber3)
        
        switch whereIsCorrectSelection {
        case 0:
            //正解を一番上に表示
            selec1.setTitle(materialList.TOEIC600NounList[wordCount].japanWords, for: UIControl.State.normal)
            //その他選択肢を表示（現在のwordCountを基準として、2で割ったり数を足していくことにする）
            selec2.setTitle(materialList.TOEIC600NounList[damiNumber1].japanWords, for: UIControl.State.normal)
            selec3.setTitle(materialList.TOEIC600NounList[damiNumber2].japanWords, for: UIControl.State.normal)
            selec4.setTitle(materialList.TOEIC600NounList[damiNumber3].japanWords, for: UIControl.State.normal)
           
        case 1:
        //正解を2番目に表示
            selec2.setTitle(materialList.TOEIC600NounList[wordCount].japanWords, for: UIControl.State.normal)
            //その他選択肢を表示
            selec1.setTitle(materialList.TOEIC600NounList[damiNumber1].japanWords, for: UIControl.State.normal)
            selec3.setTitle(materialList.TOEIC600NounList[damiNumber2].japanWords, for: UIControl.State.normal)
            selec4.setTitle(materialList.TOEIC600NounList[damiNumber3].japanWords, for: UIControl.State.normal)
        case 2:
            selec3.setTitle(materialList.TOEIC600NounList[wordCount].japanWords, for: UIControl.State.normal)
            //その他選択肢を表示
            selec2.setTitle(materialList.TOEIC600NounList[damiNumber1].japanWords, for: UIControl.State.normal)
            selec1.setTitle(materialList.TOEIC600NounList[damiNumber2].japanWords, for: UIControl.State.normal)
            selec4.setTitle(materialList.TOEIC600NounList[damiNumber3].japanWords, for: UIControl.State.normal)
        case 3:
            selec4.setTitle(materialList.TOEIC600NounList[wordCount].japanWords, for: UIControl.State.normal)
            //その他選択肢を表示
            selec2.setTitle(materialList.TOEIC600NounList[damiNumber1].japanWords, for: UIControl.State.normal)
            selec3.setTitle(materialList.TOEIC600NounList[damiNumber2].japanWords, for: UIControl.State.normal)
            selec1.setTitle(materialList.TOEIC600NounList[damiNumber3].japanWords, for: UIControl.State.normal)
            
        default:
            break
        }
        
        
    }
    
    func nextQuestionMethod(){
        
        //初回のみタップのチュートリアルでてるので消す
        if UserDefaults.standard.object(forKey: "visitedTest") == nil{
        animation2View.removeFromSuperview()
        UserDefaults.standard.set(true, forKey: "visitedTest")
        }
       
        
        //アニメ消す
        animationView.removeFromSuperview()
        
        wordCount += 1
//        wordLabel.text = materialList.TOEIC600NounList[wordCount].Words
        quesNumberLabel.text = "\(wordCount % 20 + 1) / 20"
//        soundYomiage()
        jpnWordLabel.text = ""
//        showRandomSelection()
        selec1.isEnabled = true
        selec2.isEnabled = true
        selec3.isEnabled = true
        selec4.isEnabled = true
//        nextQuesBtn.isEnabled = false
        
        switch receivedCellNumber {
        case 0:
            if wordCount == 20{
                //終了
                endTest()
            }else{
                //問題終了時に次の単語が表示されないようにelse内に書いてる
                soundYomiage()
                wordLabel.text = materialList.TOEIC600NounList[wordCount].Words
                showRandomSelection()
            }
        case 1:
            if wordCount == 40{
                endTest()
            }else{
                soundYomiage()
                wordLabel.text = materialList.TOEIC600NounList[wordCount].Words
                showRandomSelection()
            }
        case 2:
            if wordCount == 60{
                endTest()
            }else{
                soundYomiage()
                wordLabel.text = materialList.TOEIC600NounList[wordCount].Words
                showRandomSelection()
            }
        case 3:
            if wordCount == 80{
                endTest()
            }else{
                soundYomiage()
                wordLabel.text = materialList.TOEIC600NounList[wordCount].Words
                showRandomSelection()
            }
        case 4:
            if wordCount == 100{
                endTest()
            }else{
                soundYomiage()
                wordLabel.text = materialList.TOEIC600NounList[wordCount].Words
                showRandomSelection()
            }
        default:
          break
        }
        
    }
    
    func endTest(){
        
        //ログイン済みであれば学んだ単語数をfirestoreに送信する
        if Auth.auth().currentUser?.uid != nil{
            //ドキュメントの中身を一部更新する
            db.collection("Profile").document(refString).updateData(["learnedNumber" : learnedNumber + 20]) { (error) in
                print(error.debugDescription)
                return
            }
            
        }
        
        //結果画面へ
        performSegue(withIdentifier: "result", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultVC = segue.destination as! ResultViewController
        
        //不正解の問題の番号を渡す
        resultVC.receivedIncorrectNumberArray = incorrectArray
        //単語の範囲を渡す（復習用保存のため）
        resultVC.receivedCellNumber = receivedCellNumber
        
        //正解数不正解数を渡す
        resultVC.correctCount = correctCount
        resultVC.incorrectCount = incorrectCount
        
    }
    
    
    @IBAction func test(_ sender: Any) {
        showRandomSelection()
        animationView.removeFromSuperview()
    }
    
    func playCorrectAniSound(){
        //日本語を黒色に
        jpnWordLabel.textColor = .black
        
//        var animationView = AnimationView()
        
        animationView = .init(name: "success")
        //         animationView.frame = view.bounds
        animationView.frame = CGRect(x: view.bounds.width/4, y: view.bounds.height/4, width: view.bounds.width/2, height: view.bounds.height/2)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .repeat(1)
        animationView.animationSpeed = 2
        view.addSubview(animationView)
        animationView.play()
        
//        tapGesture = UITapGestureRecognizer(target:self,action: #selector(TestViewController.tap))
//        view.addGestureRecognizer(tapGesture)
        
        
        
        //音ならす
        soundFile.playSound(fileName: "seikai", extensionName: "mp3")
        
        correctCount += 1
    }
    
    func playIncorrectAniSound(){
        
        //日本語を赤色に
        jpnWordLabel.textColor = .red
        
//        var animationView = AnimationView()
        animationView = .init(name: "failure")
        //         animationView.frame = view.bounds
        animationView.frame = CGRect(x: view.bounds.width/4, y: view.bounds.height/4, width: view.bounds.width/2, height: view.bounds.height/2)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 2
        view.addSubview(animationView)
        animationView.play()
        
        //音ならす
        soundFile.playSound(fileName: "fuseikai", extensionName: "mp3")
        
        incorrectCount += 1
    }
    
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
