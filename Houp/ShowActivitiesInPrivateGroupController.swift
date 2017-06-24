//
//  ShowActivitiesInPrivateGroupController.swift
//  Houp
//
//  Created by Sebastian on 13.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class ShowActivitiesInPrivateGroupController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
//    deinit {
//        liveQuery?.removeObserver(self, forKeyPath: "rows")
//    }
    
    var liveQuery: CBLLiveQuery?
    
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
            if let dayOfMeeting = privateGroup?.dayOfMeeting{
                self.dayOfMeeting.text = dayOfMeeting
            }
            if let name = privateGroup?.nameOfGroup{
                nameOfGroup.text = name
            }
        }
    }
    
    var widthHeightOfImageViews: CGFloat = 20
    let activityCellID = "activityCellID"
    
    var activityList = [Activity]()
    
    let infoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor().getSecondColor()
        return view
    }()
    let seperatorText = CustomViews.shared.getCustomSeperator(color: .white)
    let nameOfGroup = CustomViews.shared.getCustomLabel(text: "AA Regionalgruppe", fontSize: 14, numberOfLines: 1, isBold: true, textAlignment: .left, textColor: .white)
    let locationOfMeeting = CustomViews.shared.getCustomLabel(text: "Weingarten, Siemensstraße 28", fontSize: 12, numberOfLines: 2, isBold: false, textAlignment: .left, textColor: .white)
    let dayOfMeeting = CustomViews.shared.getCustomLabel(text: "Jeden 3. Donnerstag im geraden Monat", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .left, textColor: .white)
    let timeOfMeeting = CustomViews.shared.getCustomLabel(text: "19:30 Uhr", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .left, textColor: .white)
    let secretGroupID = CustomViews.shared.getCustomLabel(text: "#GeheimeID", fontSize: 12, numberOfLines: 1, isBold: true, textAlignment: .left, textColor: .white)
    //let editButton = CustomViews.shared.getCustomImageView(imageName: "edit_icon", cornerRadius: 0, isUserInteractionEnabled: false, imageColor: nil, borderColor: .white)
    let seperatorMembers = CustomViews.shared.getCustomSeperator(color: UIColor().getSecondColor())
    
    
    lazy var activityCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let members = UICollectionView(frame: .zero, collectionViewLayout: layout)
        members.dataSource = self
        members.delegate = self
        members.backgroundColor = .white
        return members
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getTopicActivities(groupID: (privateGroup?.pgid)!)
        TempStorageAndCompare.shared.activitiesInPrivateGroupDelegate = self
        infoContainer.addSubview(nameOfGroup)
        infoContainer.addSubview(locationOfMeeting)
        infoContainer.addSubview(timeOfMeeting)
        infoContainer.addSubview(seperatorText)
        infoContainer.addSubview(dayOfMeeting)
        infoContainer.addSubview(secretGroupID)
        //infoContainer.addSubview(editButton)
        view.addSubview(infoContainer)
        view.addSubview(seperatorMembers)
        view.addSubview(activityCollectionView)
        activityCollectionView.register(ShowActivitiesInPrivateGroupCell.self, forCellWithReuseIdentifier: activityCellID)
        setUpSubViews()
    }
    
    func setUpSubViews(){
        infoContainer.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 105)
        //editButton.addConstraintsWithConstants(top: infoContainer.topAnchor, right: infoContainer.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: self.widthHeightOfImageViews, height: self.widthHeightOfImageViews)
        nameOfGroup.addConstraintsWithConstants(top: infoContainer.topAnchor, right: nil, bottom: nil, left: infoContainer.leftAnchor, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 200, height: 15)
        locationOfMeeting.addConstraintsWithConstants(top: nameOfGroup.bottomAnchor, right: view.rightAnchor, bottom: nil, left: infoContainer.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 0, height: 15)
        timeOfMeeting.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: nil, bottom: nil, left: infoContainer.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 60, height: 15)
        seperatorText.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: nil, bottom: nil, left: timeOfMeeting.rightAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0.5, height: 15)
        dayOfMeeting.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: view.rightAnchor, bottom: nil, left: seperatorText.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 5, width: 0, height: 15)
        secretGroupID.addConstraintsWithConstants(top: timeOfMeeting.bottomAnchor, right: nil, bottom: nil, left: infoContainer.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 130.5, height: 15)
        seperatorMembers.addConstraintsWithConstants(top: infoContainer.bottomAnchor, right: infoContainer.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 1)
        activityCollectionView.addConstraintsWithConstants(top: seperatorMembers.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: activityCellID, for: indexPath) as! ShowActivitiesInPrivateGroupCell
        cell.activityObject = TempStorageAndCompare.shared.getActivitiesOfGroup(groupID: (self.privateGroup?.pgid)!)[indexPath.row]
        //cell.activityObject = self.activityList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TempStorageAndCompare.shared.getActivitiesOfGroup(groupID: (self.privateGroup?.pgid)!).count
        //return activityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ActivitiesCommentsController()
        //controller.activityObject = activityList[indexPath.row]
        controller.activityObject = TempStorageAndCompare.shared.getActivitiesOfGroup(groupID: (self.privateGroup?.pgid)!)[indexPath.row]
        controller.titleNav = (self.privateGroup?.nameOfGroup)!
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

