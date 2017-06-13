//
//  PrivateGroupWithThreadsControllerHandler.swift
//  Houp
//
//  Created by Sebastian on 05.04.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension PrivateGroupWithThreadsController{
    
    func editGroup(){
        let controller = EditPrivateGroup()
        controller.privateGroup = self.privateGroup
        let editController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: controller,navBarTitle: "Gruppe bearbeiten", barItemTitle: nil, image: nil)
        present(editController, animated: true, completion: nil )
    }
    
    
    func handleCreateThread(){        
        let createController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: CreateGroupThreadController(), navBarTitle: "Thema erstellen", barItemTitle: nil, image: nil)
        self.present(createController, animated: true, completion: nil)
    }
    
    func getTopicThreads(groupID: String){
            if let view = DBConnection.shared.viewThreadByGroupID{
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
    
    func getTopicGroup(groupID: String){
        if let queryForPrivateGroup = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery(){
            queryForPrivateGroup.allDocsMode = CBLAllDocsMode.allDocs
            queryForPrivateGroup.keys = [groupID]
            self.liveQueryGroupDetails = queryForPrivateGroup.asLive()
            self.liveQueryGroupDetails?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            self.liveQueryGroupDetails?.start()
        }else{
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        do{
        if (object as! NSObject == self.liveQuery){
            
                if let rows = liveQuery!.rows {
                    //threadsList.removeAll()
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
                            let thread = Thread(props: props)
                            thread.userName = userName
                            
                            //new
                            TempStorageAndCompare.shared.compareAndSaveThreads(groupID: (self.privateGroup?.pgid)!, thread: thread)
                            //------
                            
                            //threadsList.append(thread)
                        }
                    }
                    //new
                    TempStorageAndCompare.shared.sortGroupsWithThreads(groupID: (self.privateGroup?.pgid)!)
                    //--
                    //                        threadsList.sort(by:
                    //                            { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedDescending }
                    //                        )
                    print("---------------------------------------------------")
                    print("---------------------------------------------------")
                    TempStorageAndCompare.shared.compareAndSaveGroups(group: self.privateGroup!)
                   
                   // self.groupCollectionView?.reloadData()
                    self.threadsCollectionView.reloadData()
                }
        }else if (object as! NSObject == self.liveQueryGroupDetails){
                if let rows = liveQueryGroupDetails?.rows {
                    while let row = rows.nextRow() {
                        if let props = row.document!.properties {
                            let prGroup = PrivateGroup(props: props)
                            prGroup.pgid = row.documentID
                            prGroup.rev = row.documentRevisionID
                            self.privateGroup = prGroup
                            print("hier mann")
                            TempStorageAndCompare.shared.compareAndSaveGroups(group: prGroup)
                        }
                    }
                }

        }
        }catch{
            self.threadsList = [Thread]()
            self.threadsCollectionView.reloadData()
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        liveQuery?.removeObserver(self, forKeyPath: "rows")
        liveQueryGroupDetails?.removeObserver(self, forKeyPath: "rows")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(liveQuery != nil){
            liveQuery?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
        }
        if(liveQueryGroupDetails != nil){
            liveQueryGroupDetails?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
        }
        
    }
    
    func handleActivitiesInGroup(){
        let controller = ShowActivitiesInPrivateGroupController()
        controller.privateGroup = self.privateGroup
        controller.title = "Erfolgreiche Aktivitäten"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleUsersInGroup(){
        let controller = PrivateGroupRequestAndMembersList()
        controller.privateGroup = self.privateGroup
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
