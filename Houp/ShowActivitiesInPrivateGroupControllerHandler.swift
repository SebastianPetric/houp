//
//  ShowActivitiesInPrivateGroupControllerHandler.swift
//  Houp
//
//  Created by Sebastian on 16.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension ShowActivitiesInPrivateGroupController{
   
    func getTopicActivities(groupID: String){
        if let view = DBConnection.shared.viewByAllActivityInGroup{
            let query = view.createQuery()
            query.keys = [groupID]
            liveQuery = query.asLive()
            liveQuery?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQuery?.start()
        }else{
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        do{
            if keyPath == "rows" {
                if let rows = liveQuery?.rows {
                    self.activityList.removeAll()
                    while let row = rows.nextRow() {
                        if let props = row.document!.properties {
                            var userName: String?
                            let queryForUsername = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
                            queryForUsername?.allDocsMode = CBLAllDocsMode.allDocs
                            queryForUsername?.keys = [UserDefaults.standard.string(forKey: GetString.userID.rawValue)]
                            let result = try queryForUsername?.run()
                            while let row = result?.nextRow() {
                                userName = row.document?["username"] as? String
                            }
                            let activity = Activity(props: props)
                            activity.userName = userName
                            activity.rev = row.documentRevisionID
                            activity.aid = row.documentID
                            self.activityList.append(activity)
                        }
                        self.activityList.sort(by:
                            { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedDescending }
                        )
                        self.activityCollectionView.reloadData()
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
