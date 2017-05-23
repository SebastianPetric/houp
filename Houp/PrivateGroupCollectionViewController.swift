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
    var isObserving = false
    
    //Bringt eventuell Fehler. Überprüfen
    deinit {
        liveQuery?.removeObserver(self, forKeyPath: "rows")
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
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
        
        view.backgroundColor = .white
        if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
            self.activityList = DBConnection.shared.getPersonalActivities(userID: userID)
            if(liveQuery == nil){
                getTopicGroups(userID: userID)
            }
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
        return privateGroupsList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 105)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.privateGroupCellID, for: indexPath) as! PrivateGroupsCell
        if privateGroupsList.count != 0{
            cell.privateGroup = privateGroupsList[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = PrivateGroupWithThreadsController()
        controller.privateGroup = privateGroupsList[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
