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
    
    
//    func getMainColor() -> UIColor{
//        return UIColor(red: 101, green: 232, blue: 100, alphaValue: 1)
//    }
//    
//    
//    func getSecondColor() -> UIColor{
//        return UIColor(red: 41, green: 192, blue: 232, alphaValue: 1)
//    }
//    
//    func getThirdColor() -> UIColor{
//        return UIColor(red: 242, green: 135, blue: 5, alphaValue: 1)
//    }

    func getMainColor() -> UIColor{
        return UIColor(red: 134, green: 197, blue: 99, alphaValue: 1)
    }
    
    
    func getSecondColor() -> UIColor{
        return UIColor(red: 100, green: 156, blue: 212, alphaValue: 1)
    }
    
    func getLightSecondColor() -> UIColor{
        return UIColor(red: 100, green: 156, blue: 212, alphaValue: 0.5)
    }
    
    func getThirdColor() -> UIColor{
        return UIColor(red: 227, green: 77, blue: 82, alphaValue: 1)
    }
    
    func getFourthColor() -> UIColor{
        return UIColor(red: 236, green: 218, blue: 110, alphaValue: 1)
    }
    
    func getNotificationColor() -> UIColor{
     return UIColor(red: 255, green: 104, blue: 79, alphaValue: 1)
    }
    
    func getLightGreyColor() -> UIColor{
    return UIColor(red: 229, green: 231, blue: 235, alphaValue: 1)
    }
    
}
