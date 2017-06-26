//
//  TempStorageAndCompare.swift
//  Houp
//
//  Created by Sebastian on 29.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import UIKit

class TempStorageAndCompare: NSObject{

    static var shared: TempStorageAndCompare = TempStorageAndCompare()
    let userDefaults = UserDefaults.standard
    var timerObject: TimerObject?
    var privateGroupCollectionDelegate: PrivateGroupCollectionViewController?
    var privateGroupsWithThreadsDelegate: PrivateGroupWithThreadsController?
    var publicGroupsWithThreadsControllerDelegate: PublicGroupThreadsController?
    var publicGroupThreadWithCommentsDelegate: PublicGroupThreadWithComments?
    var activityWithCommentsDelegate: ActivitiesCommentsController?
    var activityWeekCollectionDelegate: ActivityWeekCollection?
    var activityCommentsDelegate: ActivitiesCommentsController?
    var activitiesInPrivateGroupDelegate: ShowActivitiesInPrivateGroupController?
    var liveQueryUser: CBLLiveQuery?
    var liveQueryGroups: CBLLiveQuery?
    var liveQueryThreadsOfUser: CBLLiveQuery?
    var liveQueryPublicThreads: CBLLiveQuery?
    var liveQueryPrivateThreads: CBLLiveQuery?
    var liveQueryActiveActivities: CBLLiveQuery?
    var liveQueryInactiveActivities: CBLLiveQuery?

    var tempGroupList: [String] = [String]()
    var tempActivityIDList: [String] = [String]()
    var userID: String?
    
    func initialiseNotificationQueries(userID: String){
        self.userID = userID
        getTopicUser(userID: userID)
        getTopicThreads(authorID: userID)
        getTopicThreadsOfPublicGroup()
        getTopicActiveActivitiesOfUser()
        }
    
    func deinitialiseNotificationQueries(){
        self.liveQueryThreadsOfUser?.removeObserver(self, forKeyPath: "rows")
        self.liveQueryUser?.removeObserver(self, forKeyPath: "rows")
        self.liveQueryPublicThreads?.removeObserver(self, forKeyPath: "rows")
        self.liveQueryActiveActivities?.removeObserver(self, forKeyPath: "rows")
        self.liveQueryActiveActivities = nil
        self.liveQueryPublicThreads = nil
        self.liveQueryThreadsOfUser = nil
        self.liveQueryUser = nil
        self.tempGroupList = [String]()
        self.userID = nil
        if(self.liveQueryGroups != nil){
        self.liveQueryGroups?.removeObserver(self, forKeyPath: "rows")
        self.liveQueryGroups = nil
        }
        if(self.liveQueryPrivateThreads != nil){
            self.liveQueryPrivateThreads?.removeObserver(self, forKeyPath: "rows")
            self.liveQueryPrivateThreads = nil
        }
        if(self.liveQueryInactiveActivities != nil){
            self.liveQueryInactiveActivities?.removeObserver(self, forKeyPath: "rows")
            self.liveQueryInactiveActivities = nil
        }
    }
    
    // Hier werden die LiveQueries aufgebaut
    func getTopicActiveActivitiesOfUser(){
        if let view = DBConnection.shared.viewByActiveActivityForUser{
            let query = view.createQuery()
            query.keys = [getUserID()]
            liveQueryActiveActivities = query.asLive()
            liveQueryActiveActivities?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQueryActiveActivities?.start()
        }
    }
    
    func getTopicInactiveActivitiesOfGroups(groupIDs: [String]){
        if let view = DBConnection.shared.viewByInactiveActivityForGroup{
            let query = view.createQuery()
            query.keys = groupIDs
            liveQueryInactiveActivities = query.asLive()
            liveQueryInactiveActivities?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQueryInactiveActivities?.start()
        }
    }
    
    func getPrivateGroupsTopicThreads(groupIDs: [String]){
        if let view = DBConnection.shared.viewThreadByGroupID{
            let query = view.createQuery()
            query.keys = groupIDs
            liveQueryPrivateThreads = query.asLive()
            liveQueryPrivateThreads?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQueryPrivateThreads?.start()
        }
    }
    
    func getTopicGroups(groupIDs: [String]){
        if let query = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery(){
            query.allDocsMode = CBLAllDocsMode.allDocs
            query.keys = groupIDs
            liveQueryGroups = query.asLive()
            liveQueryGroups?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQueryGroups?.start()
        }
    }
    
    func getTopicThreadsOfPublicGroup(){
        if let view = DBConnection.shared.viewThreadByGroupID{
            let query = view.createQuery()
            query.keys = ["0"]
            liveQueryPublicThreads = query.asLive()
            liveQueryPublicThreads?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQueryPublicThreads?.start()
        }
    }
    
    func getTopicUser(userID: String){
        if let query = DBConnection.shared.getDBConnection()?.createAllDocumentsQuery(){
            query.allDocsMode = CBLAllDocsMode.allDocs
            query.keys = [userID]
            liveQueryUser = query.asLive()
            liveQueryUser?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQueryUser?.start()
        }
    }
    
