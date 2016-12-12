//
//  ViewController.swift
//  IMMusicPlayer
//
//  Created by imwallet on 16/12/7.
//  Copyright © 2016年 imWallet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.white
        self.title = "HOME"
//        self.view.backgroundColor = UIColor.setHexStringColor("4b378h")
//        self.view.backgroundColor = UIColor.randomColor()
        
        let musicButton = UIButton(frame: CGRect(x: (view.frame.size.width - 100) * 0.5, y: 200, width: 100, height: 50))
        musicButton.backgroundColor = UIColor.orange
        musicButton.setTitle("播放音乐", for: .normal)
        musicButton.setTitleColor(UIColor.randomColor(), for: .normal)
        musicButton.addTarget(self, action: #selector(musicButtonClick(_:)), for: .touchUpInside)
        view.addSubview(musicButton)
        
        let soundButton = UIButton.init(frame: CGRect(x: (view.frame.size.width - 100) * 0.5, y: 400, width: 100, height: 50))
        soundButton.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
        soundButton.setTitleColor(UIColor.randomColor(), for: .normal)
        soundButton.setTitle("播放音效", for: .normal)
        soundButton.addTarget(self, action: #selector(soundButtonClick(_:)), for: .touchUpInside)
        view.addSubview(soundButton)
        
//        PlayManagerTwo.manager
//        PlayManagerThree.manager
//        PlayManagerFour.manager()
        
    }

    @objc fileprivate func musicButtonClick(_ button: UIButton) {
        self.navigationController?.pushViewController(IMMusicPlayViewController(), animated: true)
    }
    
    @objc fileprivate func soundButtonClick(_ button: UIButton) {
        IMMusicPlayManager.manager.pauseMusic(musicName: IMMusicPlayViewController().fileName)
        self.navigationController?.pushViewController(IMSoundPlayViewController(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

