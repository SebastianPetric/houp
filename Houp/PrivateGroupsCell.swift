//
//  PrivateGroupsCell.swift
//  Houp
//
//  Created by Sebastian on 30.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class PrivateGroupsCell: UICollectionViewCell{

    var privateGroupCollectionDelegate: PrivateGroupCollectionViewController?
    var privateGroup: PrivateGroup?{
        didSet{
            if let name = privateGroup?.nameOfGroup{
            nameOfGroup.text = name
            }
            if let location = privateGroup?.location{
                locationOfMeeting.text = location
            }
            if let secretID = privateGroup?.secretID{
                secretGroupID.text = "GeheimID: \(secretID)"
            }
            if let time = privateGroup?.timeOfMeeting{
                self.timeOfMeeting.text = "\(time.getTimePart()) Uhr"
            }
            if let numberOfThreads = privateGroup?.threadIDs{
                self.threadsLabel.text = "\(numberOfThreads.count)"
            }
            if let numberOfMembers = privateGroup?.memberIDs{
                self.usersInGroupLabel.text = "\(numberOfMembers.count)"
            }
            if let dayOfMeeting = privateGroup?.dayOfMeeting{
                self.dayOfMeeting.text = dayOfMeeting
            }
            if let name = privateGroup?.nameOfGroup{
                nameOfGroup.text = name
            }
            if let hasUpdated = privateGroup?.hasBeenUpdated{
                if(hasUpdated){
                    notificationImage.image = notificationImage.image?.withRenderingMode(.alwaysTemplate)
                    notificationImage.tintColor = UIColor().getMainColor()
                }else{
                    notificationImage.image = notificationImage.image?.withRenderingMode(.alwaysTemplate)
                    notificationImage.tintColor = .black
                }
            }
            if((privateGroup?.groupRequestIDs?.count)! > 0 && UserDefaults.standard.string(forKey: GetString.userID.rawValue) == privateGroup?.adminID){
                usersInGroupButton.tintColor = UIColor().getMainColor()
            }else{
                usersInGroupButton.tintColor = .black
            }
            
        }
    }
    
    var widthHeightOfImageViews: CGFloat = 20
    
    let seperator = CustomViews.shared.getCustomSeperator(color: UIColor().getLightGreyColor())
    let seperatorText = CustomViews.shared.getCustomSeperator(color: .black)
    let nameOfGroup = CustomViews.shared.getCustomLabel(text: "AA Regionalgruppe", fontSize: 14, numberOfLines: 2, isBold: true, textAlignment: .left, textColor: nil)
    let locationOfMeeting = CustomViews.shared.getCustomLabel(text: "Weingarten, Siemensstraße 28", fontSize: 12, numberOfLines: 2, isBold: false, textAlignment: .left, textColor: nil)
    let dayOfMeeting = CustomViews.shared.getCustomLabel(text: "Jeden 3. Donnerstag im geraden Monat", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .left, textColor: nil)
    let timeOfMeeting = CustomViews.shared.getCustomLabel(text: "19:30 Uhr", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .left, textColor: nil)
    let secretGroupID = CustomViews.shared.getCustomLabel(text: "#GeheimeID", fontSize: 12, numberOfLines: 1, isBold: true, textAlignment: .left, textColor: nil)
    let threadsLabel = CustomViews.shared.getCustomLabel(text: "1000", fontSize: 12, numberOfLines: 1, isBold: true, textAlignment: .right, textColor: nil)
    let threadsImage = CustomViews.shared.getCustomImageView(imageName: "thread_icon", cornerRadius: 10, isUserInteractionEnabled: false, imageColor: nil, borderColor: .white)
    let usersInGroupLabel = CustomViews.shared.getCustomLabel(text: "1000", fontSize: 12, numberOfLines: 1, isBold: true, textAlignment: .right, textColor: nil)
    let usersInGroupButton = CustomViews.shared.getCustomButtonWithImage(imageName: "users_private_icon", backgroundColor: .white, imageColor: .black, radius: nil, borderColor: .white)
    let notificationImage = CustomViews.shared.getCustomImageView(imageName: "notification_icon", cornerRadius: 0, isUserInteractionEnabled: false, imageColor: nil, borderColor: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(seperator)
        addSubview(nameOfGroup)
        addSubview(locationOfMeeting)
        addSubview(dayOfMeeting)
        addSubview(timeOfMeeting)
        addSubview(secretGroupID)
        addSubview(threadsLabel)
        addSubview(threadsImage)
        addSubview(usersInGroupLabel)
        addSubview(usersInGroupButton)
        usersInGroupButton.addTarget(self, action: #selector(handleUsersInGroup), for: .touchUpInside)
        addSubview(notificationImage)
        addSubview(seperatorText)
        setUpSubViews()
    }
    
    private func setUpSubViews(){
        
        notificationImage.addConstraintsWithConstants(top: topAnchor, right: rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: self.widthHeightOfImageViews, height: self.widthHeightOfImageViews)
        threadsImage.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: centerYAnchor, topConstant: 0, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: self.widthHeightOfImageViews, height: self.widthHeightOfImageViews)
        threadsLabel.addConstraintsWithConstants(top: nil, right: threadsImage.leftAnchor, bottom: nil, left: nil, centerX: nil, centerY: centerYAnchor, topConstant: 0, rightConstant: 5, bottomConstant: 0, leftConstant: 0, width: 30, height: self.widthHeightOfImageViews)
        usersInGroupButton.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: bottomAnchor, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 15, bottomConstant: 15, leftConstant: 0, width: self.widthHeightOfImageViews, height: self.widthHeightOfImageViews)
        usersInGroupLabel.addConstraintsWithConstants(top: nil, right: usersInGroupButton.leftAnchor, bottom: bottomAnchor, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 5, bottomConstant: 15, leftConstant: 0, width: 30, height: self.widthHeightOfImageViews)
        
    nameOfGroup.addConstraintsWithConstants(top: topAnchor, right: nil, bottom: nil, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 200, height: 15)
    locationOfMeeting.addConstraintsWithConstants(top: nameOfGroup.bottomAnchor, right: threadsLabel.leftAnchor, bottom: nil, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 0, height: 15)
    timeOfMeeting.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: nil, bottom: nil, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 60, height: 15)
    seperatorText.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: nil, bottom: nil, left: timeOfMeeting.rightAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0.5, height: 15)
    dayOfMeeting.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: threadsLabel.leftAnchor, bottom: nil, left: seperatorText.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 15, bottomConstant: 0, leftConstant: 5, width: 0, height: 15)
    secretGroupID.addConstraintsWithConstants(top: timeOfMeeting.bottomAnchor, right: nil, bottom: nil, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 130.5, height: 15)
    seperator.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
