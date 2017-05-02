//
//  PrivateGroupsCell.swift
//  Houp
//
//  Created by Sebastian on 30.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class PrivateGroupsCell: UICollectionViewCell{

    
    
//    var post: Post?{
//        didSet{
//            
//            if let name = post?.name{
//                nameLabel.text = post?.name
//            }
//            
//            if let postText = post?.postText{
//                postLabel.text = postText
//            }
//            
//            if let profileImage = post?.profileImageName {
//                profileImageView.image = UIImage(named: profileImage)
//            }
//            
//            if let location = post?.location{
//                if let date = post?.date{
//                    infoLabel.text = "\(date) • \(location)"
//                }
//            }
//            
//            if let likes = post?.numLikes{
//                likesCount.text = "\(likes) Likes"
//            }
//            
//            if let comments = post?.numComments{
//                commentCount.text = "\(comments) Kommentare"
//            }
//            
//            if let postImgUrl = post?.postImage{
//                if let image = imageCache.object(forKey: postImgUrl as AnyObject) as? UIImage{
//                    self.postImage.image = image
//                }else{
//                    var request = URLRequest(url: URL(string: postImgUrl)!)
//                    URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
//                        if error != nil{
//                            print(error)
//                            return
//                        }else{
//                            
//                            let image = UIImage(data: data!)
//                            imageCache.setObject(image!, forKey: postImgUrl as AnyObject)
//                            let backgroundQueue = DispatchQueue(label: "com.app.queue",
//                                                                qos: .background,
//                                                                target: nil)
//                            backgroundQueue.async {
//                                self.postImage.image = image
//                            }
//                        }
//                    }).resume()
//                }
//            }
//        }
//    }

    
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
                self.timeOfMeeting.text = "\(Date().getFormattedStringFromDate(time: time)) Uhr"
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
                    //notificationImage.backgroundColor = .yellow
                }else{
                    //notificationImage.backgroundColor = .black
                }
            }
        }
    }
    
    var widthHeightOfImageViews: CGFloat = 20
    
    let seperator = CustomViews.shared.getCustomSeperator(color: UIColor().getLightGreyColor())
    
    let seperatorText = CustomViews.shared.getCustomSeperator(color: .black)
    
    let nameOfGroup = CustomViews.shared.getCustomLabel(text: "AA Regionalgruppe", fontSize: 14, isBold: true, textAlignment: .left, textColor: nil)

    
    let locationOfMeeting = CustomViews.shared.getCustomLabel(text: "Weingarten, Siemensstraße 28", fontSize: 12, isBold: false, textAlignment: .left, textColor: nil)
    
    let dayOfMeeting = CustomViews.shared.getCustomLabel(text: "Jeden 3. Donnerstag im geraden Monat", fontSize: 12, isBold: false, textAlignment: .left, textColor: nil)
    
    let timeOfMeeting = CustomViews.shared.getCustomLabel(text: "19:30 Uhr", fontSize: 12, isBold: false, textAlignment: .left, textColor: nil)
    
    let secretGroupID = CustomViews.shared.getCustomLabel(text: "#GeheimeID", fontSize: 12, isBold: true, textAlignment: .left, textColor: nil)
    
    let threadsLabel = CustomViews.shared.getCustomLabel(text: "1000", fontSize: 12, isBold: true, textAlignment: .right, textColor: nil)
    let threadsImage = CustomViews.shared.getCustomImageView(imageName: "thread_icon", cornerRadius: 0, isUserInteractionEnabled: false, imageColor: nil, borderColor: .white)

    let usersInGroupLabel = CustomViews.shared.getCustomLabel(text: "1000", fontSize: 12, isBold: true, textAlignment: .right, textColor: nil)
    let usersInGroupImage = CustomViews.shared.getCustomImageView(imageName: "users_private_icon", cornerRadius: 0, isUserInteractionEnabled: false, imageColor: nil, borderColor: .white)
    
    //let notificationLable = CustomViews.shared.getCustomLabel(text: "1000", fontSize: 12, isBold: true, centerText: false, textColor: UIColor().getSecondColor())
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
        addSubview(usersInGroupImage)
        //addSubview(notificationLable)
        addSubview(notificationImage)
        addSubview(seperatorText)
        setUpSubViews()
    }
    
    private func setUpSubViews(){
    
        notificationImage.addConstraintsWithConstants(top: topAnchor, right: rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: self.widthHeightOfImageViews, height: self.widthHeightOfImageViews)
        //notificationLable.addConstraintsWithConstants(top: topAnchor, right: notificationImage.leftAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 5, bottomConstant: 0, leftConstant: 0, width: 30, height: self.widthHeightOfImageViews)
        threadsImage.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: centerYAnchor, topConstant: 0, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: self.widthHeightOfImageViews, height: self.widthHeightOfImageViews)
        threadsLabel.addConstraintsWithConstants(top: nil, right: threadsImage.leftAnchor, bottom: nil, left: nil, centerX: nil, centerY: centerYAnchor, topConstant: 0, rightConstant: 5, bottomConstant: 0, leftConstant: 0, width: 30, height: self.widthHeightOfImageViews)
        usersInGroupImage.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: bottomAnchor, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 15, bottomConstant: 15, leftConstant: 0, width: self.widthHeightOfImageViews, height: self.widthHeightOfImageViews)
        usersInGroupLabel.addConstraintsWithConstants(top: nil, right: usersInGroupImage.leftAnchor, bottom: bottomAnchor, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 5, bottomConstant: 15, leftConstant: 0, width: 30, height: self.widthHeightOfImageViews)
        
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
