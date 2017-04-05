//
//  PrivateGroupWithCommentsController.swift
//  Houp
//
//  Created by Sebastian on 03.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class PrivateGroupWithThreadsController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{

    let threadsCellID = "threadsCellID"
    var widthHeightOfImageViews: CGFloat = 20

    lazy var threadsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let threads = UICollectionView(frame: .zero, collectionViewLayout: layout)
        threads.dataSource = self
        threads.delegate = self
        threads.backgroundColor = .white
        return threads
    }()

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
    let usersInGroupLabel = CustomViews.shared.getCustomLabel(text: "1000", fontSize: 12, isBold: false, textAlignment: .right, textColor: nil)
    let usersInGroupImage = CustomViews.shared.getCustomImageView(imageName: "users_private_icon", cornerRadius: 0, isUserInteractionEnabled: false, imageColor: nil, borderColor: .white)
    let editButton = CustomViews.shared.getCustomImageView(imageName: "edit_icon", cornerRadius: 0, isUserInteractionEnabled: false, imageColor: nil, borderColor: .white)
    let seperatorComments = CustomViews.shared.getCustomSeperator(color: UIColor().getSecondColor())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Themen"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.createIcon.rawValue), style: .plain, target: self, action: #selector(handleCreateThread))
        infoContainer.addSubview(nameOfGroup)
        infoContainer.addSubview(locationOfMeeting)
        infoContainer.addSubview(dateOfMeeting)
        infoContainer.addSubview(seperatorText)
        infoContainer.addSubview(dayOfMeeting)
        infoContainer.addSubview(secretGroupID)
        infoContainer.addSubview(editButton)
        infoContainer.addSubview(usersInGroupLabel)
        infoContainer.addSubview(usersInGroupImage)
        view.addSubview(infoContainer)
        view.addSubview(threadsCollectionView)
        view.addSubview(seperatorComments)
        self.threadsCollectionView.register(PrivateGroupThreadsCell.self, forCellWithReuseIdentifier: threadsCellID)
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
    usersInGroupLabel.addConstraintsWithConstants(top: nil, right: usersInGroupImage.leftAnchor, bottom: infoContainer.bottomAnchor, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 5, bottomConstant: 15, leftConstant: 0, width: 30, height: self.widthHeightOfImageViews)
    usersInGroupImage.addConstraintsWithConstants(top: nil, right: infoContainer.rightAnchor, bottom: infoContainer.bottomAnchor, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 15, bottomConstant: 15, leftConstant: 0, width: self.widthHeightOfImageViews, height: self.widthHeightOfImageViews)
    seperatorComments.addConstraintsWithConstants(top: infoContainer.bottomAnchor, right: infoContainer.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 1)
    threadsCollectionView.addConstraintsWithConstants(top: seperatorComments.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 75)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: threadsCellID, for: indexPath) as! PrivateGroupThreadsCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(PrivateGroupCommentsCollectionViewController(), animated: true)
    }
}
