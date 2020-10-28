//
//  ResultViewController.swift
//  FireStoreEitangoApp
//
//  Created by 下川勇輝 on 2020/10/28.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import UIKit
import AVFoundation

import SwiftyJSON
import SDWebImage
import Alamofire

class ReviewViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    // AVSpeechSynthesizerをクラス変数で保持しておく、インスタンス変数だと読み上げるまえに破棄されてしまう
    var speechSynthesizer : AVSpeechSynthesizer!
    
    var receivedCellNumber = Int()
    //間違えた問題の番号が入っている配列
    var receivedIncorrectNumberArray: [Int] = []
    
    var noun0:[Int] = []
    var noun1:[Int] = []
    var noun2:[Int] = []
    var noun3:[Int] = []
    var noun4:[Int] = []
    
    var materialList = MaterialList()
    let soundFile = SoundFile()
    
   
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        switch receivedCellNumber{
        case 0:if UserDefaults.standard.object(forKey: "noun0") != nil{
            receivedIncorrectNumberArray = UserDefaults.standard.object(forKey: "noun0") as! [Int]
        }
        case 1:if UserDefaults.standard.object(forKey: "noun1") != nil{
            receivedIncorrectNumberArray = UserDefaults.standard.object(forKey: "noun1") as! [Int]
        }
        case 2:if UserDefaults.standard.object(forKey: "noun2") != nil{
            receivedIncorrectNumberArray = UserDefaults.standard.object(forKey: "noun2") as! [Int]
        }
        case 3:if UserDefaults.standard.object(forKey: "noun3") != nil{
            receivedIncorrectNumberArray = UserDefaults.standard.object(forKey: "noun3") as! [Int]
        }
        case 4:if UserDefaults.standard.object(forKey: "noun4") != nil{
            receivedIncorrectNumberArray = UserDefaults.standard.object(forKey: "noun4") as! [Int]
        }
        default: return
        }
        
        
        
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
        dismiss(animated: true, completion: nil)
    }
    

}
