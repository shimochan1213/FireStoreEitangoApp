//
//  ResultViewController.swift
//  FireStoreEitangoApp
//
//  Created by 下川勇輝 on 2020/10/28.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import UIKit
import AVFoundation
import Lottie

import SwiftyJSON
import SDWebImage
import Alamofire

class ResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    // AVSpeechSynthesizerをクラス変数で保持しておく、インスタンス変数だと読み上げるまえに破棄されてしまう
    var speechSynthesizer : AVSpeechSynthesizer!
    
    var receivedCellNumber = Int()
    //間違えた問題の番号が入っている配列
    var receivedIncorrectNumberArray: [Int] = []
    var correctCount = 0
    var incorrectCount = 0
    
    
    var noun0:[Int] = []
    var noun1:[Int] = []
    var noun2:[Int] = []
    var noun3:[Int] = []
    var noun4:[Int] = []
    
    var materialList = MaterialList()
    let soundFile = SoundFile()
    let backToHomeBtn = UIButton()
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var correctRateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //全問正解の時はおめでとう出す
        if receivedIncorrectNumberArray.isEmpty == true{
            var animationView = AnimationView()
            animationView = .init(name: "congrats")
//            animationView.frame = CGRect(x: view.bounds.width/4, y: view.bounds.height/4, width: view.bounds.width/2, height: view.bounds.height/2)
            animationView.frame = view.bounds
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.animationSpeed = 1
            view.addSubview(animationView)
            animationView.play()
            soundFile.playSound(fileName: "kanseiVoice", extensionName: "mp3")
            
            correctRateLabel.text = "全問正解！"
            tableView.removeFromSuperview()
            
//            let backToHomeBtn = UIButton()
            //画面中央におきたいのであれば「(画面幅 - オブジェクトの幅)/2」の値を、オブジェクトの表示位置(X軸、左上)として設定すればよい、
            backToHomeBtn.frame = CGRect(x: (view.bounds.width - view.bounds.width * 3/4)/2, y: view.bounds.height * 3/4, width: view.bounds.width * 3/4, height: view.bounds.height/7)
            backToHomeBtn.setTitle("素晴らしい！引き続き頑張りましょう！", for: UIControl.State.normal)
            backToHomeBtn.backgroundColor = .orange
            //文字を可変に
            backToHomeBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            backToHomeBtn.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 22)
            backToHomeBtn.layer.cornerRadius = 10
            // タップされたときのaction
            self.backToHomeBtn.addTarget(self,action: #selector(self.buttonTapped(_ :)),for: .touchUpInside)
            
            view.addSubview(backToHomeBtn)
        }else{
            
            correctRateLabel.text = "正解数:\(correctCount)　不正解数:\(incorrectCount)　正解率は\(Int(correctCount * 100 / (correctCount + incorrectCount) ) )％です"
        }
        
        
        //復習用に、間違えた単語たちを保存
        //名詞　セル0 ならば　”noun0”で配列の中身を保存
        switch receivedCellNumber{
        case 0:noun0 = receivedIncorrectNumberArray
            UserDefaults.standard.set(noun0, forKey: "noun0")
        case 1:noun1 = receivedIncorrectNumberArray
            UserDefaults.standard.set(noun1, forKey: "noun1")
        case 2:noun2 = receivedIncorrectNumberArray
            UserDefaults.standard.set(noun2, forKey: "noun2")
        case 3:noun3 = receivedIncorrectNumberArray
            UserDefaults.standard.set(noun3, forKey: "noun3")
        case 4:noun4 = receivedIncorrectNumberArray
            UserDefaults.standard.set(noun4, forKey: "noun4")
        default: return
        }
        
        
        
    }
    
    @objc func buttonTapped(_ sender: UIButton){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receivedIncorrectNumberArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
 
        let imageView = cell.viewWithTag(1) as! UIImageView
        let wordLabel = cell.viewWithTag(2) as! UILabel
        wordLabel.text = materialList.TOEIC600NounList[receivedIncorrectNumberArray[indexPath.row]].Words
        let jpnWordLabel = cell.viewWithTag(3) as! UILabel
        jpnWordLabel.text = materialList.TOEIC600NounList[receivedIncorrectNumberArray[indexPath.row]].japanWords
        
        //画像取得処理
        let url = "https://pixabay.com/api/?key=16306601-72effe1bbc4631fe8092700f6&q=\(materialList.TOEIC600NounList[receivedIncorrectNumberArray[indexPath.row]].Words)"
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ [self](response) in
            
            switch response.result{
            case .success:
                let json:JSON = JSON(response.data as Any)
                var imageString = json["hits"][0]["webformatURL"].string
                if imageString == nil {
                    imageView.image = UIImage(named: "120reo")
                    return
                }else{
                    imageView.sd_setImage(with: URL(string:imageString!), placeholderImage: UIImage(named: "loading"), completed: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        return cell
 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height/5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        soundYomiage(string: materialList.TOEIC600NounList[receivedIncorrectNumberArray[indexPath.row]].Words)
    }
    
    
    func soundYomiage(string:String){
        // AVSpeechSynthesizerのインスタンス作成
        self.speechSynthesizer = AVSpeechSynthesizer()
        // 読み上げる、文字、言語などの設定
        let utterance = AVSpeechUtterance(string:string) // 読み上げる文字
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // 言語
        utterance.rate = 0.5; // 読み上げ速度
        utterance.pitchMultiplier = 0.9; // 読み上げる声のピッチ
        utterance.preUtteranceDelay = 0; // 読み上げるまでのため
        self.speechSynthesizer.speak(utterance)
    }
    

    
    
    @IBAction func closeBtn(_ sender: Any) {
        //2つ前の画面に戻る
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    

}
