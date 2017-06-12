//
//  PrivateGroupCollectionViewController.swift
//  Houp
//
//  Created by Sebastian on 28.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit
import UserNotifications

class PrivateGroupCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var liveQuery: CBLLiveQuery?
    var liveQueryThreads: CBLLiveQuery?
    var isObserving = false
    
    //Bringt eventuell Fehler. Überprüfen
    deinit {
        liveQuery?.removeObserver(self, forKeyPath: "rows")
        liveQueryThreads?.removeObserver(self, forKeyPath: "rows")
    }
    
    lazy var privateGroupsCollection: UICollectionView = {
        let collFlowLayout = UICollectionViewFlowLayout()
        collFlowLayout.minimumLineSpacing = 0
        collFlowLayout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collFlowLayout)
        collection.backgroundColor = .white
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    let privateGroupCellID = "privateGroupCellID"
    var privateGroupsList: [PrivateGroup] = [PrivateGroup]()
    var activityList: [Activity] = [Activity]()
    var timer: Timer?
    var tabBarContr: UITabBarController?
    var activityCollection: ActivityWeekCollection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
        
        if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
            //(UIApplication.shared.delegate as! AppDelegate).getThreadByAuthor(authorID: userID)
            
            self.activityList = DBConnection.shared.getPersonalActivities(userID: userID)
            
//            if(liveQuery == nil){
//                getTopicGroups(userID: userID)
//            }
//            
//            if(liveQueryThreads == nil){
//                var tempList: [String] = [String]()
//                for group in self.privateGroupsList{
//                tempList.append(group.pgid!)
//                }
//                getTopicThreads(groupID: tempList)
//            }
            
            TempStorageAndCompare.shared.groupCollectionDelegate = self
            TempStorageAndCompare.shared.initialiseNotificationQueries(userID: userID)
        }
        
        if(self.activityList.count > 0){
            TimerObject.shared.tabContr = self.tabBarContr
            TimerObject.shared.activityCollection = self.activityCollection
            TimerObject.shared.invalidateTimer()
            //TimerObject.shared.invalidateDelayTimer()
            if(Date().checkIfActivityAlreadyOver(date: self.activityList[0].dateObject!) <= Date()){
                TimerObject.shared.setUpTimerImmediately()
            }else{
                TimerObject.shared.setUpTimer(date: self.activityList[0].dateObject!)
            }
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        view.addSubview(privateGroupsCollection)
        privateGroupsCollection.register(PrivateGroupsCell.self, forCellWithReuseIdentifier: privateGroupCellID)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.secret_icon.rawValue), style: .plain, target: self, action: #selector(handleMakeRequestPrivateGroup))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.createIcon.rawValue), style: .plain, target: self, action: #selector(handleCreateNewPrivateGroup))
        setUpSubViews()
    }

    func setUpSubViews(){
        privateGroupsCollection.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //new
        return TempStorageAndCompare.shared.getAllPrivateGroupsSync().count
        //-------
        
        //return privateGroupsList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 105)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.privateGroupCellID, for: indexPath) as! PrivateGroupsCell
        //new
        let tempGroup = TempStorageAndCompare.shared.getAllPrivateGroupsSync()[indexPath.row]
        if(!TempStorageAndCompare.shared.anyThreadOfGroupWasUpdated(group: tempGroup)){
            TempStorageAndCompare.shared.saveSingleGroup(group: tempGroup, hasBeenUpdated: false)
        }else if(!TempStorageAndCompare.shared.anyGroupWasUpdated(group: tempGroup)){
        TempStorageAndCompare.shared.saveSingleGroup(group: tempGroup, hasBeenUpdated: false)
        }else{
        TempStorageAndCompare.shared.saveSingleGroup(group: tempGroup, hasBeenUpdated: true)
        }
        cell.privateGroup = tempGroup
        //----
        
        
//        if privateGroupsList.count != 0{
//            cell.privateGroup = privateGroupsList[indexPath.row]
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = PrivateGroupWithThreadsController()
        //new
        let tempGroup = TempStorageAndCompare.shared.getAllPrivateGroupsSync()[indexPath.row]
        controller.privateGroup = tempGroup
        controller.groupCollectionView = self.privateGroupsCollection
        //------
        
        //controller.privateGroup = privateGroupsList[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
