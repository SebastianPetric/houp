//
//  PrivateGroupWithCommentsController.swift
//  Houp
//
//  Created by Sebastian on 03.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class PrivateGroupWithThreadsController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{

    var liveQuery: CBLLiveQuery?
    
    deinit {
        liveQuery?.removeObserver(self, forKeyPath: "rows")
    }
    
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
            if let numberOfMembers = privateGroup?.memberIDs{
                self.usersInGroupLabel.text = "\(numberOfMembers.count)"
            }
            if let dayOfMeeting = privateGroup?.dayOfMeeting{
                self.dayOfMeeting.text = dayOfMeeting
            }
            if let name = privateGroup?.nameOfGroup{
                nameOfGroup.text = name
            }
        }
    }
    var threadsList: [Thread] = [Thread]()
    
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

    let seperatorText = CustomViews.shared.getCustomSeperator(color: .white)
    let nameOfGroup = CustomViews.shared.getCustomLabel(text: "AA Regionalgruppe", fontSize: 14, isBold: true, textAlignment: .left, textColor: .white)
    let locationOfMeeting = CustomViews.shared.getCustomLabel(text: "Weingarten, Siemensstraße 28", fontSize: 12, isBold: false, textAlignment: .left, textColor: .white)
    let dayOfMeeting = CustomViews.shared.getCustomLabel(text: "Jeden 3. Donnerstag im geraden Monat", fontSize: 12, isBold: false, textAlignment: .left, textColor: .white)
    let timeOfMeeting = CustomViews.shared.getCustomLabel(text: "19:30 Uhr", fontSize: 12, isBold: false, textAlignment: .left, textColor: .white)
    let secretGroupID = CustomViews.shared.getCustomLabel(text: "#GeheimeID", fontSize: 12, isBold: true, textAlignment: .left, textColor: .white)
    let usersInGroupLabel = CustomViews.shared.getCustomLabel(text: "1000", fontSize: 12, isBold: false, textAlignment: .right, textColor: .white)
    let usersInGroupButton = CustomViews.shared.getCustomButtonWithImage(imageName: "users_private_icon", backgroundColor: UIColor(red: 41, green: 192, blue: 232, alphaValue: 1), imageColor: .white, radius: nil, borderColor: UIColor(red: 41, green: 192, blue: 232, alphaValue: 1))
    let editButton = CustomViews.shared.getCustomButtonWithImage(imageName: "edit_icon", backgroundColor: UIColor(red: 41, green: 192, blue: 232, alphaValue: 1), imageColor: .white, radius: nil, borderColor: UIColor(red: 41, green: 192, blue: 232, alphaValue: 1))
    let seperatorComments = CustomViews.shared.getCustomSeperator(color: UIColor().getSecondColor())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Themen"
    
            if(liveQuery == nil){
                getTopicThreads(groupID: (self.privateGroup?.pgid)!)
            }
        
        //self.threadsList = DBConnection.shared.getAllThreadsOfGroup(groupID: (self.privateGroup?.pgid)!)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.createIcon.rawValue), style: .plain, target: self, action: #selector(handleCreateThread))
        infoContainer.addSubview(nameOfGroup)
        infoContainer.addSubview(locationOfMeeting)
        infoContainer.addSubview(timeOfMeeting)
        infoContainer.addSubview(seperatorText)
        infoContainer.addSubview(dayOfMeeting)
        infoContainer.addSubview(secretGroupID)
        infoContainer.addSubview(editButton)
        infoContainer.addSubview(usersInGroupLabel)
        infoContainer.addSubview(usersInGroupButton)
        view.addSubview(infoContainer)
        infoContainer.backgroundColor = UIColor(red: 41, green: 192, blue: 232, alphaValue: 1)
        view.addSubview(threadsCollectionView)
        view.addSubview(seperatorComments)
        self.threadsCollectionView.register(PrivateGroupThreadsCell.self, forCellWithReuseIdentifier: threadsCellID)
        self.usersInGroupButton.addTarget(self, action: #selector(handleUsersInGroup), for: .touchUpInside)
        setUpSubViews()
    }

    func setUpSubViews(){
    editButton.addConstraintsWithConstants(top: infoContainer.topAnchor, right: infoContainer.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: self.widthHeightOfImageViews, height: self.widthHeightOfImageViews)
    usersInGroupLabel.addConstraintsWithConstants(top: nil, right: usersInGroupButton.leftAnchor, bottom: infoContainer.bottomAnchor, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 5, bottomConstant: 15, leftConstant: 0, width: 30, height: self.widthHeightOfImageViews)
    usersInGroupButton.addConstraintsWithConstants(top: nil, right: infoContainer.rightAnchor, bottom: infoContainer.bottomAnchor, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 15, bottomConstant: 15, leftConstant: 0, width: self.widthHeightOfImageViews, height: self.widthHeightOfImageViews)
    seperatorComments.addConstraintsWithConstants(top: infoContainer.bottomAnchor, right: infoContainer.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 1)
    threadsCollectionView.addConstraintsWithConstants(top: seperatorComments.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 0)
        
        infoContainer.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 105)
        nameOfGroup.addConstraintsWithConstants(top: infoContainer.topAnchor, right: nil, bottom: nil, left: infoContainer.leftAnchor, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 200, height: 15)
        locationOfMeeting.addConstraintsWithConstants(top: nameOfGroup.bottomAnchor, right: editButton.leftAnchor, bottom: nil, left: infoContainer.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 0, height: 15)
        timeOfMeeting.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: nil, bottom: nil, left: infoContainer.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 60, height: 15)
        seperatorText.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: nil, bottom: nil, left: timeOfMeeting.rightAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0.5, height: 15)
        dayOfMeeting.addConstraintsWithConstants(top: locationOfMeeting.bottomAnchor, right: usersInGroupLabel.leftAnchor, bottom: nil, left: seperatorText.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 5, width: 0, height: 15)
        secretGroupID.addConstraintsWithConstants(top: timeOfMeeting.bottomAnchor, right: nil, bottom: nil, left: infoContainer.leftAnchor, centerX: nil, centerY: nil, topConstant: 5, rightConstant: 0, bottomConstant: 0, leftConstant: 15, width: 130.5, height: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 75)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: threadsCellID, for: indexPath) as! PrivateGroupThreadsCell
        cell.thread = self.threadsList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.threadsList.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = PrivateGroupCommentsCollectionViewController()
        controller.thread = threadsList[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleUsersInGroup(){
    let controller = PrivateGroupRequestAndMembersList()
        controller.privateGroup = self.privateGroup
    self.navigationController?.pushViewController(controller, animated: true)
    }
}
