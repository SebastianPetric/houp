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
        let createController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: CreatePrivateGroupViewController(),navBarTitle: GetString.privateGroup.rawValue, barItemTitle: nil, image: nil)
        present(createController, animated: true, completion: nil )
    }
    
    func handleMakeRequestPrivateGroup(){
        let createController = CustomNavigationBarController.shared.getCustomNavControllerWithNameAndImage(customController: MakeRequestPrivateGroupViewController(),navBarTitle: GetString.makeRequestToPrivateGroup.rawValue, barItemTitle: nil, image: nil)
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        do{
            if keyPath == "rows" {
                if let rows = liveQuery?.rows {
                    privateGroupsList.removeAll()
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
                                    self.privateGroupsList.append(privateGroup)
                                }
                            }
                        }
                        privateGroupsList.sort(by:
                            { $0.createdAt?.compare($1.createdAt!) == ComparisonResult.orderedDescending }
                        )
                        self.privateGroupsCollection.reloadData()
                    }
                }
            }
        }catch{
            self.privateGroupsList = [PrivateGroup]()
            self.privateGroupsCollection.reloadData()
            let alert = CustomViews.shared.getCustomAlert(errorTitle: GetString.errorTitle.rawValue, errorMessage: GetString.errorWithConnection.rawValue, firstButtonTitle: GetString.errorOKButton.rawValue, secondButtonTitle: nil, firstHandler: nil, secondHandler: nil)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}
