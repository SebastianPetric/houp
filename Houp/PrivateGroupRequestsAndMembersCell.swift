//
//  PrivateGroupRequestsAndMembersCell.swift
//  Houp
//
//  Created by Sebastian on 07.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class PrivateGroupRequestsAndMembersCell: UICollectionViewCell{

    var profileImageWidthHeight: CGFloat = 40
    var acceptDenyButtonWidthHeight: CGFloat = 25
    
    let profileImage = CustomViews.shared.getCustomImageView(imageName: "profile_image", cornerRadius: 20, isUserInteractionEnabled: false, imageColor: .black, borderColor: UIColor().getSecondColor())
    var username = CustomViews.shared.getCustomLabel(text: "Username", fontSize: 16, isBold: true, textAlignment: .left, textColor: .black)
    let name = CustomViews.shared.getCustomLabel(text: "Max Mustermann", fontSize: 12, isBold: false, textAlignment: .left, textColor: UIColor(red: 150, green: 150, blue: 150, alphaValue: 1))
    
    let acceptButton = CustomViews.shared.getCustomButtonWithImage(imageName: GetString.accept_icon.rawValue, backgroundColor: .white, imageColor: .black, radius: 12.5, borderColor: UIColor().getSecondColor())
    let denyButton = CustomViews.shared.getCustomButtonWithImage(imageName: GetString.deny_icon.rawValue, backgroundColor: .white, imageColor: .black, radius: 12.5, borderColor: UIColor().getSecondColor())
    let seperator = CustomViews.shared.getCustomSeperator(color: UIColor().getLightGreyColor())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImage)
        addSubview(username)
        addSubview(name)
        addSubview(acceptButton)
        addSubview(denyButton)
        addSubview(seperator)
        setUpSubViews()
    }
    
    func setUpSubViews(){
    profileImage.addConstraintsWithConstants(top: nil, right: nil, bottom: nil, left: leftAnchor, centerX: nil, centerY: centerYAnchor, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: self.profileImageWidthHeight, height: self.profileImageWidthHeight)
    username.addConstraintsWithConstants(top: profileImage.topAnchor, right: nil, bottom: nil, left: profileImage.rightAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 200, height: 20)
    name.addConstraintsWithConstants(top: username.bottomAnchor, right: nil, bottom: nil, left: profileImage.rightAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 200, height: 20)
    denyButton.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: centerYAnchor, topConstant: 0, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: self.acceptDenyButtonWidthHeight, height: self.acceptDenyButtonWidthHeight)
    acceptButton.addConstraintsWithConstants(top: nil, right: denyButton.leftAnchor, bottom: nil, left: nil, centerX: nil, centerY: centerYAnchor, topConstant: 0, rightConstant: 7.5, bottomConstant: 0, leftConstant: 0, width: self.acceptDenyButtonWidthHeight, height: self.acceptDenyButtonWidthHeight)
    seperator.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 1)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
