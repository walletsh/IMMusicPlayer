//
//  UIColor+Extension.swift
//  IMMusicPlayer
//
//  Created by imwallet on 16/12/7.
//  Copyright © 2016年 imWallet. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat) {
        self.init(red: r/255.0 ,green: g/255.0 ,blue: b/255.0 ,alpha:1.0)
    }
    
    /// 随机颜色
    class func randomColor() -> UIColor {
        return UIColor.init(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    
    /// 把#ffffff颜色转为UIColor
    class func setHexStringColor(_ hexString: String) -> UIColor {
        return setHexString(hexString, alpha: 1)
    }
    
    /// 把#ffffff颜色转为UIColor
    class func setHexString(_ hexString: String, alpha: CGFloat) -> UIColor {
        //删除字符串中的空格
        var cString = (hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)).uppercased()
        
        // String should be 6 or 8 characters
        if cString.characters.count < 6 {
            return UIColor.clear
        }
        
        // strip 0X if it appears
        //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
        let prefix0X = "0X"
        if cString.hasPrefix(prefix0X) {
            let fromIndex = prefix0X.index(prefix0X.startIndex, offsetBy: 2)
            cString = cString.substring(from: fromIndex)
        }
        
        //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
        let prefix = "#"
        if cString.hasPrefix(prefix) {
            let fromIndex = prefix.index(prefix.startIndex, offsetBy: 1)
            cString = cString.substring(from: fromIndex)
        }
        
        if cString.characters.count != 6 {
            return UIColor.clear
        }
        
        // Separate into r, g, b substrings
        // r
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = cString.substring(to: rIndex)
        // g
        let otherString = cString.substring(from: rIndex)
        let gIndex = cString.index(otherString.startIndex, offsetBy: 2)
        let gString = cString.substring(to: gIndex)
        // b
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bString = cString.substring(from:bIndex)
        
        // Scan values
        var r: CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
}



