//
//  ActivityCollectionCellHighlighted.swift
//  Houp
//
//  Created by Sebastian on 07.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit


class ActivityCollectionCellHighlighted: UICollectionViewCell{
    
    let dateOfActivity = CustomViews.shared.getCustomLabel(text: "10.07.2017", fontSize: 12, isBold: false, textAlignment: .left, textColor: .black)
    let activity = CustomViews.shared.getCustomLabel(text: "Schwimmen gehen", fontSize: 15, isBold: true, textAlignment: .left, textColor: .black)
    let timeOfActivity = CustomViews.shared.getCustomLabel(text: "10:35", fontSize: 12, isBold: false, textAlignment: .left, textColor: .black)
    let locationOfActivity = CustomViews.shared.getCustomLabel(text: "Hallenbad Weingarten", fontSize: 12, isBold: false, textAlignment: .left, textColor: .black)
    let seperator = CustomViews.shared.getCustomSeperator(color: .black)
    let seperatorComments = CustomViews.shared.getCustomSeperator(color: .black)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor().getSecondColor()
        addSubview(dateOfActivity)
        addSubview(activity)
        addSubview(timeOfActivity)
        addSubview(locationOfActivity)
        addSubview(seperator)
        addSubview(seperatorComments)
        setUpSubViews()
    }
    
    func setUpSubViews(){
        locationOfActivity.addConstraintsWithConstants(top: topAnchor, right: dateOfActivity.leftAnchor, bottom: nil, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 5, bottomConstant: 0, leftConstant: 15, width: 0, height: 20)
        timeOfActivity.addConstraintsWithConstants(top: topAnchor, right: rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: 35, height: 20)
        seperator.addConstraintsWithConstants(top: topAnchor, right: timeOfActivity.leftAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 5, bottomConstant: 0, leftConstant: 0, width: 1, height: 20)
        dateOfActivity.addConstraintsWithConstants(top: topAnchor, right: seperator.leftAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 5, bottomConstant: 0, leftConstant: 0, width: 70, height: 20)
        activity.addConstraintsWithConstants(top: locationOfActivity.bottomAnchor, right: rightAnchor, bottom: nil, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 5, bottomConstant: 0, leftConstant: 15, width: 0, height: 20)
        seperatorComments.addConstraintsWithConstants(top: nil, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 1)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
