//
//  ToDataBase.swift
//  FireStoreEitangoApp
//
//  Created by 下川勇輝 on 2020/10/16.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import Foundation
import FirebaseStorage


//protocol SendProfileOKDelegate {
//
//
//    func sendProfileOKDelegate(url:String)
//
//}

class ToDataBase {
    
    
//    var sendProfileOKDelegate:SendProfileOKDelegate?
    
    
    init(){
        
    }
    
    func sendProfileImageData(data:Data){
        
        //入ってきたdata型のもの（引数）をUIimage型にキャストしてる
        let image = UIImage(data: data)
        let profileImageData = image?.jpegData(compressionQuality: 0.1)
        
        //FireStorageの保存先を指定（ストレージサーバーのパスを決めてる。フォルダ名がprofileImage。UUIDはUniqueUserID）
        let imageRef = Storage.storage().reference().child("profileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        

        //firebaseStorageに画像データを置いてる
        imageRef.putData(profileImageData!, metadata:nil) { (metaData, error) in
            
            if error != nil{
            
                print(error.debugDescription)
                return
            }
            
        //firebaseStorageから、画像が保存されているURLを取ってきてる。（そのURLを後でfirestoreに送信する。）
            imageRef.downloadURL { (url, error) in
                    
                if error != nil{
                
                    print(error.debugDescription)
                    return
                }
                
            //画像が入っているURLをString型でアプリ内に一旦保存
                UserDefaults.standard.setValue(url?.absoluteString, forKey: "userImage")
         
                
//                self.sendProfileOKDelegate?.sendProfileOKDelegate(url: url!.absoluteString)
            }
            
     
        }
     
    }
}
