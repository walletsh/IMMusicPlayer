//
//  IMMusicPlayViewController.swift
//  IMMusicPlayer
//
//  Created by imwallet on 16/12/8.
//  Copyright © 2016年 imWallet. All rights reserved.
//

import UIKit
import MediaPlayer


class IMMusicPlayViewController: UIViewController, AVAudioPlayerDelegate {

    let files: Array = ["伍佰 - 挪威的森林", "伍佰 - 浪人情歌", "林忆莲 - 伤痕(Live) - live", "许茹芸 - 如果云知道", "许巍 - 故乡", "刀郎 - 谢谢你", "周华健 - 爱相随", "李健 - 风吹麦浪", "周华健 - 花心"]
    
    var fileName : String = ""
    var musicName: String = ""
    var musicImage: UIImage = UIImage()
    var artist: String = ""
    var albumName:String = ""
    
    var circleImage: UIImageView = UIImageView()
    var fileTime: UILabel = UILabel()
    var progressView: UIView = UIView()
    var slider: UIButton = UIButton()
    var playButton: UIButton = UIButton()
    
    var audioPlayer = AVAudioPlayer()
    var timer = Timer()
    
    var isPlaying = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        let index = arc4random()%UInt32(files.count)
        fileName = files[Int(index)]
        
        let playingMusicName = UserDefaults.standard.string(forKey: "audioPlayer")
        
        if let playingMusicName = playingMusicName {
            if fileName != playingMusicName {
                IMMusicPlayManager.manager.stopMusic(musicName: playingMusicName)
            }
        }
        
        getMusicInfo(fileName:fileName)
        
        setupNavView()
        
        setupUI()
        
        startPlayAudio()
        
