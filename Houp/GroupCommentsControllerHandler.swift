//
//  GroupCommentsControllerHandler.swift
//  Houp
//
//  Created by Sebastian on 04.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension GroupCommentsController{

func handleSendComment(){
    
    self.view.endEditing(true)
    let commentView = self.writeCommentContainer.subviews[0] as! UITextField
    if(commentView.text != ""){
        let commentView = self.writeCommentContainer.subviews[0] as! UITextField
        let comment = Comment(rev: nil, cid: nil, authorID: UserDefaults.standard.string(forKey: GetString.userID.rawValue), authorUsername: nil, groupID: self.thread?.groupID,dailyActivityID: nil, threadID: self.thread?.tid, message: commentView.text, date: Date(), dateString: nil, likeIDs: nil)
        
        if let error = DBConnection.shared.createCommentWithProperties(properties: comment){
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: error, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }else{
            commentView.text = ""
        }
    }
}
    
func getTopicThread(threadID: String){
        if let queryForThread = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery(){
            queryForThread.allDocsMode = CBLAllDocsMode.allDocs
            queryForThread.keys = [threadID]
            self.liveQueryThreadDetails = queryForThread.asLive()
            self.liveQueryThreadDetails?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            self.liveQueryThreadDetails?.start()
        }else{
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }


func getTopicComments(threadID: String){
        if let view = DBConnection.shared.viewByComment{
            let query = view.createQuery()
            query.keys = [threadID]
            liveQuery = query.asLive()
            liveQuery?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQuery?.start()
        }else{
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }

override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    
    var allComments = [[Comment]]()
    var topComment = [Comment]()
    var otherComments = [Comment]()
    
    if (object as! NSObject == self.liveQueryThreadDetails){
    do{
        if let rows = liveQueryThreadDetails!.rows {
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
                    let threadObj = Thread(props: props)
                    threadObj.userName = userName
                    self.thread = threadObj
                }
            }
        }
        }catch{
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }else if(object as! NSObject == self.liveQuery){
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
                            let comment = Comment(propsForThread: props)
                            comment.userName = userName
                            comments.append(comment)
                        }
                        comments.sort(by: {
                            if ($0.likeIDs?.count)! > ($1.likeIDs?.count)!{
                                return true
                            }
                            return false
                        })
                    }
                }
                var i = 0
                for com in comments {
                    if (com.likeIDs?.count)! > 0{
                        if(i == 0){
                            topComment.append(com)
                        }else{
                            otherComments.append(com)
                        }
                        i = i + 1
                    }else{
                        otherComments.append(com)
                    }
                }
                allComments.append(topComment)
                allComments.append(otherComments)
                self.commentsList = allComments
                self.commentsCollectionView.reloadData()
        }catch{
            topComment = [Comment]()
            otherComments = [Comment]()
            allComments.append(topComment)
            allComments.append(otherComments)
            self.commentsList = allComments
            self.commentsCollectionView.reloadData()
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
}

