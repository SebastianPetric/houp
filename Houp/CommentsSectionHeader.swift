//
//  CommentsSectionHeader.swift
//  Houp
//
//  Created by Sebastian on 15.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class CommentsSectionHeader: UICollectionReusableView{
    
    let sectionHeader = CustomViews.shared.getCustomLabel(text: "Soso", fontSize: 16, numberOfLines: 1, isBold: true, textAlignment: .left, textColor: .white)
    
    override init(frame: CGRect) {
        print("hallo")
        super.init(frame: frame)
        backgroundColor = UIColor(red: 41, green: 192, blue: 232, alphaValue: 0.5)
        addSubview(sectionHeader)
        sectionHeader.addConstraintsWithConstants(top: nil, right: nil, bottom: nil, left: leftAnchor, centerX: nil, centerY: centerYAnchor, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
