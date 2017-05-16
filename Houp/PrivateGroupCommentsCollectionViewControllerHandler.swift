//
//  PrivateGroupCommentsCollectionViewControllerHandler.swift
//  Houp
//
//  Created by Sebastian on 05.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension PrivateGroupCommentsCollectionViewController{
    
    func handleSendComment(){
        self.view.endEditing(true)
        if(!hasAnyErrors()){
            let commentView = self.writeCommentContainer.subviews[0] as! UITextField
            let comment = Comment(rev: nil, cid: nil, authorID: UserDefaults.standard.string(forKey: GetString.userID.rawValue), authorUsername: nil, groupID: self.thread?.groupID, dailyActivityID: nil, threadID: self.thread?.tid, message: commentView.text, date: Date(),dateString: nil, likeIDs: nil)
            
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
                        self.commentsCollectionView.reloadData()
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
}