        startImageAnimation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionInterruptionNotification(_:)), name: Notification.Name.AVAudioSessionInterruption, object: nil)

    }

    // MARK: - public Method
    // MARK: -获取音乐信息
    private func getMusicInfo(fileName: String) {
        
        let musicUrl = Bundle.main.url(forResource: fileName, withExtension: "mp3")
        
        guard musicUrl != nil else { return }
        
        let mp3Asset = AVURLAsset.init(url: musicUrl!, options: nil)
        let formats = mp3Asset.availableMetadataFormats
        if formats.isEmpty {
            musicImage = UIImage(named: "icon_2")!
            musicName = fileName
            title = fileName
            artist = "未知"
            return
        }
        for format in formats {
            let itemFormats = mp3Asset.metadata(forFormat: format)
            for metaItem in itemFormats {
                if metaItem.commonKey == "artwork" {// 歌曲图
                    if let imageData = metaItem.value {
                        if let image = UIImage(data: imageData as! Data) {
                            musicImage = image
                        }else{
                            musicImage = UIImage(named: "icon_2")!
                        }
                    }else{
                        musicImage = UIImage(named: "icon_2")!
                    }
                }
                
                if metaItem.commonKey == "title" {//歌曲名
                    musicName = metaItem.value as! String
                    title = musicName
                }
                
                if metaItem.commonKey == "albumName" {// 专辑名
                    albumName = metaItem.value as! String
                }
                
                if metaItem.commonKey == "artist" {//歌手
                    artist = metaItem.value as! String
                }
            }
        }
    }
    
    fileprivate func setupNavView() {
        
        let lyricItem = UIBarButtonItem(title: "歌词", style: .done, target: self, action: #selector(lyricAction))
        self.navigationItem.rightBarButtonItem = lyricItem
        
    }
    
    @objc func lyricAction() {
        let alertVC = UIAlertController(title: "温馨提示", message: "歌词功能敬请期待", preferredStyle: .alert)
        let sureAlert = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertVC.addAction(sureAlert)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: -UI布局
    private func setupUI() {
        
        let blurImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 88))
        blurImageView.image = musicImage
        blurImageView.contentMode = .scaleAspectFill
        view.addSubview(blurImageView)
        // 毛玻璃效果
        let effect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = CGRect(x: 0, y: 0, width: blurImageView.frame.size.width, height: blurImageView.frame.size.height)
        blurImageView.addSubview(effectView)
        
        circleImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        circleImage.center = CGPoint(x: view.frame.size.width * 0.5, y: view.frame.size.height * 0.5 - 64)
        circleImage.image = musicImage
        circleImage.layer.cornerRadius = circleImage.frame.size.width * 0.5
        circleImage.layer.masksToBounds = true
        circleImage.layer.borderWidth = 1
        circleImage.layer.borderColor = UIColor.randomColor().cgColor
        circleImage.contentMode = .scaleAspectFill
        view.addSubview(circleImage)
        
        
        let contentView = UIView(frame: CGRect(x: 0, y: view.frame.size.height - 88, width: view.frame.size.width, height: 88))
        contentView.backgroundColor = UIColor.randomColor().withAlphaComponent(0.1)
        view.addSubview(contentView)
        
        let playView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 10))
        playView.backgroundColor = UIColor.randomColor().withAlphaComponent(0.1)
        contentView.addSubview(playView)
        
        fileTime = UILabel(frame: CGRect(x: view.frame.size.width - 55, y: 0, width: 50, height: 10))
        fileTime.font = UIFont.systemFont(ofSize: 10)
        fileTime.textColor = UIColor.black
        fileTime.textAlignment = .right
        playView.addSubview(fileTime)
        
        progressView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
        progressView.backgroundColor = UIColor.randomColor()
        playView.addSubview(progressView)
        
        slider = UIButton(frame: CGRect(x: 0, y: -5, width: 41, height: 21))
        slider.setBackgroundImage(UIImage(named: "process_thumb"), for: .normal)
        slider.setTitleColor(UIColor.red, for: .normal)
        slider.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        contentView.addSubview(slider)
        
        playButton = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 46))
        playButton.center = CGPoint(x: contentView.frame.size.width * 0.5, y: contentView.frame.size.height * 0.5)
        playButton.setImage(UIImage(named: "pause"), for: .normal)
        playButton.setImage(UIImage(named: "play"), for: .selected)
        playButton.addTarget(self, action: #selector(playButtonClick(_:)), for: .touchUpInside)
        contentView.addSubview(playButton)
        
    }
    
    /// 开始播放
    private func startPlayAudio() {
        
        audioPlayer = IMMusicPlayManager.manager.playMusic(musicName: fileName)!
        audioPlayer.delegate = self
        
        UserDefaults.standard.set(fileName, forKey: "audioPlayer")
        UserDefaults.standard.synchronize()
        
        fileTime.text = musicDuration(duration: audioPlayer.duration)
        
        addCurrentTimer()
        updateLockedScreenMusic()
    }
    
    // MARK: - Event Action
    @objc private func playButtonClick(_ button: UIButton) {
        button.isSelected = !button.isSelected
        isPlaying = !isPlaying
        pauseOrPlayMusic(button.isSelected)
    }
    
    // MARK: - private Methed
    private func musicDuration(duration: TimeInterval) -> String {
        let minute = Int(duration / 60)
        let second = Int(duration) % 60
        
        return String.init(format: "%02d:%02d", minute, second)
        
    }
    
    private func pauseOrPlayMusic(_ isPlaying: Bool) {
        if isPlaying {
            IMMusicPlayManager.manager.pauseMusic(musicName: fileName)
            removeCurrentTimer()
            stopImageAnimation()
        }else{
            IMMusicPlayManager.manager.playMusic(musicName: fileName)
            addCurrentTimer()
            resumeImageAnimation()
        }
    }
    
    private func setPlayButtonState(_ isSelect: Bool) {
        playButton.isSelected = isSelect
        pauseOrPlayMusic(isSelect)
    }
    
    // MARK: - timer--处理进度条
    /// 添加定时器 播放
    private func addCurrentTimer() {
        if !audioPlayer.isPlaying { return }
        
        removeCurrentTimer()
        updateCurrentTimer()
        
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateCurrentTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    
    /// 移除定时器 停止播放
    private func removeCurrentTimer() {
        timer.invalidate()
    }
    
    /// 更新UI
    @objc private func updateCurrentTimer() {
        let scale = audioPlayer.currentTime / audioPlayer.duration
        slider.frame.origin.x = CGFloat(scale) * (view.frame.size.width - slider.frame.size.width)
        slider.setTitle(musicDuration(duration: audioPlayer.currentTime), for: .normal)
        progressView.frame.size.width = slider.center.x
    }
    
    // MARK: - Animation Methed
    /// 开始动画
    private func startImageAnimation() {
        let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = .pi * 2.0
        rotationAnimation.duration = 30
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float(LONG_MAX)
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.fillMode = kCAFillModeForwards
        circleImage.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    /// 暂停动画
    private func stopImageAnimation() {
        let pauseTime = circleImage.layer.convertTime(CACurrentMediaTime(), from: nil)
        circleImage.layer.speed = 0.0
        circleImage.layer.timeOffset = pauseTime
    }
    
    /// 继续动画
    private func resumeImageAnimation() {
        let pauseTime = circleImage.layer.timeOffset
        circleImage.layer.speed = 1.0
        circleImage.layer.timeOffset = 0.0
        circleImage.layer.beginTime = 0.0
        let timeSincePause = circleImage.layer.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
        circleImage.layer.beginTime = timeSincePause
        
    }
    
    // MARK: - AVAudioPlayerDelegate
    internal func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("audioPlayerDidFinishPlaying")
        playButton.isSelected = true
        stopImageAnimation()
    }
    
    /// 电话中断通知
    @objc private func audioSessionInterruptionNotification(_ notification: Notification) {
        let type = notification.userInfo?[AVAudioSessionInterruptionTypeKey]
        if let type = AVAudioSessionInterruptionType(rawValue: type as! UInt) {
            switch type {
            case .began: setPlayButtonState(true)
                break
            case .ended: setPlayButtonState(false)
                break
            }
        }
    }
    
    // MARK: - 锁屏时候的设置
    private func updateLockedScreenMusic() {
        
        var info = Dictionary<String, Any>()
        
        info[MPMediaItemPropertyAlbumTitle] = albumName
        info[MPMediaItemPropertyArtist] = artist
        info[MPMediaItemPropertyTitle] = musicName
        info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: circleImage.image!)
        info[MPMediaItemPropertyPlaybackDuration] = audioPlayer.duration
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.currentTime
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        
        becomeFirstResponder()
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    // MARK: - 远程控制事件
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func remoteControlReceived(with event: UIEvent?) {

        if let type = event?.type {
            if type == .remoteControl {
                if let subType = event?.subtype {
                    switch subType {
                    case .remoteControlPlay://播放事件【操作：停止状态下，按耳机线控中间按钮一下】
                        setPlayButtonState(false)
                        break
                    case .remoteControlPause://暂停事件
                        setPlayButtonState(true)
                        break
                    case .remoteControlTogglePlayPause://播放或暂停切换【操作：播放或暂停状态下，按耳机线控中间按钮一下】
                        isPlaying = !isPlaying
                        setPlayButtonState(!isPlaying)
                        break
                    case .remoteControlStop://停止事件
                        setPlayButtonState(true)
                        break
                    case .remoteControlNextTrack://下一曲【操作：按耳机线控中间按钮两下】
                        break
                    case .remoteControlPreviousTrack://上一曲【操作：按耳机线控中间按钮三下】
                        break
                    case .remoteControlBeginSeekingForward: //快进开始【操作：按耳机线控中间按钮两下不要松开】
                        break
                    case .remoteControlEndSeekingForward: //快进停止【操作：按耳机线控中间按钮两下到了快进的位置松开】
                        break
                    case .remoteControlBeginSeekingBackward: //快退开始【操作：按耳机线控中间按钮三下不要松开】
                        break
                    case .remoteControlEndSeekingBackward: //快退停止【操作：按耳机线控中间按钮三下到了快退的位置松开】
                        break
                    default: break
                    }
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
