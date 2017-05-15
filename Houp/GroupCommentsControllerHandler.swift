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
    if(!hasAnyErrors()){
        let commentView = self.writeCommentContainer.subviews[0] as! UITextField
        let comment = Comment(rev: nil, cid: nil, authorID: UserDefaults.standard.string(forKey: GetString.userID.rawValue), authorUsername: nil, groupID: self.thread?.groupID,dailyActivityID: nil, threadID: self.thread?.tid, message: commentView.text, date: Date(), dateString: nil, likeIDs: nil)
        
        if let error = DBConnection.shared.createCommentWithProperties(properties: comment){
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

func getTopicComments(threadID: String){
    do{
        if let view = DBConnection.shared.viewByComment{
            let query = view.createQuery()
            query.keys = [threadID]
            liveQuery = query.asLive()
            liveQuery?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQuery?.start()
        }
    }catch{
        let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
        self.present(alert, animated: true, completion: nil)
    }
}

override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    
    var allComments = [[Comment]]()
    var topComment = [Comment]()
    var otherComments = [Comment]()
    
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
            
        }
    }
    
//    if keyPath == "rows" {
//        do{
//            if let rows = liveQuery!.rows {
//                comments.removeAll()
//                while let row = rows.nextRow() {
//                    if let props = row.document!.properties {
//                        var userName: String?
//                        if let authorUserName = props["authorID"] as? String{
//                            let queryForUsername = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
//                            queryForUsername?.allDocsMode = CBLAllDocsMode.allDocs
//                            queryForUsername?.keys = [authorUserName]
//                            let result = try queryForUsername?.run()
//                            while let row = result?.nextRow() {
//                                userName = row.document?["username"] as? String
//                            }
//                        }
//                        let comment = Comment(rev: props["_rev"] as? String, cid: props["_id"] as? String, authorID: props["authorID"] as? String, authorUsername: userName, groupID: props["groupID"] as? String,dailyActivityID: nil,threadID: props["threadID"] as? String, message: props["message"] as? String, date: nil, dateString: props["date"] as? String, likeIDs: props["likeIDs"] as? [String])
//                        comments.append(comment)
//                    }
//                    comments.sort(by: {
//                        if ($0.likeIDs?.count)! > ($1.likeIDs?.count)!{
//                            return true
//                        }
//                        return false
//                    })
//                    self.commentsCollectionView.reloadData()
//                }
//            }
//        }catch{
//            
//        }
//    }
}
}

