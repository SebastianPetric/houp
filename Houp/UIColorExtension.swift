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
}
