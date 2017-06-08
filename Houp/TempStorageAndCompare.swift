//
//  TempStorageAndCompare.swift
//  Houp
//
//  Created by Sebastian on 29.05.17.
//  Copyright © 2017 SP. All rights reserved.
//

import Foundation

class TempStorageAndCompare: NSObject{

    static let shared: TempStorageAndCompare = TempStorageAndCompare()
    let userDefaults = UserDefaults.standard
    var groupCollectionDelegate: PrivateGroupCollectionViewController?
    var liveQueryUser: CBLLiveQuery?
    var liveQueryGroups: CBLLiveQuery?
    var liveQueryThreadsOfUser: CBLLiveQuery?
    var tempGroupList: [String] = [String]()
    
    
    func initialiseNotificationQueries(userID: String){
        if(liveQueryUser == nil){
            getTopicUser(userID: userID)
        }
        if(liveQueryThreadsOfUser == nil){
            getTopicThreads(authorID: userID)
        }
    }
    
    func groupsChangedOnDB(){
        if(self.liveQueryGroups != nil){
        self.liveQueryGroups?.removeObserver(self, forKeyPath: "rows")
        }
        getTopicGroups(groupIDs: self.tempGroupList)
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
        if let view = DBConnection.shared.viewByThreadByAuthorID{
        let query = view.createQuery()
            query.keys = [authorID]
            liveQueryThreadsOfUser = query.asLive()
            liveQueryThreadsOfUser?.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            liveQueryThreadsOfUser?.start()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
         var thread: Thread?
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
                            thread = Thread(props: props)
                            thread?.userName = userName
                            
                            compareAndSaveThreads(groupID: (thread?.groupID)!, thread: thread!)
                        }
                    }
                    if(thread != nil){
                    sortGroupsWithThreads(groupID: (thread?.groupID)!)
                    }
                    self.groupCollectionDelegate?.privateGroupsCollection.reloadData()
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
                        if(privateGroup != nil){
                        compareAndSaveGroups(group: privateGroup!)
                        }
                        self.groupCollectionDelegate?.privateGroupsCollection.reloadData()
                    }
                }
            }else if(object as! NSObject == self.liveQueryUser){
                if let rows = liveQueryUser?.rows {
                    while let row = rows.nextRow() {
                        if let props = row.document!.properties {
                            
                            var groupIDs: [String] = [String]()
                            if let IDs = props["groupIDs"] as! [String]?{
                                groupIDs = IDs
                            }
                            if (groupIDs.count != 0){
                             self.tempGroupList = groupIDs
                            }
                        }
                    }
                }
                groupsChangedOnDB()
            }
        }catch{
            print("Fehler")
        }
    }

    func compareAndSaveGroups(group: PrivateGroup){
        
        if (getAllPrivateGroupsSync().count != 0) {
        var oldList: [PrivateGroup] = getAllPrivateGroupsSync()
        if let index = oldList.index(where: { (item) -> Bool in
            item.pgid == group.pgid
        }){
            // check if revision changed, if yes then hasbeenupdated = true
            if((oldList[index].rev != group.rev) || anyThreadOfGroupWasUpdated(group: oldList[index])){
                group.hasBeenUpdated = true
                oldList[index] = group
                saveGroupList(groupList: oldList)
                //hier eventuell event triggern und collection view updaten
            }else{
                group.hasBeenUpdated = false
                oldList[index] = group
                saveGroupList(groupList: oldList)
            }
        }else{
            group.hasBeenUpdated = true
            oldList.append(group)
            saveGroupList(groupList: oldList)
        }
        }else{
            saveGroupList(groupList: [group])
        }
    }
    
    func anyThreadOfGroupWasUpdated(group: PrivateGroup) -> Bool{
      let temp = getAllThreadsOfGroup(groupID: group.pgid!)
        for thread in temp {
            if(thread.hasBeenUpdated){
                return true
            }
        }
    return false
    }
    
    func anyGroupWasUpdated(group: PrivateGroup) -> Bool{
        let temp = getAllPrivateGroupsSync()
        for group in temp {
            if(group.hasBeenUpdated){
                return true
            }
        }
        return false
    }

    
    func compareAndSaveThreads(groupID: String, thread: Thread){
        if(getAllGroupsWithThreads().count != 0){
            var oldList = getAllGroupsWithThreads()
            if let groupExists = oldList[groupID]{
                if let index = oldList[groupID]?.index(where: { (item) -> Bool in
                    item.tid == thread.tid
                }){
                    // check if revision changed, if yes then hasbeenupdated = true
                    if(oldList[groupID]?[index].rev != thread.rev){
                        thread.hasBeenUpdated = true
                        oldList[groupID]?[index] = thread
                        saveGroupsWithThreads(groupsWithThreads: oldList)
                    }
                }else{
                    thread.hasBeenUpdated = true
                    oldList[groupID]?.append(thread)
                    saveGroupsWithThreads(groupsWithThreads: oldList)
                }
            }else{
                thread.hasBeenUpdated = true
                oldList[groupID] = [thread]
                saveGroupsWithThreads(groupsWithThreads: oldList)
            }
        }else{
            let newItem = [groupID : [thread]]
            saveGroupsWithThreads(groupsWithThreads: newItem)
        }
    }
    
    func saveGroupsWithThreads(groupsWithThreads: [String : [Thread]]){
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: groupsWithThreads)
        self.userDefaults.set(encodedData, forKey: "groupsWithThreadsSync")
        self.userDefaults.synchronize()
    }
    
    func getAllGroupsWithThreads() -> [String : [Thread]]{
        var oldGroupsThreadsList: [String : [Thread]] = [String : [Thread]]()
        if let oldList  = self.userDefaults.object(forKey: "groupsWithThreadsSync") as? Data{
            oldGroupsThreadsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [String : [Thread]]
        }
        return oldGroupsThreadsList
    }
    
    func getAllThreadsOfGroup(groupID: String) -> [Thread]{
        var oldGroupsThreadsList: [String : [Thread]] = [String : [Thread]]()
        if let oldList  = self.userDefaults.object(forKey: "groupsWithThreadsSync") as? Data{
            oldGroupsThreadsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [String : [Thread]]
            if let temp = oldGroupsThreadsList[groupID]{
                return temp
            }else{
            return [Thread]()
            }
        }
        return [Thread]()
    }
    
    func saveAllThreadsOfGroup(groupID: String, threads: [Thread]){
        var oldGroupsThreadsList: [String : [Thread]] = [String : [Thread]]()
        if let oldList  = self.userDefaults.object(forKey: "groupsWithThreadsSync") as? Data{
            oldGroupsThreadsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [String : [Thread]]
            oldGroupsThreadsList[groupID]! = threads
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: oldGroupsThreadsList)
            self.userDefaults.set(encodedData, forKey: "groupsWithThreadsSync")
            self.userDefaults.synchronize()
        }
    }

    func sortGroupsWithThreads(groupID: String){
        var oldGroupsThreadsList: [String : [Thread]] = [String : [Thread]]()
        if let oldList  = self.userDefaults.object(forKey: "groupsWithThreadsSync") as? Data{
            oldGroupsThreadsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [String : [Thread]]
            oldGroupsThreadsList[groupID]?.sort(by:
                { $0.dateObject?.compare($1.dateObject!) == ComparisonResult.orderedDescending }
            )
        }
    saveGroupsWithThreads(groupsWithThreads: oldGroupsThreadsList)
    }
    
    func sortGroups(){
        var oldPrivateGroupsList: [PrivateGroup] = [PrivateGroup]()
        if let oldList  = self.userDefaults.object(forKey: "privateGroupsSync") as? Data{
            oldPrivateGroupsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [PrivateGroup]
        }
        oldPrivateGroupsList.sort(by:
            { $0.createdAt?.compare($1.createdAt!) == ComparisonResult.orderedDescending }
        )
        saveGroupList(groupList: oldPrivateGroupsList)
    }
    
    func saveGroupList(groupList: [PrivateGroup]){
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: groupList)
        self.userDefaults.set(encodedData, forKey: "privateGroupsSync")
        self.userDefaults.synchronize()
    }
    
    func saveSingleGroup(group: PrivateGroup, hasBeenUpdated: Bool){
        var oldPrivateGroupsList: [PrivateGroup] = [PrivateGroup]()
        if let oldList  = self.userDefaults.object(forKey: "privateGroupsSync") as? Data{
            oldPrivateGroupsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [PrivateGroup]
        }
        if let index = oldPrivateGroupsList.index(where: { (item) -> Bool in
            item.pgid == group.pgid
        }){
            let tempGroup = group
            group.hasBeenUpdated = hasBeenUpdated
            oldPrivateGroupsList[index] = tempGroup
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: oldPrivateGroupsList)
            self.userDefaults.set(encodedData, forKey: "privateGroupsSync")
            self.userDefaults.synchronize()
        }
    }
    

    func getAllPrivateGroupsSync() -> [PrivateGroup] {
    var oldPrivateGroupsList: [PrivateGroup] = [PrivateGroup]()
    if let oldList  = self.userDefaults.object(forKey: "privateGroupsSync") as? Data{
        oldPrivateGroupsList = NSKeyedUnarchiver.unarchiveObject(with: oldList) as! [PrivateGroup]
    }
    return oldPrivateGroupsList
    }

    func setHasBeenUpdatedStatusOfThread(groupID: String, threadID: String, hasBeenUpdated: Bool){
        if let index = getAllThreadsOfGroup(groupID: groupID).index(where: { (item) -> Bool in
            item.tid == threadID
        }){
            let temp = getAllGroupsWithThreads()
            temp[groupID]?[index].hasBeenUpdated = hasBeenUpdated
            saveGroupsWithThreads(groupsWithThreads: temp)
        }
    }
    
    func setHasBeenUpdatedStatusOfGroup(groupID: String, hasBeenUpdated: Bool){
        if let index = getAllPrivateGroupsSync().index(where: { (item) -> Bool in
            item.pgid == groupID
        }){
            getAllPrivateGroupsSync()[index].hasBeenUpdated = hasBeenUpdated
        }
    }
    
    func deleteEverything(){
        self.userDefaults.removeObject(forKey:"groupsWithThreadsSync")
        self.userDefaults.removeObject(forKey:"privateGroupsSync")
    }
}
