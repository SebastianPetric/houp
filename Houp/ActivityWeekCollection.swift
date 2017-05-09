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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.createIcon.rawValue), style: .plain, target: self, action: #selector(handleActivityForm))
        //self.threadsList = DBConnection.shared.getAllThreadsOfGroup(groupID: (self.privateGroup?.pgid)!)
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.createIcon.rawValue), style: .plain, target: self, action: #selector(handleCreateThread))
        view.addSubview(activityCollectionView)
        self.activityCollectionView.register(ActivityWeekCollectionCell.self, forCellWithReuseIdentifier: activityCellID)
        self.activityCollectionView.register(ActivityWeekHighlightedCell.self, forCellWithReuseIdentifier: activityCellHighlightedID)
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
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleActivityForm))
        swipe.direction = UISwipeGestureRecognizerDirection.left
        
        
        
        if(indexPath.row == 0){
        let cellHighlighted = collectionView.dequeueReusableCell(withReuseIdentifier: activityCellHighlightedID, for: indexPath) as! ActivityWeekHighlightedCell
            cellHighlighted.addGestureRecognizer(swipe)
        return cellHighlighted
        }else{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: activityCellID, for: indexPath) as! ActivityWeekCollectionCell
            cell.addGestureRecognizer(swipe)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let controller = PrivateGroupCommentsCollectionViewController()
//        let controller = GroupCommentsController()
//        controller.thread = threadsList[indexPath.row]
//        controller.titleNav = (self.privateGroup?.nameOfGroup)!
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleUsersInGroup(){
        let controller = PrivateGroupRequestAndMembersList()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    

        func handleActivityForm(){
            //let createController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: ActivityForm1(), navBarTitle: "Hallo!", barItemTitle: nil, image: nil)
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            let createController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: CreateActivityWeekController(), navBarTitle: (tomorrow?.getDatePart() as? String)!, barItemTitle: nil, image: nil)
            self.present(createController, animated: true, completion: nil)
    }
}
