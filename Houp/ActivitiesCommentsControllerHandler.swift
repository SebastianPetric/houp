//
//  ActivitiesCommentsControllerHandler.swift
//  Houp
//
//  Created by Sebastian on 13.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension ActivitiesCommentsController{
    
    func handleSendComment(){
        self.view.endEditing(true)
        let commentView = self.writeCommentContainer.subviews[0] as! UITextField
        if(commentView.text != ""){
            let commentView = self.writeCommentContainer.subviews[0] as! UITextField
            let comment = Comment(rev: nil, cid: nil, authorID: UserDefaults.standard.string(forKey: GetString.userID.rawValue), authorUsername: self.activityObject?.userName, groupID: self.activityObject?.groupID ,dailyActivityID: self.activityObject?.aid, threadID: nil, message: commentView.text, date: Date(), dateString: nil, likeIDs: nil)
            if let error = DBConnection.shared.createCommentForActivityWithProperties(properties: comment){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.present(alert, animated: true, completion: nil)
            }else{
                commentView.text = ""
            }
        }
    }
    
    func handleUpvote(){
        if(self.upvoteButtonInfo?.tintColor == .black){
            if let error = DBConnection.shared.likeActivity(aID: (self.activityObject?.aid)!){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.upvoteButtonInfo?.tintColor = UIColor().getSecondColor()
            }
            
        }else{
            if let error = DBConnection.shared.dislikeActivity(aID: (self.activityObject?.aid)!){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.upvoteButtonInfo?.tintColor = .black
            }
        }
    }
    
    func getTopicComments(activityID: String){
        if let view = DBConnection.shared.viewCommentByDailyActivityID{
            let query = view.createQuery()
            query.keys = [activityID]
            liveQuery = query.asLive()
            liveQuery?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQuery?.start()
        }else{
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getTopicActivity(activityID: String){
        if let queryForActivity = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery(){
        queryForActivity.allDocsMode = CBLAllDocsMode.allDocs
        queryForActivity.keys = [activityID]
        liveQueryActivity = queryForActivity.asLive()
        liveQueryActivity?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
        liveQueryActivity?.start()
        }else{
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    
        do{
        if object as! NSObject == self.liveQueryActivity{

                if let rows = liveQueryActivity?.rows {
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
                            activity.rev = row.documentRevisionID
                            activity.aid = row.documentID
                            activity.userName = userName
                            self.activityObject = activity
                        }
                    }
            }
        }else if(object as! NSObject == self.liveQuery){
            if keyPath == "rows" {
               
                    if let rows = liveQuery!.rows {
                        comments.removeAll()
                        while let row = rows.nextRow() {
                            if let props = row.document!.properties {
                                var userName: String?
                                if let authorUserName = props["authorID"] as? String{
                                    let queryForUsername = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
                                    queryForUsername?.allDocsMode = CBLAllDocsMode.allDocs
                                    queryForUsername?.keys = [authorUserName]
                                    let result = try queryForUsername?.run()
                                    while let row = result?.nextRow() {
                                        userName = row.document?["username"] as? String
                                    }
                                }
                                let comment = Comment(propsForActivity: props)
                                comment.userName = userName
                                comments.append(comment)
                            }
                            self.comments.sort(by:
                                { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedAscending }
                            )
                            //                                    comments.sort(by: {
                            //                                        if ($0.likeIDs?.count)! > ($1.likeIDs?.count)!{
                            //                                            return true
                            //                                        }
                            //                                        return false
                            //                                    })
                            self.commentsCollectionView.reloadData()
                        }
                    }
               
            }
        }
    }catch{
        self.comments = [Comment]()
        self.commentsCollectionView.reloadData()
    let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
    self.present(alert, animated: true, completion: nil)
    }
    }
}

