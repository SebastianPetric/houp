//
//  PublicGroupThreadsHandler.swift
//  Houp
//
//  Created by Sebastian on 04.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

extension PublicGroupThreadsController{

    func handleCreateThread(){
        let createController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: CreateGroupThreadController(), navBarTitle: "Thema erstellen", barItemTitle: nil, image: nil)
        self.present(createController, animated: true, completion: nil)
    }
    
    func getTopicThreads(groupID: String){
            if let view = DBConnection.shared.viewByThread{
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
                if let rows = liveQuery!.rows {
                    threadsList.removeAll()
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
                            threadsList.append(thread)
                        }
                        threadsList.sort(by:
                            { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedDescending }
                        )
                        self.threadsCollectionView.reloadData()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(liveQuery != nil){
            liveQuery?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
        }
    }
}
