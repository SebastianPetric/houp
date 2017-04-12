//
//  PublicGroupThreadsCell.swift
//  Houp
//
//  Created by Sebastian on 05.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class PublicGroupThreadsCell: UICollectionViewCell{

    let widthHeightOfImages: CGFloat = 20
    let seperator = CustomViews.shared.getCustomSeperator(color: UIColor().getLightGreyColor())
    let title = CustomViews.shared.getCustomLabel(text: "Suchtdruck in der Stadt Lirum Larum Löffelstiel. Dies Das Ananas", fontSize: 14, isBold: true, textAlignment: .left , textColor: nil)
    let username = CustomViews.shared.getCustomLabel(text: "Username", fontSize: 12, isBold: false, textAlignment: .left , textColor: nil)
    let date = CustomViews.shared.getCustomLabel(text: "12.02.2017", fontSize: 12, isBold: false, textAlignment: .right, textColor: nil)
    let notificationImage = CustomViews.shared.getCustomImageView(imageName: "notification_icon", cornerRadius: 10, isUserInteractionEnabled: false, imageColor: nil, borderColor: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(seperator)
        addSubview(title)
        addSubview(username)
        addSubview(date)
        addSubview(notificationImage)
        backgroundColor = .white
        setUpSubViews()
    }
    
    func setUpSubViews(){
        username.addConstraintsWithConstants(top: topAnchor, right: nil, bottom: nil, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 100, height: 20)
        date.addConstraintsWithConstants(top: topAnchor, right: notificationImage.leftAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: 70, height: 20)
        title.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 15, bottomConstant: 5, leftConstant: 15, width: 0, height: 40)
        notificationImage.addConstraintsWithConstants(top: topAnchor, right: rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: self.widthHeightOfImages, height: self.widthHeightOfImages)
        seperator.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
