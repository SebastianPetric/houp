//
//  PrivateGroupRequestsAndMembersList.swift
//  Houp
//
//  Created by Sebastian on 07.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class PrivateGroupRequestAndMembersList: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    var widthHeightOfImageViews: CGFloat = 20
    let membersCellID = "membersCellID"
    let sectionHeaderID = "sectionHeader"
    
    var TestList: [[Test]] = [
        [Test(type: 0, testUsername: "maxi"),Test(type: 0, testUsername: "penis"),Test(type: 0, testUsername: "doris"),Test(type: 0, testUsername: "sep"),Test(type: 0, testUsername: "pussi"),Test(type: 0, testUsername: "dolo"),Test(type: 0, testUsername: "bem"),Test(type: 0, testUsername: "bums"),Test(type: 0, testUsername: "votzi"),Test(type: 0, testUsername: "karotti")],
        [Test(type: 1, testUsername: "maxi"),Test(type: 1, testUsername: "penis"),Test(type: 1, testUsername: "doris")]
    ]
    
    let infoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let seperatorText = CustomViews.shared.getCustomSeperator(color: .black)
    let nameOfGroup = CustomViews.shared.getCustomLabel(text: "AA Regionalgruppe", fontSize: 14, isBold: true, textAlignment: .left, textColor: nil)
    let locationOfMeeting = CustomViews.shared.getCustomLabel(text: "Weingarten, Siemensstraße 28", fontSize: 12, isBold: false, textAlignment: .left, textColor: nil)
    let dayOfMeeting = CustomViews.shared.getCustomLabel(text: "Mittwochs", fontSize: 12, isBold: false, textAlignment: .left, textColor: nil)
    let dateOfMeeting = CustomViews.shared.getCustomLabel(text: "19:30 Uhr", fontSize: 12, isBold: false, textAlignment: .left, textColor: nil)
    let secretGroupID = CustomViews.shared.getCustomLabel(text: "#GeheimeID", fontSize: 12, isBold: true, textAlignment: .left, textColor: nil)
    let editButton = CustomViews.shared.getCustomImageView(imageName: "edit_icon", cornerRadius: 0, isUserInteractionEnabled: false, imageColor: nil, borderColor: .white)
    let seperatorMembers = CustomViews.shared.getCustomSeperator(color: UIColor().getSecondColor())

    
    lazy var membersCollectionView: UICollectionView = {
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
        view.backgroundColor = .red
        self.title = "Mitglieder"
        
        infoContainer.addSubview(nameOfGroup)
        infoContainer.addSubview(locationOfMeeting)
        infoContainer.addSubview(dateOfMeeting)
        infoContainer.addSubview(seperatorText)
        infoContainer.addSubview(dayOfMeeting)
        infoContainer.addSubview(secretGroupID)
        infoContainer.addSubview(editButton)
        view.addSubview(infoContainer)
        view.addSubview(seperatorMembers)
        view.addSubview(membersCollectionView)
        membersCollectionView.register(PrivateGroupRequestsAndMembersCell.self, forCellWithReuseIdentifier: membersCellID)
        membersCollectionView.register(PrivateGroupRequestsAndMembersHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderID)
        setUpSubViews()
    }
    
    func setUpSubViews(){
        infoContainer.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 105)
        nameOfGroup.addConstraintsWithConstants(top: infoContainer.topAnchor, right: nil, bottom: nil, left: infoContainer.leftAnchor, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 200, height: 15)
        locationOfMeeting.addConstraintsWithConstants(top: nameOfGroup.bottomAnchor, right: nil, bottom: nil, left: infoContainer.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 200, height: 15)
        dateOfMeeting.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: nil, bottom: nil, left: infoContainer.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 60, height: 15)
        seperatorText.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: nil, bottom: nil, left: dateOfMeeting.rightAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0.5, height: 15)
        dayOfMeeting.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: nil, bottom: nil, left: seperatorText.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 5, width: 70, height: 15)
        secretGroupID.addConstraintsWithConstants(top: dateOfMeeting.bottomAnchor, right: nil, bottom: nil, left: infoContainer.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 130.5, height: 15)
        editButton.addConstraintsWithConstants(top: infoContainer.topAnchor, right: infoContainer.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: self.widthHeightOfImageViews, height: self.widthHeightOfImageViews)
        seperatorMembers.addConstraintsWithConstants(top: infoContainer.bottomAnchor, right: infoContainer.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 1)
        membersCollectionView.addConstraintsWithConstants(top: seperatorMembers.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 0)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: membersCellID, for: indexPath) as! PrivateGroupRequestsAndMembersCell
        cell.username.text = TestList[indexPath.section][indexPath.row].testUsername
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TestList[section].count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var header: String = ""
        if(indexPath.section == 0){
        header = "Requests"
        }else{
        header = "Mitglieder"
        }
        let secheader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderID, for: indexPath) as! PrivateGroupRequestsAndMembersHeader
            secheader.sectionHeader.text = header
            return secheader
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 20)
    }
}
