//
//  IMSoundPlayViewController.swift
//  IMMusicPlayer
//
//  Created by imwallet on 16/12/8.
//  Copyright © 2016年 imWallet. All rights reserved.
//

import UIKit

class IMSoundPlayViewController: UIViewController {
    
    let fileName = "in"
    
    var playButton = UIButton()
    var stopButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.randomColor()
        // Do any additional setup after loading the view.
        title = "音效测试"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.itemCreat(title: "测试", color: UIColor.randomColor(), self, action: #selector(rightItemAction))
        
        playButton = UIButton(frame: CGRect(x: (view.frame.size.width - 100) * 0.5, y: 200, width: 100, height: 50))
        playButton.backgroundColor = UIColor.orange
        playButton.setTitle("播放", for: .normal)
        playButton.setTitleColor(UIColor.randomColor(), for: .normal)
        playButton.addTarget(self, action: #selector(playButtonClick(_:)), for: .touchUpInside)
        view.addSubview(playButton)
        
        stopButton = UIButton.init(frame: CGRect(x: (view.frame.size.width - 100) * 0.5, y: 400, width: 100, height: 50))
        stopButton.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
        stopButton.setTitleColor(UIColor.randomColor(), for: .normal)
        stopButton.setTitle("停止", for: .normal)
        stopButton.addTarget(self, action: #selector(stopButtonClick(_:)), for: .touchUpInside)
        view.addSubview(stopButton)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(soundPlayFinish(_:)), name: IMSoundPlayFinishNotification, object: nil)
    }
    
    @objc func rightItemAction() {
        print("rightItemAction")
    }
    
    @objc fileprivate func soundPlayFinish(_ notifition: Notification){
        let alert = UIAlertController(title: "通知", message: "音效播放完成", preferredStyle: .alert)
        let alertCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(alertCancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc fileprivate func playButtonClick(_ button: UIButton) {
        IMMusicPlayManager.manager.playSound(soundName: fileName)
    }
    
    @objc fileprivate func stopButtonClick(_ button: UIButton) {
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
