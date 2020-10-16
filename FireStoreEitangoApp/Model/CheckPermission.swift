//
//  CheckPermission.swift
//  FireStoreEitangoApp
//
//  Created by 下川勇輝 on 2020/10/16.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import Foundation
import Photos

class CheckPermission {
    
    func showCheckPermission(){
        PHPhotoLibrary.requestAuthorization { (status) in
            
            switch(status){
                
            case .authorized:
                print("許可されてますよ")

            case .denied:
                    print("拒否")

            case .notDetermined:
                        print("notDetermined")
                
            case .restricted:
                        print("restricted")
                
//            case .limited:
//                print("limited")
            @unknown default: break
                
            }
            
        }
    }

}
