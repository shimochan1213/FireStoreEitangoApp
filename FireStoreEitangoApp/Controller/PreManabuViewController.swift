//
//  PreManabuViewController.swift
//  FireStoreEitangoApp
//
//  Created by 下川勇輝 on 2020/10/12.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import UIKit

class PreManabuViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
 
    @IBOutlet weak var reviewCollectinView: UICollectionView!
    
    
    let ranges: [String] = ["1-20","21-40","41-60","61-80","81-100"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionViewプロトコルのメソッドを使えるようにする
        collectionView.dataSource = self
        collectionView.delegate = self
//
        reviewCollectinView.dataSource = self
        reviewCollectinView.delegate = self
        
        
        
//         //セル同士の間隔調整
//        let layout = UICollectionViewFlowLayout()
////        layout.minimumLineSpacing = 30
//        layout.minimumInteritemSpacing = 30
//        collectionView.collectionViewLayout = layout
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{
            return ranges.count
        }else if collectionView.tag == 2{
            return ranges.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//                cell.backgroundColor = .blue
        
        cell.layer.masksToBounds = false
        // 影の方向（width=右方向、height=下方向、CGSize.zero=方向指定なし）
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        // 影の色
        cell.layer.shadowColor = UIColor.black.cgColor
        // 影の濃さ
        cell.layer.shadowOpacity = 0.05
        // 影をぼかし
        cell.layer.shadowRadius = 4
        
        let rangeLabel = cell.contentView.viewWithTag(1) as! UILabel
        rangeLabel.text = ranges[indexPath.row]
       
    
        return cell
        
        }else if collectionView.tag == 2{
            //review用のcollectionView
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath)
            
            cell2.layer.masksToBounds = false
            // 影の方向（width=右方向、height=下方向、CGSize.zero=方向指定なし）
            cell2.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            // 影の色
            cell2.layer.shadowColor = UIColor.black.cgColor
            // 影の濃さ
            cell2.layer.shadowOpacity = 0.05
            // 影をぼかし
            cell2.layer.shadowRadius = 4
            
            let reviewRangeLabel = cell2.contentView.viewWithTag(1) as! UILabel
            reviewRangeLabel.text = ranges[indexPath.row]
            
            return cell2
            
        }
        return UICollectionViewCell()
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        
        if collectionView.tag == 1{
        let cellSize : CGFloat = self.view.bounds.width * 6/7
        return CGSize(width: cellSize, height: self.view.bounds.height/4)
        }else if collectionView.tag == 2{
            let cellSize : CGFloat = self.view.bounds.width * 6/7
            return CGSize(width: cellSize, height: self.view.bounds.height/4)
        }
        return CGSize(width: 100, height: 100)
        }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 1{
            return 1
        }else if collectionView.tag == 2{
            return 1
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1{
            performSegue(withIdentifier: "manabu", sender: nil)
        }else if collectionView.tag == 2{
            performSegue(withIdentifier: "test", sender: nil)
        }
    }

    

    
   
    
    
    
    
    
    
}
