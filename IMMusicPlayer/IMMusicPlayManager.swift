//
//  IMMusicPlayManager.swift
//  IMMusicPlayer
//
//  Created by imwallet on 16/12/8.
//  Copyright © 2016年 imWallet. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


let IMSoundPlayFinishNotification = Notification.Name(rawValue: "IMSoundPlayFinishNotification")

/*************************************单例模式二**************************************************/
// MARK: - 类内部声明静态常量并私有化构造器方法
/// 类内部声明静态常量并私有化构造器方法
class IMMusicPlayManager {
    static let manager = IMMusicPlayManager()
    
    private init(){}
    
    fileprivate var musicPlayers = Dictionary<String, AVAudioPlayer>()
    fileprivate var soundIDs = Dictionary<String, SystemSoundID>()
    
    // MARK: - 音乐播放效果
    /// 播放音乐
    func playMusic(musicName: String) -> AVAudioPlayer?{
        if musicName.isEmpty { return nil }
        
        if let player = musicPlayers[musicName] {
            if !player.isPlaying {
                player.play()
            }
            return player
        }
        
        var player: AVAudioPlayer
        let musicUrl = Bundle.main.url(forResource: musicName, withExtension: "mp3")
        
        guard musicUrl != nil else { return nil }
        
        do {
            player  = try AVAudioPlayer(contentsOf: musicUrl!)
            player.volume = 1.0
            player.prepareToPlay()
            if !player.isPlaying {
                player.play()
            }
            musicPlayers.updateValue(player, forKey: musicName)
            
            return player
        } catch let error {
            print("error : \(error.localizedDescription)")
            return nil
        }

    }
    
    /// 暂停音乐
    func pauseMusic(musicName: String) {
        if musicName.isEmpty { return }
        
        if let player = musicPlayers[musicName] {
            if player.isPlaying {
                player.pause()
            }
        }
    }
    
    ///  停止播放音乐
    func stopMusic(musicName: String) {
        if musicName.isEmpty { return }
        
        if let player = musicPlayers[musicName] {
            player.stop()
            musicPlayers.removeValue(forKey: musicName);
        }
    }
    
    
    //=================================================================//

    // MARK: - 播放音效
    func playSound(soundName: String) {
        
        if soundName.isEmpty { return }
        
        if let soundID = soundIDs[soundName] {
            
//            AudioServicesPlaySystemSound(soundID)
            AudioServicesPlayAlertSound(soundID)

        }else{
            var soundId: SystemSoundID = 0
            
            if let soundUrl = Bundle.main.url(forResource: soundName, withExtension: "caf") {
                AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundId)
                soundIDs.updateValue(soundId, forKey: soundName)
                
//                let proc: AudioServicesSystemSoundCompletionProc = MyAudioServicesSystemSoundCompletionHandler as! AudioServicesSystemSoundCompletionProc
                
                // 采用闭包
                AudioServicesAddSystemSoundCompletion(soundId, nil, nil, {soundId,_ in
                    print("-----播放完成回调----------")
                    NotificationCenter.default.post(name: IMSoundPlayFinishNotification, object: nil)
                }, nil)
//                AudioServicesPlaySystemSound(soundId)
                AudioServicesPlayAlertSound(soundId)
            }
        }
    }
    
    /// 音效播放完成回调
//    @objc private func MyAudioServicesSystemSoundCompletionHandler(soundID: SystemSoundID, inClientData: UnsafeMutableRawPointer){
//        print("-----播放完成回调----------")
//        let IMSoundPlayFinishNotification = Notification.Name(rawValue: "IMSoundPlayFinishNotification")
//        
//        NotificationCenter.default.post(name: IMSoundPlayFinishNotification, object: nil)
//    }
    
    /// 停止播放音效
    func disposeSound(soundName: String) {
        if soundName.isEmpty { return }
        
        if let soundID = soundIDs[soundName] {
//            AudioServicesRemoveSystemSoundCompletion(soundID)
            AudioServicesDisposeSystemSoundID(soundID)
        }
    }
}

/*************************************单例模式二**************************************************/
// MARK: - 使用全局常量
/// 使用全局常量
private let single = PlayManagerTwo()
class PlayManagerTwo {
    static var manager : PlayManagerTwo {
        return single
    }
}

/*************************************单例模式三**************************************************/
// MARK: - 在方法内定义静态常量
/// 在方法内定义静态常量
final class PlayManagerThree {
    static var manager: PlayManagerThree{
        struct Static{
            static let instance : PlayManagerThree = PlayManagerThree()
        }
        return Static.instance
    }
    
    private init(){}
}

/*************************************单例模式四**************************************************/
// MARK: - 完全是OC风格的单例，但是由于Swift3中废弃了原来的dispatch_once_t，所以需要先给DispatchQueue添加一个extension，实现原先的dispatch_once_t效果
extension DispatchQueue{
    private static var onceToken = [String]()
    public class func once(_ token: String, _ block: ()->Void) {
        objc_sync_enter(self)
        defer{
            objc_sync_exit(self)
        }
        if DispatchQueue.onceToken.contains(token) {
            return
        }
        DispatchQueue.onceToken.append(token)
        block()
    }
}

final class PlayManagerFour {
    static func manager() -> PlayManagerFour {
        struct Singleton{
            static var single: PlayManagerFour?
        }
        
        DispatchQueue.once(NSUUID().uuidString){
            Singleton.single = manager()
        }
        return Singleton.single!
    }
}

