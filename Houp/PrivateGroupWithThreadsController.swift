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
    var liveQueryGroupDetails: CBLLiveQuery?
    var groupCollectionView: UICollectionView?
    
//    deinit {
//        liveQuery?.removeObserver(self, forKeyPath: "rows")
//        liveQueryGroupDetails?.removeObserver(self, forKeyPath: "rows")
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
                self.timeOfMeeting.text = "\(time.getTimePart()) Uhr"
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
            if let activityCount = privateGroup?.dailyActivityIDs?.count{
                activitiesInGroupLabel.text = "\(activityCount)"
            }
            if((privateGroup?.groupRequestIDs?.count)! > 0 && UserDefaults.standard.string(forKey: GetString.userID.rawValue) == privateGroup?.adminID){
                usersInGroupButton.tintColor = UIColor().getMainColor()
            }else{
                usersInGroupButton.tintColor = .white
            }
        }
    }
    var threadsList: [Thread] = [Thread]()
    let widthHeightOfImages: CGFloat = 20
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
    view.backgroundColor = UIColor().getSecondColor()
    return view
    }()

    let seperatorText = CustomViews.shared.getCustomSeperator(color: .white)
    let nameOfGroup = CustomViews.shared.getCustomLabel(text: "AA Regionalgruppe", fontSize: 14, numberOfLines: 2, isBold: true, textAlignment: .left, textColor: .white)
    let locationOfMeeting = CustomViews.shared.getCustomLabel(text: "Weingarten, Siemensstraße 28", fontSize: 12, numberOfLines: 2, isBold: false, textAlignment: .left, textColor: .white)
    let dayOfMeeting = CustomViews.shared.getCustomLabel(text: "Jeden 3. Donnerstag im geraden Monat", fontSize: 12, numberOfLines: 2, isBold: false, textAlignment: .left, textColor: .white)
    let timeOfMeeting = CustomViews.shared.getCustomLabel(text: "19:30 Uhr", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .left, textColor: .white)
    let secretGroupID = CustomViews.shared.getCustomLabel(text: "#GeheimeID", fontSize: 12, numberOfLines: 1, isBold: true, textAlignment: .left, textColor: .white)
    let usersInGroupLabel = CustomViews.shared.getCustomLabel(text: "1000", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .right, textColor: .white)
    let usersInGroupButton = CustomViews.shared.getCustomButtonWithImage(imageName: "users_private_icon", backgroundColor: UIColor().getSecondColor(), imageColor: .white, radius: nil, borderColor: UIColor().getSecondColor())
    let activitiesInGroupLabel = CustomViews.shared.getCustomLabel(text: "1000", fontSize: 12, numberOfLines: 1, isBold: false, textAlignment: .right, textColor: .white)
    let activitiesInGroupButton = CustomViews.shared.getCustomButtonWithImage(imageName: "activity_tab_bar", backgroundColor: UIColor().getSecondColor(), imageColor: .white, radius: 10, borderColor: UIColor().getSecondColor())
    let editButton = CustomViews.shared.getCustomButtonWithImage(imageName: "edit_icon", backgroundColor: UIColor().getSecondColor(), imageColor: .white, radius: nil, borderColor: UIColor().getSecondColor())
    let seperatorComments = CustomViews.shared.getCustomSeperator(color: UIColor().getSecondColor())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Themen"
    
