//
//  ActivityWeekCollectionHandler.swift
//  Houp
//
//  Created by Sebastian on 16.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension ActivityWeekCollection{
    
    func handleUsersInGroup(){
        let controller = PrivateGroupRequestAndMembersList()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleActivityForm(){
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let controller = CreateActivityWeekController()
        controller.activityWeekCollection = self
        let createController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: controller, navBarTitle: (tomorrow?.getDatePartWithDay() as? String)!, barItemTitle: nil, image: nil)
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
            if let view = DBConnection.shared.viewByActiveActivityForUser{
                let query = view.createQuery()
                query.keys = [userID]
                liveQuery = query.asLive()
                liveQuery?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
                liveQuery?.start()
            }else{
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.present(alert, animated: true, completion: nil)
            }
    }
    
    func handleNavBarItem(){
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.accept_icon.rawValue), style: .plain, target: self, action: #selector(handleUpdateActivity))
        
//            if(self.activityList.count == 0){
//                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.createIcon.rawValue), style: .plain, target: self, action: #selector(handleActivityForm))
//            }else if(Date().checkIfActivityAlreadyOver(date: self.activityList[0].dateObject!) <= Date()){
//                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.accept_icon.rawValue), style: .plain, target: self, action: #selector(handleUpdateActivity))
//            }else{
//                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: GetString.accept_icon.rawValue), style: .plain, target: self, action: #selector(handleUpdateActivity))
//                navigationItem.rightBarButtonItem?.isEnabled = false
//            }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        do{
        if keyPath == "rows" {
                if let rows = liveQuery?.rows {
                    self.activityList.removeAll()
                    while let row = rows.nextRow() {
                        if let props = row.document!.properties {
                            let activity = Activity(props: props)
                            activity.rev = row.documentRevisionID
                            activity.aid = row.documentID
                            self.activityList.append(activity)
                        }
                        self.activityList.sort(by:
                            { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedAscending }
                        )
                        self.activityCollectionView.reloadData()
                        handleNavBarItem()
                    }
                }
            }
        }catch{
            self.activityList = [Activity]()
            self.activityCollectionView.reloadData()
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
