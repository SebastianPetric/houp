//
//  UIViewExtension.swift
//  Houp
//
//  Created by Sebastian on 17.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension UIView{

    func addConstraintsWithConstants(top: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, topConstant: CGFloat = 0, rightConstant: CGFloat = 0, bottomConstant: CGFloat = 0, leftConstant: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let topAnch = top{
        topAnchor.constraint(equalTo: topAnch, constant: topConstant).isActive = true
        }
        
        if let rightAnch = right{
        rightAnchor.constraint(equalTo: rightAnch, constant: -rightConstant).isActive = true
        }
        
        if let bottomAnch = bottom{
        bottomAnchor.constraint(equalTo: bottomAnch, constant: -bottomConstant).isActive = true
        }
        
        if let leftAnch = left{
        leftAnchor.constraint(equalTo: leftAnch, constant: leftConstant).isActive = true
        }
        
        if(width > 0){
        widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if(height > 0){
        heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
