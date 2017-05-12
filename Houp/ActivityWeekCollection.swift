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
        handleNavBarItem()
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
            cellHighlighted.activityObject = self.activityList[indexPath.row]
        return cellHighlighted
        }else{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: activityCellID, for: indexPath) as! ActivityWeekCollectionCell
            cell.addGestureRecognizer(swipe)
            cell.activityObject = self.activityList[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activityList.count
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
    
    func handleUpdateActivity(){
        let controller = ActivityForm1()
        controller.activityList = self.activityList
        controller.activityWeekCollection = self
        let updateController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: controller, navBarTitle: "Hallo!", barItemTitle: nil, image: nil)
        self.present(updateController, animated: true, completion: nil)
    }
    
    func getTopicActivities(userID: String){
        do{
            if let view = DBConnection.shared.viewByActiveActivityForUser{
                let query = view.createQuery()
                query.keys = [userID]
                liveQuery = query.asLive()
                liveQuery?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
                liveQuery?.start()
            }
        }catch{
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleNavBarItem(){
        if(self.activityList.count == 0){
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.createIcon.rawValue), style: .plain, target: self, action: #selector(handleActivityForm))
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.accept_icon.rawValue), style: .plain, target: self, action: #selector(handleUpdateActivity))
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "rows" {
            do{
                if let rows = liveQuery?.rows {
                    self.activityList.removeAll()
                    while let row = rows.nextRow() {
                        if let props = row.document!.properties {
//                                var userName: String?
//                                let queryForUsername = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
//                                queryForUsername?.allDocsMode = CBLAllDocsMode.allDocs
//                                queryForUsername?.keys = [UserDefaults.standard.string(forKey: GetString.userID.rawValue)]
//                                let result = try queryForUsername?.run()
//                                while let row = result?.nextRow() {
//                                    userName = row.document?["username"] as? String
//                                }
                                    let activitytime = props["time"] as! String
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "HH:mm"
                                    
                                    var activitydate: Date?
                                    if let activityDate = props["date"] as? String{
                                        activitydate = Date(dateString: activityDate)
                                    }
                            
                                    let activity = Activity(rev: row.documentRevisionID, aid: row.documentID, authorID: props["authorID"] as! String?, authorUsername: nil, groupID: props["groupID"] as! String?, activity: props["activity"] as! String?, activityText: props["activityText"] as! String?, locationOfActivity: props["locationOfActivity"] as! String?, isInProcess: props["isInProcess"] as! Bool?, status: props["status"] as! Int?, wellBeingState: props["wellBeingState"] as! Int?, wellBeingText: props["wellBeingText"] as! String?, addictionState: props["addictionState"] as! Int?, addictionText: props["addictionText"] as! String?, dateObject: activitydate, timeObject: formatter.date(from: activitytime), commentIDs: props["commentIDs"] as! [String]?, likeIDs: props["likeIDs"] as! [String]?)
                                    self.activityList.append(activity)
                        }
                        self.activityList.sort(by:
                            { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedAscending }
                        )
                        self.activityCollectionView.reloadData()
                        handleNavBarItem()
                    }
                }
            }catch{
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
