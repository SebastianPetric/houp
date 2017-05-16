//
//  ActivityWeekCollection.swift
//  Houp
//
//  Created by Sebastian on 07.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class ActivityWeekCollection: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{

    let activityCellID = "activityCellID"
    let activityCellHighlightedID = "activityCellHighlightedID"
    var widthHeightOfImageViews: CGFloat = 20
    var activityList: [Activity] = [Activity]()
    var liveQuery: CBLLiveQuery?
    
    lazy var activityCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let activity = UICollectionView(frame: .zero, collectionViewLayout: layout)
        activity.dataSource = self
        activity.delegate = self
        activity.backgroundColor = .white
        return activity
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userID = UserDefaults.standard.string(forKey: GetString.userID.rawValue){
            if(liveQuery == nil){
                getTopicActivities(userID: userID)
            }
        }
        
        view.addSubview(activityCollectionView)
        self.activityCollectionView.register(ActivityWeekCollectionCell.self, forCellWithReuseIdentifier: activityCellID)
        self.activityCollectionView.register(ActivityWeekHighlightedCell.self, forCellWithReuseIdentifier: activityCellHighlightedID)
        handleNavBarItem()
        setUpSubViews()
    }
    
    func setUpSubViews(){
        activityCollectionView.addConstraintsWithConstants(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, centerX: nil, centerY: nil, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.row == 0){
        return CGSize(width: view.frame.width, height: 150)
        }else{
        return CGSize(width: view.frame.width, height: 75)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0){
        let cellHighlighted = collectionView.dequeueReusableCell(withReuseIdentifier: activityCellHighlightedID, for: indexPath) as! ActivityWeekHighlightedCell
            cellHighlighted.activityObject = self.activityList[indexPath.row]
        return cellHighlighted
        }else{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: activityCellID, for: indexPath) as! ActivityWeekCollectionCell
            cell.activityObject = self.activityList[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activityList.count
    }
}
