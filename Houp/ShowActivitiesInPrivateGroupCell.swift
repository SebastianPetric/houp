//
//  ShowActivitiesInPrivateGroupCell.swift
//  Houp
//
//  Created by Sebastian on 13.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class ShowActivitiesInPrivateGroupCell: UICollectionViewCell{

    var activityObject: Activity?{
        didSet{
            if let tit = activityObject?.activity{
                title.text = tit
            }
            if let user = activityObject?.userName{
                username.text = user
            }
            if let timeO = activityObject?.timeObject{
                time.text = timeO.getTimePart()
            }
            if let dateO = activityObject?.dateObject{
                date.text = dateO.getDatePart()
            }
            if let likes = activityObject?.likeIDs?.count{
                upvoteLabel.text = "\(likes)"
            }
            if let comm = activityObject?.commentIDs?.count{
                answersLabel.text = "\(comm)"
            }
            if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
                if let hasBeenLiked = activityObject?.likeIDs?.contains(userID){
                    if(hasBeenLiked){
                        self.upvoteButton.tintColor = UIColor().getThirdColor()
                    }else{
                        self.upvoteButton.tintColor = .black
                    }
                }
            }
        }
    }
    let widthHeightOfImages: CGFloat = 20
    var profileImageWidthHeight: CGFloat = 40
    var acceptDenyButtonWidthHeight: CGFloat = 25
    
    let username = CustomViews.shared.getCustomLabel(text: "Username", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .left, textColor: nil)
    let date = CustomViews.shared.getCustomLabel(text: "03.02.2017", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .right, textColor: nil)
    let seperatorTime = CustomViews.shared.getCustomSeperator(color: .black)
    let time = CustomViews.shared.getCustomLabel(text: "19:34", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .right, textColor: nil)
    let title = CustomViews.shared.getCustomLabel(text: "Was machen", fontSize: 20, numberOfLines: 2, isBold: true, textAlignment: .left, textColor: .black)
    let upvoteLabel = CustomViews.shared.getCustomLabel(text: "122", fontSize: 12, numberOfLines: 1, isBold: true, textAlignment: .center, textColor: .black)
    let upvoteButton = CustomViews.shared.getCustomButtonWithImage(imageName: "upvote_icon", backgroundColor: .white, imageColor: .black, radius: nil, borderColor: nil)
    let answersImage = CustomViews.shared.getCustomImageView(imageName: "answers_icon", cornerRadius: 10, isUserInteractionEnabled: false, imageColor: nil, borderColor: .white)
    let answersLabel = CustomViews.shared.getCustomLabel(text: "1000", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .right, textColor: .black)
    let seperator = CustomViews.shared.getCustomSeperator(color: UIColor().getLightGreyColor())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(username)
        addSubview(date)
        addSubview(seperatorTime)
        addSubview(time)
        addSubview(title)
        addSubview(upvoteLabel)
        addSubview(upvoteButton)
        addSubview(answersImage)
        addSubview(answersLabel)
        addSubview(seperator)
        upvoteButton.addTarget(self, action: #selector(handleUpvote), for: .touchUpInside)
        setUpSubViews()
    }
    
    func setUpSubViews(){
        username.addConstraintsWithConstants(top: topAnchor, right: nil, bottom: nil, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 200, height: 20)
        time.addConstraintsWithConstants(top: topAnchor, right: rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 5, bottomConstant: 0, leftConstant: 0, width: 35, height: 20)
        seperatorTime.addConstraintsWithConstants(top: topAnchor, right: time.leftAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 5, bottomConstant: 0, leftConstant: 0, width: 1, height: 20)
        date.addConstraintsWithConstants(top: topAnchor, right: seperatorTime.leftAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 5, bottomConstant: 0, leftConstant: 0, width: 70, height: 20)
        title.addConstraintsWithConstants(top: date.bottomAnchor, right: upvoteButton.leftAnchor, bottom: nil, left: leftAnchor, centerX: nil, centerY: centerYAnchor, topConstant: 0, rightConstant: 15, bottomConstant: 0, leftConstant: 15, width: 0, height: 0)
        upvoteButton.addConstraintsWithConstants(top: date.bottomAnchor, right: rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: 20, height: 20)
        upvoteLabel.addConstraintsWithConstants(top: upvoteButton.bottomAnchor, right: rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 12.5, bottomConstant: 0, leftConstant: 0, width: 25, height: 20)
        answersImage.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: bottomAnchor, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 15, bottomConstant: 5, leftConstant: 0, width: self.widthHeightOfImages, height: self.widthHeightOfImages)
        answersLabel.addConstraintsWithConstants(top: nil, right: answersImage.leftAnchor, bottom: bottomAnchor, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 5, bottomConstant: 5, leftConstant: 0, width: 70, height: self.widthHeightOfImages)
        seperator.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleUpvote(){
        if(self.upvoteButton.tintColor == .black){
            if let error = DBConnection.shared.likeActivity(aID: (activityObject?.aid)!){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }else{
                self.upvoteButton.tintColor = UIColor().getThirdColor()
            }
            
        }else{
            if let error = DBConnection.shared.dislikeActivity(aID: (activityObject?.aid)!){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }else{
                self.upvoteButton.tintColor = .black
            }
        }
    }
}
