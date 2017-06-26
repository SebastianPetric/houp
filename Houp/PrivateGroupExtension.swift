//
//  PrivateGroupExtension.swift
//  Houp
//
//  Created by Sebastian on 30.03.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

extension PrivateGroupCollectionViewController{

    func handleCreateNewPrivateGroup(){
        let createController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: CreatePrivateGroupViewController(),navBarTitle: GetString.createPrivateGroup.rawValue, barItemTitle: nil, image: nil)
        present(createController, animated: true, completion: nil )
    }
    
    func handleMakeRequestPrivateGroup(){
        let controller = MakeRequestPrivateGroupViewController()
        controller.navController = self.navigationController
        let createController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: controller,navBarTitle: GetString.makeRequestToPrivateGroup.rawValue, barItemTitle: nil, image: nil)
        present(createController, animated: true, completion: nil )
    }
    
    func getTopicGroups(userID: String){
        if let query = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery(){
            query.allDocsMode = CBLAllDocsMode.allDocs
            query.keys = [userID]
            liveQuery = query.asLive()
            liveQuery?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQuery?.start()
        }else{
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getTopicThreads(groupID: [String]){
        if let view = DBConnection.shared.viewThreadByGroupID{
            let query = view.createQuery()
            query.keys = groupID
            liveQueryThreads = query.asLive()
            liveQueryThreads?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQueryThreads?.start()
        }else{
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        do{
            
            if (object as! NSObject == self.liveQuery){
                if let rows = liveQuery?.rows {
                    //privateGroupsList.removeAll()
                    while let row = rows.nextRow() {
                        if let props = row.document!.properties {
                            
                            var groupIDs: [String] = [String]()
                            if let IDs = props["groupIDs"] as! [String]?{
                                groupIDs = IDs
                            }
                            
                            if (groupIDs.count != 0){
                                let queryForGroups = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery()
                                queryForGroups?.allDocsMode = CBLAllDocsMode.allDocs
                                queryForGroups?.keys = groupIDs
                                let privateGroups = try queryForGroups?.run()
                                while let props = privateGroups?.nextRow()?.document {
                                    let properties = props.properties
                                    let privateGroup = PrivateGroup(props: properties!)
                                    privateGroup.pgid = props.documentID
                                    privateGroup.rev = props.currentRevisionID
                                    //new----
                                    print("das wird nicht aufgerufen")
                                    TempStorageAndCompare.shared.compareAndSaveGroups(group: privateGroup)
                                    //------
                                    //self.privateGroupsList.append(privateGroup)
                                }
                            }
                        }
                    }
                    //new
                    TempStorageAndCompare.shared.sortGroups()
                    //------
                    
                    //                        privateGroupsList.sort(by:
                    //                            { $0.createdAt?.compare($1.createdAt!) == ComparisonResult.orderedDescending }
                    //                        )
                    self.privateGroupsCollection.reloadData()
                }
            }else if(object as! NSObject == self.liveQueryThreads){
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
                            if(self.privateGroupsList.count != 0){
                                TempStorageAndCompare.shared.compareAndSaveThreads(groupID: thread.groupID!, thread: thread)
                                TempStorageAndCompare.shared.sortGroupsWithThreads(groupID: thread.groupID!)
                            }
                            //------
                            
                            //threadsList.append(thread)
                        }
                    }
                    //                        threadsList.sort(by:
                    //                            { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedDescending }
                    //                        )
                    self.privateGroupsCollection.reloadData()
                }
            }
        }catch{
            self.privateGroupsList = [PrivateGroup]()
            self.privateGroupsCollection.reloadData()
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        if(liveQuery != nil){
//                        liveQuery?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
//        }
        self.privateGroupsCollection.reloadData()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        liveQuery?.removeObserver(self, forKeyPath: "rows")
//        liveQueryThreads?.removeObserver(self, forKeyPath: "rows")
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        if(liveQuery != nil){
//            liveQuery?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
//        }
//    }
}
