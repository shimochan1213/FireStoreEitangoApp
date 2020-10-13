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
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        reviewCollectinView.dataSource = self
        reviewCollectinView.delegate = self
        
//         //セル同士の間隔調整
//        let layout = UICollectionViewFlowLayout()
////        layout.minimumLineSpacing = 30
//        layout.minimumInteritemSpacing = 30
//        collectionView.collectionViewLayout = layout
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ranges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
        

        
        
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let cellSize : CGFloat = self.view.bounds.width * 6/7
        return CGSize(width: cellSize, height: self.view.bounds.height/4)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    //reviewCollectionView
    
    func reviewCollectinView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ranges.count
    }
    
    func reviewCollectinView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    
        return cell
    }
    
    func reviewCollectinView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = self.view.bounds.width * 6/7
        return CGSize(width: cellSize, height: self.view.bounds.height/2)
    }
    
   
    
    
    
    
    
    
}
