//
//  Profile.swift
//  FireStoreEitangoApp
//
//  Created by 下川勇輝 on 2020/10/16.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import Foundation

struct ProfileModel {
    
    let userName:String
    let imageString:String
    let learnedNumber:Int
    
    let likeCount:Int
    let likeFlagDic:Dictionary<String, Any>
    
    //練習
    let uidString:String
    let refString:String
    
    //いいねの時に、どのユーザーにいいねするのか判別するため
    let docID:String
    
    
}
