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
        if(!hasAnyErrors()){
            let commentView = self.writeCommentContainer.subviews[0] as! UITextField
            let comment = Comment(rev: nil, cid: nil, authorID: UserDefaults.standard.string(forKey: GetString.userID.rawValue), authorUsername: self.activityObject?.userName, groupID: self.activityObject?.groupID ,dailyActivityID: self.activityObject?.aid, threadID: nil, message: commentView.text, date: Date(), dateString: nil, likeIDs: nil)
            
            if let error = DBConnection.shared.createCommentForActivityWithProperties(properties: comment){
                let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                self.present(alert, animated: true, completion: nil)
            }else{
                commentView.text = ""
            }
        }else{
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorFillAllFields.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func hasAnyErrors() -> Bool{
        let commentView = self.writeCommentContainer.subviews[0] as! UITextField
        if(commentView.text == ""){
            return true
        }else{
            return false
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
            if let view = DBConnection.shared.viewByCommentOfActivity{
                let query = view.createQuery()
                query.keys = [activityID]
                liveQuery = query.asLive()
                liveQuery?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
                liveQuery?.start()
            }
    }
    
    func getTopicActivity(activityID: String){
            let queryForActivity = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
            queryForActivity?.allDocsMode = CBLAllDocsMode.allDocs
            queryForActivity?.keys = [activityID]
            liveQueryActivity = queryForActivity?.asLive()
            liveQueryActivity?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQueryActivity?.start()
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if object as! NSObject == self.liveQueryActivity{
                do{
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
                                let activity = Activity(rev: row.documentRevisionID, aid: row.documentID, authorID: props["authorID"] as! String?, authorUsername: userName, groupID: props["groupID"] as! String?, activity: props["activity"] as! String?, activityText: props["activityText"] as! String?, locationOfActivity: props["locationOfActivity"] as! String?, isInProcess: props["isInProcess"] as! Bool?, status: props["status"] as! Int?, wellBeingState: props["wellBeingState"] as! Int?, wellBeingText: props["wellBeingText"] as! String?, addictionState: props["addictionState"] as! Int?, addictionText: props["addictionText"] as! String?, dateObject: nil, timeObject: nil, dateString: props["date"] as! String?, timeString: props["time"] as! String?, commentIDs: props["commentIDs"] as! [String]?, likeIDs: props["likeIDs"] as! [String]?)
                                    self.activityObject = activity
                            }
                        }
                    }
                }catch{
                    let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
                    self.present(alert, animated: true, completion: nil)
                }
        }else if(object as! NSObject == self.liveQuery){
                    if keyPath == "rows" {
                        do{
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
                                        let comment = Comment(rev: props["_rev"] as? String, cid: props["_id"] as? String, authorID: props["authorID"] as? String, authorUsername: userName, groupID: props["groupID"] as? String,dailyActivityID: nil,threadID: props["threadID"] as? String, message: props["message"] as? String, date: nil, dateString: props["date"] as? String, likeIDs: props["likeIDs"] as? [String])
                                        comments.append(comment)
                                    }
                                    comments.sort(by: {
                                        if ($0.likeIDs?.count)! > ($1.likeIDs?.count)!{
                                            return true
                                        }
                                        return false
                                    })
                                    self.commentsCollectionView.reloadData()
                                }
                            }
                        }catch{
                            
                        }
                    }
        }
    }
}

