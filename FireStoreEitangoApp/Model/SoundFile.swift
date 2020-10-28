//
//  SoundFile.swift
//  FireStoreEitangoApp
//
//  Created by 下川勇輝 on 2020/10/28.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import Foundation
import AVFoundation

//音をならすための機能を実装したクラス



    class SoundFile {

    var player: AVAudioPlayer!

        func playSound(fileName: String, extensionName:String) {
              
                guard let soundURL = Bundle.main.url(forResource: fileName, withExtension: extensionName)else{
                    print("音源ファイルが見つかりません")
                    return
                }
                
                
                
                do {
                    // AVAudioPlayerのインスタンス化
                    player = try AVAudioPlayer(contentsOf: soundURL)
                    // 音声の再生
                    player?.play()
                } catch {
                    print("エラー")
                }
            }
        }



