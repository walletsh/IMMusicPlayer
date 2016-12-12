//
//  UIBarButtonItem+IMExtension.swift
//  IMMusicPlayer
//
//  Created by imwallet on 16/12/9.
//  Copyright © 2016年 imWallet. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    
    class func itemCreat(image: String, hightImage:String, _ targe: Any?, action: Selector) -> UIBarButtonItem {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: image), for: .normal)
        button.setBackgroundImage(UIImage(named: hightImage), for: .highlighted)
        button.addTarget(targe, action: action, for: .touchUpInside)
        button.frame.size = (button.currentBackgroundImage?.size)!
        return UIBarButtonItem(customView: button)
    }
    
    class func itemCreat(title: String, color: UIColor, _ targe: Any?, action: Selector) -> UIBarButtonItem {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(targe, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    class func itemCreat(title: String, _ targe: Any?, action: Selector) -> UIBarButtonItem {

        return itemCreat(title: title, color: UIColor.white, targe, action: action)
    }
    
}
