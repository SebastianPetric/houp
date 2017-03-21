//
//  UIViewExtension.swift
//  Houp
//
//  Created by Sebastian on 17.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension UIView{

    func addConstraintsWithConstants(top: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, centerX: NSLayoutXAxisAnchor?, centerY: NSLayoutYAxisAnchor?, topConstant: CGFloat = 0, rightConstant: CGFloat = 0, bottomConstant: CGFloat = 0, leftConstant: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let topAnch = top{
            if(topConstant > 0){
            topAnchor.constraint(equalTo: topAnch, constant: topConstant).isActive = true
            }else{
                topAnchor.constraint(equalTo: topAnch).isActive = true
            }
        }
        
        if let rightAnch = right{
            if(rightConstant > 0){
            rightAnchor.constraint(equalTo: rightAnch, constant: -rightConstant).isActive = true
            }else{
            rightAnchor.constraint(equalTo: rightAnch).isActive = true
            }
        }
        
        if let bottomAnch = bottom{
            if(bottomConstant > 0){
            bottomAnchor.constraint(equalTo: bottomAnch, constant: -bottomConstant).isActive = true
            }else{
            bottomAnchor.constraint(equalTo: bottomAnch).isActive = true
            }
        }
        
        if let leftAnch = left{
            if(leftConstant > 0){
            leftAnchor.constraint(equalTo: leftAnch, constant: leftConstant).isActive = true
            }else{
            leftAnchor.constraint(equalTo: leftAnch).isActive = true
            }
        }
        
        if let centerXAnch = centerX{
        centerXAnchor.constraint(equalTo: centerXAnch).isActive = true
        }
        
        if let centerYAnch = centerY{
        centerYAnchor.constraint(equalTo: centerYAnch).isActive = true
        }
        
        if(width > 0){
        widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if(height > 0){
        heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
