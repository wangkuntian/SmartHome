//
//  Extension.swift
//  SmartPhone
//
//  Created by 王坤田 on 2017/11/7.
//  Copyright © 2017年 王坤田. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    
    class func createBarButtonItem(with image : UIImage, and tap : UITapGestureRecognizer, width : CGFloat? = 50 * WidthScale) -> UIBarButtonItem {
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: width!, height: width!)
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        
        let barButtonItem = UIBarButtonItem.init(customView: imageView)
        
        return barButtonItem
    }
}

extension UIColor {
    
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
        
    }
    
    class var leftButtonColor : UIColor {
        
        get {
            
            return UIColor(red: 0.212, green: 0.286, blue: 0.576, alpha: 1.000)
        }
        
    }
    
    class var rightButtonColor : UIColor {
        
        get {
            
            return UIColor(red: 0.106, green: 0.220, blue: 0.404, alpha: 1.000)
        }
        
    }
    
    class var cellColor : UIColor {
        
        get {
            
            return UIColor(red: 0.106, green: 0.220, blue: 0.404, alpha: 1.000)
        }
        
    }
    
    class var textColor : UIColor {
        
        get {
            
            return UIColor(red: 0.749, green: 0.753, blue: 0.835, alpha: 1.000)
        }
        
    }
    
}

extension UIFont {
    
    class func chineseTextFont(with size : CGFloat) -> UIFont? {
        
        
        return UIFont.systemFont(ofSize: size, weight: .ultraLight)
        
    }
    
    class func textFont(with size : CGFloat) -> UIFont? {
        

        return UIFont.init(name: "Avenir Next Condensed", size: size)
        
    }
    
    class func titleFont(with size : CGFloat) -> UIFont? {
        
        
        return UIFont.init(name: "Avenir Next", size: size)
        
    }
    
}

extension String {
    
    public func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            
            return String(subString)
            
        } else {
            return self
        }
    }
}
