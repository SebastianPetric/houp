//
//  PrivateGroupRequestsAndMembersListHandler.swift
//  Houp
//
//  Created by Sebastian on 16.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension PrivateGroupRequestAndMembersList{
    
    func getTopicUsers(groupID: String){
        if let query = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery(){
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
        var adminList = [[UserObject]]()
        var reqList = [UserObject]()
        var memList = [UserObject]()
        
        do{
            if(object as! NSObject == self.liveQuery){
                    if let rows = liveQuery!.rows {
                        self.adminList.removeAll()
                        while let row = rows.nextRow() {
                            if let props = row.document!.properties {
                                if(privateGroup?.adminID == UserDefaults.standard.string(forKey: GetString.userID.rawValue)){
                                    if let groupRequestIDs = props["groupRequestIDs"] as? [String]{
                                        let queryForRequests = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
                                        queryForRequests?.allDocsMode = CBLAllDocsMode.allDocs
                                        queryForRequests?.keys = groupRequestIDs
                                        let result = try queryForRequests?.run()
                                        while let row = result?.nextRow() {
                                            
                                            let requestUser = UserObject(props: (row.document?.properties)!)
                                            requestUser.uid = row.documentID
                                            requestUser.rev = row.documentRevisionID
                                            if(HoupImageCache.shared.getImageFromCache(userID: requestUser.userName!) == nil){
                                                let stringURL = "\(requestUser.userName!)_profileImage.jpeg"
                                                
                                                let att = row.document?.currentRevision?.attachmentNamed(stringURL)
                                                
                                                if(att != nil){
                                                    HoupImageCache.shared.saveImageToCache(userID: requestUser.userName!, profile_image: UIImage(data: (att?.content)!)!)
                                                }
                                            }
                                            reqList.append(requestUser)
                                        }
                                    }
                                }
                                adminList.append(reqList)
                                if let memberIDs = props["memberIDs"] as? [String]{
                                    let queryForMembers = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
                                    queryForMembers?.allDocsMode = CBLAllDocsMode.allDocs
                                    queryForMembers?.keys = memberIDs
                                    let result = try queryForMembers?.run()
                                    while let row = result?.nextRow() {
                                        let memUser = UserObject(props: (row.document?.properties)!)
                                        memUser.uid = row.documentID
                                        memUser.rev = row.documentRevisionID
                                        if(HoupImageCache.shared.getImageFromCache(userID: memUser.userName!) == nil){
                                            let stringURL = "\(memUser.userName!)_profileImage.jpeg"
                                            
                                            let att = row.document?.currentRevision?.attachmentNamed(stringURL)
                                            
                                            if(att != nil){
                                                HoupImageCache.shared.saveImageToCache(userID: memUser.userName!, profile_image: UIImage(data: (att?.content)!)!)
                                            }
                                        }
                                        memList.append(memUser)
                                    }
                                }
                                adminList.append(memList)
                            }
                            self.adminList = adminList
                            self.membersCollectionView.reloadData()
                        }
                    }
                
            }
            
          
        }catch{
            reqList = [UserObject]()
            memList = [UserObject]()
            adminList.append(reqList)
            adminList.append(memList)
            self.adminList = adminList
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