//        if(liveQuery == nil){
//            getTopicThreads(groupID: (self.privateGroup?.pgid)!)
//        }
//        
//        if(liveQueryGroupDetails == nil){
//            getTopicGroup(groupID: (self.privateGroup?.pgid)!)
//        }
        
        TempStorageAndCompare.shared.privateGroupsWithThreadsDelegate = self
        
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
        infoContainer.addSubview(activitiesInGroupLabel)
        infoContainer.addSubview(activitiesInGroupButton)
        view.addSubview(infoContainer)
        //infoContainer.backgroundColor = UIColor().getSecondColor()
        view.addSubview(threadsCollectionView)
        view.addSubview(seperatorComments)
        
        if(UserDefaults.standard.string(forKey: GetString.userID.rawValue) != self.privateGroup?.adminID){
            self.editButton.isHidden = true
            self.editButton.isEnabled = true
        }
        
        self.editButton.addTarget(self, action: #selector(editGroup), for: .touchUpInside)
        self.activitiesInGroupButton.addTarget(self, action: #selector(handleActivitiesInGroup), for: .touchUpInside)
        self.threadsCollectionView.register(PrivateGroupThreadsCell.self, forCellWithReuseIdentifier: threadsCellID)
        self.usersInGroupButton.addTarget(self, action: #selector(handleUsersInGroup), for: .touchUpInside)
        setUpSubViews()
    }

    func setUpSubViews(){
    editButton.addConstraintsWithConstants(top: infoContainer.topAnchor, right: infoContainer.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: nil, topConstant: 15, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: self.widthHeightOfImageViews, height: self.widthHeightOfImageViews)
    usersInGroupLabel.addConstraintsWithConstants(top: nil, right: usersInGroupButton.leftAnchor, bottom: infoContainer.bottomAnchor, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 5, bottomConstant: 15, leftConstant: 0, width: 30, height: self.widthHeightOfImageViews)
    usersInGroupButton.addConstraintsWithConstants(top: nil, right: infoContainer.rightAnchor, bottom: infoContainer.bottomAnchor, left: nil, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 15, bottomConstant: 15, leftConstant: 0, width: self.widthHeightOfImageViews, height: self.widthHeightOfImageViews)
        
    activitiesInGroupLabel.addConstraintsWithConstants(top: nil, right: activitiesInGroupButton.leftAnchor, bottom: nil, left: nil, centerX: nil, centerY: infoContainer.centerYAnchor, topConstant: 0, rightConstant: 5, bottomConstant: 0, leftConstant: 0, width: 30, height: self.widthHeightOfImageViews)
        activitiesInGroupButton.addConstraintsWithConstants(top: nil, right: infoContainer.rightAnchor, bottom: nil, left: nil, centerX: nil, centerY: infoContainer.centerYAnchor, topConstant: 0, rightConstant: 15, bottomConstant: 0, leftConstant: 0, width: self.widthHeightOfImageViews, height: self.widthHeightOfImageViews)
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
        //new
        cell.thread = TempStorageAndCompare.shared.getAllThreadsOfGroup(groupID: (self.privateGroup?.pgid)!)[indexPath.row]
        //------
        
        //cell.thread = self.threadsList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //new
            return TempStorageAndCompare.shared.getAllThreadsOfGroup(groupID: (self.privateGroup?.pgid)!).count
        //-------
        
        //return self.threadsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = GroupCommentsController()
        //new
        var tempList = TempStorageAndCompare.shared.getAllGroupsWithThreads()[(self.privateGroup?.pgid)!]
        tempList?[indexPath.row].hasBeenUpdated = false
        TempStorageAndCompare.shared.saveAllThreadsOfGroup(groupID: (self.privateGroup?.pgid)!, threads: tempList!)
        TempStorageAndCompare.shared.compareAndSaveGroups(group: self.privateGroup!)
        
        if(!TempStorageAndCompare.shared.anyThreadOfGroupWasUpdated(group: self.privateGroup!)){
            TempStorageAndCompare.shared.saveSingleGroup(group: self.privateGroup!, hasBeenUpdated: false)
        }

        
        self.groupCollectionView?.reloadData()
        self.threadsCollectionView.reloadData()
        
        controller.thread = TempStorageAndCompare.shared.getAllThreadsOfGroup(groupID: (self.privateGroup?.pgid)!)[indexPath.row]
        //-----
        //controller.thread = threadsList[indexPath.row]
        controller.titleNav = (self.privateGroup?.nameOfGroup)!
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