    func getTopicThreads(authorID: String){
        if let view = DBConnection.shared.viewThreadByAuthorID{
        let query = view.createQuery()
            query.keys = [authorID]
            liveQueryThreadsOfUser = query.asLive()
            liveQueryThreadsOfUser?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQueryThreadsOfUser?.start()
        }
    }
    
    // Hier wird nach neuen Einträgen abgehört
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        do{
            if (object as! NSObject == self.liveQueryThreadsOfUser){
                if let rows = liveQueryThreadsOfUser!.rows {
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
                            compareAndSaveThreads(groupID: thread.groupID!, thread: thread)
                        }
                    }
//                    if(thread != nil){
//                    sortGroupsWithThreads(groupID: (thread?.groupID)!)
//                    }
                    self.privateGroupCollectionDelegate?.privateGroupsCollection.reloadData()
                    self.privateGroupsWithThreadsDelegate?.threadsCollectionView.reloadData()
                }
            }else if (object as! NSObject == self.liveQueryGroups){
                var privateGroup: PrivateGroup?
                if let rows = liveQueryGroups?.rows {
                    while let row = rows.nextRow() {
                        if let props = row.document!.properties {
                                    privateGroup = PrivateGroup(props: props)
                                    privateGroup?.pgid = row.documentID
                                    privateGroup?.rev = row.documentRevisionID
                        }
                        compareAndSaveGroups(group: privateGroup!)
                    }
                    self.privateGroupCollectionDelegate?.privateGroupsCollection.reloadData()
                }
            }else if(object as! NSObject == self.liveQueryUser){
                if let rows = liveQueryUser?.rows {
                    while let row = rows.nextRow() {
                        if let props = row.document!.properties {
                            
                            var groupIDs: [String] = [String]()
                            if let IDs = props["groupIDs"] as! [String]?{
                                groupIDs = IDs
                            }
                            let user = UserObject(props: props)
                            self.tempGroupList = groupIDs
                            compareAndSaveUsers(user: user)
                            //self.groupCollectionDelegate?.privateGroupsCollection.reloadData()
//                            //self.tempGroupList = groupIDs
//                            groupsChangedOnDB(groupIDs: self.tempGroupList)
                        }
                    }
                }
            }else if(object as! NSObject == self.liveQueryPublicThreads){
                if let rows = liveQueryPublicThreads?.rows {
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
                            compareAndSaveThreads(groupID: "0", thread: thread)
                            //compareAndSavePublicThreads(thread: thread)
                        }
                    }
                    self.publicGroupsWithThreadsControllerDelegate?.threadsCollectionView.reloadData()
                }
            }else if(object as! NSObject == self.liveQueryPrivateThreads){
                if let rows = liveQueryPrivateThreads?.rows {
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
                            compareAndSaveThreads(groupID: thread.groupID!, thread: thread)
                            //compareAndSavePublicThreads(thread: thread)
                        }
                    }
                    self.privateGroupsWithThreadsDelegate?.threadsCollectionView.reloadData()
                    self.privateGroupCollectionDelegate?.privateGroupsCollection.reloadData()
                }
            }else if (object as! NSObject == self.liveQueryActiveActivities){
                var tempActivityIDs: [Activity] = [Activity]()
                if(liveQueryActiveActivities?.rows?.count != 0){
                if let rows = liveQueryActiveActivities?.rows {
                    while let row = rows.nextRow() {
                        if let props = row.document!.properties {
                           let activity = Activity(props: props)
                            tempActivityIDs.append(activity)
                        }
                    }
                    compareAndSaveActivitiesOfCurrentWeek(currentActivities: tempActivityIDs)
                    self.activityWeekCollectionDelegate?.activityCollectionView.reloadData()
                    }
                }else{
                    deleteAllActivitiesForCurrentWeek()
                    self.activityWeekCollectionDelegate?.activityCollectionView.reloadData()
                }
            }
            else if (object as! NSObject == self.liveQueryInactiveActivities){
                if let rows = liveQueryInactiveActivities?.rows {
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

                            let activity = Activity(props: props)
                            activity.userName = userName
                            compareAndSaveActivities(activity: activity)
                        }
                    }
                    self.activitiesInPrivateGroupDelegate?.activityCollectionView.reloadData()
                }
            }
        }catch{
            print("Fehler")
        }
    }

    //---------------------------------------------------------------------------------------
    // Datenbankeinträge des Users XY löschen
    //---------------------------------------------------------------------------------------
    func deleteEverything(userIDs: [String]){
        for item in userIDs {
            self.userDefaults.removeObject(forKey:"groupsWithThreadsSync\(item)")
            self.userDefaults.removeObject(forKey:"privateGroupsSync\(item)")
            self.userDefaults.removeObject(forKey: "userObjectsSync\(item)")
            self.userDefaults.removeObject(forKey: "publicGroupThreads\(item)")
            self.userDefaults.removeObject(forKey: "activitiesOfUser\(item)")
            self.userDefaults.removeObject(forKey: "activitiesOfCurrentWeek\(item)")
        }
    }
    //---------------------------------------------------------------------------------------
    //---------------------------------------------------------------------------------------
}
