//
//  GroupCommentsCell.swift
//  Houp
//
//  Created by Sebastian on 04.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class GroupCommentsCell: UICollectionViewCell{
    
    var comment: Comment?{
        didSet{
            if let message = comment?.message{
                self.message.text = message
            }
            if let username = comment?.userName{
                self.username.text = username
            }
            if let date = comment?.dateObject{
                self.date.text = date.getDatePart()
            }
            if let time = comment?.dateObject{
                self.time.text = time.getTimePart()
            }
            if let likes = comment?.likeIDs?.count{
                self.upvoteLabel.text = "\(likes)"
            }
            if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
                if let hasBeenLiked = comment?.likeIDs?.contains(userID){
                    if(hasBeenLiked){
                        self.upvoteButton.tintColor = UIColor().getThirdColor()
                    }else{
                        self.upvoteButton.tintColor = .black
                    }
                }
            }
        }
    }
    
    let seperatorCell = CustomViews.shared.getCustomSeperator(color: UIColor().getLightGreyColor())
    let username = CustomViews.shared.getCustomLabel(text: "Username", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .left, textColor: nil)
    let date = CustomViews.shared.getCustomLabel(text: "03.02.2017", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .right, textColor: nil)
    let seperatorTime = CustomViews.shared.getCustomSeperator(color: .black)
    let time = CustomViews.shared.getCustomLabel(text: "19:34", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .right, textColor: nil)
    let message = CustomViews.shared.getCustomTextView(text: "Hallo leute,", fontSize: 12, textAlignment: .left, textColor: .black, backGroundColor: .white)
    let upvoteLabel = CustomViews.shared.getCustomLabel(text: "122", fontSize: 12, numberOfLines: 1, isBold: true, textAlignment: .center, textColor: .black)
    let upvoteButton = CustomViews.shared.getCustomButtonWithImage(imageName: "upvote_icon", backgroundColor: .white, imageColor: .black, radius: nil, borderColor: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(seperatorCell)
        addSubview(username)
        addSubview(date)
        addSubview(seperatorTime)
        addSubview(time)
        addSubview(message)
        addSubview(upvoteLabel)
        addSubview(upvoteButton)
        upvoteButton.addTarget(self, action: #selector(handleUpvote), for: .touchUpInside)
        setUpSubViews()
    }
    
    func setUpSubViews(){
        seperatorCell.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 1)
        username.addConstraintsWithConstants(top: topAnchor, right: nil, bottom: nil, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 100, height: 20)
        time.addConstraintsWithConstants(top: topAnchor, right: rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: 35, height: 20)
        seperatorTime.addConstraintsWithConstants(top: topAnchor, right: time.leftAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 5, bottomConstant: 0, leftConstant: 0, width: 1, height: 20)
        date.addConstraintsWithConstants(top: topAnchor, right: seperatorTime.leftAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 5, bottomConstant: 0, leftConstant: 0, width: 70, height: 20)
        upvoteButton.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: centerYAnchor, topConstant: 0, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: 20, height: 20)
        upvoteLabel.addConstraintsWithConstants(top: upvoteButton.bottomAnchor, right: rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 12.5, bottomConstant: 0, leftConstant: 0, width: 25, height: 20)
        message.addConstraintsWithConstants(top: username.bottomAnchor, right: upvoteButton.leftAnchor, bottom: nil, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 5, bottomConstant: 0, leftConstant: 15, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

