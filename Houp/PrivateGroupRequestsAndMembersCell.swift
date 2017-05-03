//
//  PrivateGroupRequestsAndMembersCell.swift
//  Houp
//
//  Created by Sebastian on 07.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class PrivateGroupRequestsAndMembersCell: UICollectionViewCell{

    var privateGroup: PrivateGroup?
    
    var isMember: Bool?{
        didSet{
            if let isMem = isMember{
                if(isMem){
                    if(user?.uid == UserDefaults.standard.string(forKey: GetString.userID.rawValue) || privateGroup?.adminID == UserDefaults.standard.string(forKey: GetString.userID.rawValue)){
                    acceptButton.isHidden = true
                    denyButton.addTarget(self, action: #selector(leaveGroup), for: .touchUpInside)
                    }else{
                    acceptButton.isHidden = true
                    denyButton.isHidden = true
                    }
                }else{
                    acceptButton.addTarget(self, action: #selector(acceptUser), for: .touchUpInside)
                    denyButton.addTarget(self, action: #selector(denyUser), for: .touchUpInside)
                }
            }
        }
    
    }
    
    var user: UserObject?{
        didSet{
            if let usern = user?.userName{
                self.username.text = usern
            }
            if let mail = user?.email{
                self.mail.text = mail
            }
        }
    }
    
    
    var profileImageWidthHeight: CGFloat = 40
    var acceptDenyButtonWidthHeight: CGFloat = 25
    
    let profileImage = CustomViews.shared.getCustomImageView(imageName: "profile_image", cornerRadius: 20, isUserInteractionEnabled: false, imageColor: .black, borderColor: UIColor().getSecondColor())
    var username = CustomViews.shared.getCustomLabel(text: "Username", fontSize: 16, isBold: true, textAlignment: .left, textColor: .black)
    let mail = CustomViews.shared.getCustomLabel(text: "test.at.gmx.de", fontSize: 12, isBold: false, textAlignment: .left, textColor: UIColor(red: 150, green: 150, blue: 150, alphaValue: 1))
    let acceptButton = CustomViews.shared.getCustomButtonWithImage(imageName: GetString.accept_icon.rawValue, backgroundColor: .white, imageColor: .black, radius: 12.5, borderColor: UIColor().getSecondColor())
    let denyButton = CustomViews.shared.getCustomButtonWithImage(imageName: GetString.deny_icon.rawValue, backgroundColor: .white, imageColor: .black, radius: 12.5, borderColor: UIColor().getSecondColor())
    let seperator = CustomViews.shared.getCustomSeperator(color: UIColor().getLightGreyColor())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImage)
        addSubview(username)
        addSubview(mail)
        addSubview(acceptButton)
        addSubview(denyButton)
        addSubview(seperator)
        setUpSubViews()
    }
    
    func setUpSubViews(){
    profileImage.addConstraintsWithConstants(top: nil, right: nil, bottom: nil, left: leftAnchor, centerX: nil, centerY: centerYAnchor, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: self.profileImageWidthHeight, height: self.profileImageWidthHeight)
    username.addConstraintsWithConstants(top: profileImage.topAnchor, right: nil, bottom: nil, left: profileImage.rightAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 200, height: 20)
    mail.addConstraintsWithConstants(top: username.bottomAnchor, right: nil, bottom: nil, left: profileImage.rightAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 200, height: 20)
    denyButton.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: centerYAnchor, topConstant: 0, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: self.acceptDenyButtonWidthHeight, height: self.acceptDenyButtonWidthHeight)
    acceptButton.addConstraintsWithConstants(top: nil, right: denyButton.leftAnchor, bottom: nil, left: nil, centerX: nil, centerY: centerYAnchor, topConstant: 0, rightConstant: 7.5, bottomConstant: 0, leftConstant: 0, width: self.acceptDenyButtonWidthHeight, height: self.acceptDenyButtonWidthHeight)
    seperator.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 1)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func denyUser(){
        if let error = DBConnection.shared.denyRequest(uID: (user?.uid)!, gID: (self.privateGroup?.pgid)!){
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func acceptUser(){
        if let error = DBConnection.shared.acceptRequest(uID: (user?.uid)!, gID: (self.privateGroup?.pgid)!){
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func leaveGroup(){
        if let error = DBConnection.shared.leaveGroup(uID: (user?.uid)!, gID: (self.privateGroup?.pgid)!){
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }

}
