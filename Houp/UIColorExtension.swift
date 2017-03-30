//
//  UIColorExtension.swift
//  Houp
//
//  Created by Sebastian on 17.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension UIColor{

    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat, alphaValue: CGFloat) {
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: alphaValue)
    }
    
    func getTextViewBorderColor() -> CGColor{
    return UIColor(red: 130, green: 130, blue: 130, alphaValue: 0.5).cgColor
    }
    
    func getMainColor() -> UIColor{
        return UIColor(red: 101, green: 232, blue: 100, alphaValue: 1)
    }
    
    
    func getSecondColor() -> UIColor{
        return UIColor(red: 41, green: 192, blue: 232, alphaValue: 1)
    }
}
