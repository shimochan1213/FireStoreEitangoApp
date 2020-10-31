//
//  PreManabuViewController.swift
//  FireStoreEitangoApp
//
//  Created by 下川勇輝 on 2020/10/12.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import UIKit
import SDWebImage


class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,XMLParserDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    //    let ranges: [String] = ["1-20","21-40","41-60","61-80","81-100"]
    
    
    //XMLパーサーのインスタンスを作成する。
    var parser = XMLParser()
    //RSSのパース内の現在の要素名
    var currentElementName:String!
    var newsItems = [NewsItems]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // セル同士の間隔調整
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        collectionView.collectionViewLayout = layout
        
        
        //XMLパース
//                let urlString = "https://news.yahoo.co.jp/pickup/rss.xml"
        //        let urlString = "https://news.yahoo.co.jp/rss/media/kyoikuict/all.xml"
        let urlString = "https://news.yahoo.co.jp/rss/media/koukousei/all.xml"
        let url:URL = URL(string:urlString)!
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //XMLパース
        let urlString = "https://news.yahoo.co.jp/rss/media/koukousei/all.xml"
        let url:URL = URL(string:urlString)!
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElementName = nil
        if elementName == "item"{
            
            //NewsItemsを初期化したものを配列にぶち込む
            self.newsItems.append(NewsItems())
            
        }else{
            currentElementName = elementName
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if self.newsItems.count > 0{
            let lastItem = self.newsItems[self.newsItems.count - 1]
            
            switch self.currentElementName {
            case "title":
                //foundCharacters string: stringという変数に入ってきたものをぶち込んでる
                lastItem.title = string
                print(string)
//                print("こっち\(lastItem.title)")
             
                
                
            case "link":
//                lastItem.url = string
                if string.contains("&") != true && string.contains("source=rss") != true{
                    lastItem.url = string
                }
//                print("リンクを出力\(string)")
            case "description":
                lastItem.description = string
            case "pubDate":
                lastItem.pubDate = string
            case "image":
//                lastItem.imageString = string
                if string.contains("&") != true && string.contains("h=") != true && string.contains("q=") != true && string.contains("exp=") != true && string.contains("pri=") != true{
                lastItem.imageString = string
                }
//                print("ここは画像URLを出力\(lastItem.imageString)")
            default:
                break
            }
        }
        
        
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        //新しいものを入れる準備をする
        self.currentElementName = nil
    }
    
    
    //パースの処理が全備終わったらする処理
    func parserDidEndDocument(_ parser: XMLParser) {
        self.collectionView.reloadData()
    }
    

    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsItems.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        

        
        let newsItem = self.newsItems[indexPath.row]
        
        
        //        cell.backgroundColor = .blue
            
        
        cell.layer.masksToBounds = false
        // 影の方向（width=右方向、height=下方向、CGSize.zero=方向指定なし）
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        // 影の色
        cell.layer.shadowColor = UIColor.black.cgColor
        // 影の濃さ
        cell.layer.shadowOpacity = 0.05
        // 影をぼかし
        cell.layer.shadowRadius = 4
        
        let samuneImageView = cell.viewWithTag(1) as! UIImageView
        samuneImageView.layer.cornerRadius = 3
        //取ってきたサムネを表示

        if newsItem.imageString != nil{
            samuneImageView.sd_setImage(with: URL(string: newsItem.imageString!), placeholderImage: UIImage(named: "loading"))
        }
        
  
        
        //タイトル記事
        let titleLabel = cell.contentView.viewWithTag(2) as! UILabel
        //        titleLabel.text = "ドラもん"
        titleLabel.text = newsItem.title
        
        //記事本文
        let descriptionLabel = cell.contentView.viewWithTag(3) as! UILabel
        descriptionLabel.text = newsItem.description
        
        //日付
        let pubDateLabel = cell.contentView.viewWithTag(5) as! UILabel
        pubDateLabel.text = newsItem.pubDate
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = self.view.bounds.width * 6/7
        return CGSize(width: cellSize, height: self.view.bounds.height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //せるがタップされた時の処理
        //webViewControllerにurlを渡して表示したい。
        let webViewController = WebViewController()
        webViewController.modalTransitionStyle = .flipHorizontal
        let newsItem = newsItems[indexPath.row]
        print("ここやややや\(newsItem.url)")
        UserDefaults.standard.set(newsItem.url, forKey: "url")
    
        present(webViewController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
}
